# Regras do Negócio - Projeto Olist

Este documento consolida as regras de negócio usadas no tratamento dos dados, na camada Gold e no dashboard Power BI. O objetivo é deixar claro como os dados devem ser interpretados, quais cálculos são válidos e quais limites de análise devem ser respeitados.

---

## 1. Arquitetura dos Dados

| Camada | Regra de Negócio |
| :--- | :--- |
| **Reference** | Armazena dados externos de referência usados para enriquecer e padronizar as camadas analíticas. |
| **Raw** | Mantém os arquivos CSV originais da Olist em `data/raw`. |
| **Bronze** | Converte os dados brutos para Parquet, preservando a estrutura original. |
| **Silver** | Aplica tipagem, padronização, limpeza básica e regras de qualidade. |
| **Gold** | Cria fatos e dimensões finais para consumo analítico e Power BI. |

A camada Gold é a fonte oficial para o dashboard.

---

## 2. Dados de Referência

- A pasta `data/reference` armazena bases auxiliares externas ao dataset original da Olist.
- O arquivo `data/reference/municipios_ibge.parquet` é gerado pelo script `api_ibge.py` a partir da API pública de municípios do IBGE.
- Esta base deve ser usada para padronizar nomes de cidades e UFs.
- O arquivo de referência contém os seguintes campos: `codigo_municipio_ibge`, `cidade_exibicao`, `cidade_normalizada`, `uf`, `nome_estado` e `regiao`.
- O campo `cidade_normalizada` deve ser usado para comparação e relacionamento, enquanto `cidade_exibicao` serve como o nome amigável/oficial da cidade nas camadas Silver, Gold e Power BI, quando houver correspondência.

---

## 3. Regras Gerais de Tratamento

- IDs e chaves de relacionamento devem ser mantidos como texto.
- Chaves principais nulas ou vazias devem ser removidas nas tabelas em que a chave é obrigatória.
- Prefixos de CEP devem ser mantidos como texto para preservar zeros à esquerda.
- Campos de estado/UF devem ser padronizados em maiúsculo.
- Campos de cidade devem ter uma versão normalizada para relacionamento e uma versão de exibição com a grafia oficial do IBGE quando houver correspondência.
- Datas vazias devem ser convertidas para `NULL`.
- Valores textuais sem informação devem ser tratados como `nao_informado` na camada Silver ou `Não informado` na camada Gold, conforme a regra de exibição.
- Valores monetários devem usar o tipo decimal.

---

## 4. Tabelas Gold do Modelo Power BI

| Tabela | Grão | Papel no Modelo |
| :--- | :--- | :--- |
| `fato_pedidos` | Uma linha por pedido. | Base de pedidos, clientes, faturamento, frete, entrega e atraso. |
| `fato_itens_pedido` | Uma linha por item vendido. | Base de produtos vendidos, receita de produtos, frete por item e vendedor. |
| `fato_pagamentos` | Uma linha por pagamento de pedido. | Base de tipos de pagamento, parcelas e valor pago. |
| `fato_avaliacoes` | Uma linha por avaliação de pedido. | Base de nota, classificação de satisfação e comentário. |
| `dim_cliente` | Uma linha por `cliente_id`. | Identificação e localização do cliente no pedido. |
| `dim_vendedor` | Uma linha por `vendedor_id`. | Identificação e localização do vendedor. |
| `dim_produto` | Uma linha por `produto_id`. | Categoria, atributos físicos e faixa de peso do produto. |
| `dim_pagamento` | Uma linha por tipo de pagamento. | Agrupamento de tipos de pagamento. |
| `dim_tempo` | Uma linha por data. | Calendário para filtros e evolução temporal. |
| `dim_geolocalizacao_clientes` | Uma linha por prefixo de CEP. | Cidade, estado e coordenadas dos clientes. |
| `dim_geolocalizacao_vendedores` | Uma linha por prefixo de CEP. | Cidade, estado e coordenadas dos vendedores. |
| `Medidas` | Tabela auxiliar. | Centraliza as medidas DAX do Power BI. |

---

## 5. Clientes e Recompra

- `cliente_id` identifica o cliente no contexto de um pedido e deve ser usado no relacionamento entre `fato_pedidos` and `dim_cliente`.
- `cliente_unico_id` identifica o cliente final e deve ser usado para métricas de clientes únicos, recorrência e recompra. Não deve ser usado como chave de relacionamento com `dim_cliente` para evitar relações muitos-para-muitos.
- Cliente recorrente é o `cliente_unico_id` com mais de um pedido.
- A taxa de recompra é calculada dividindo os clientes recorrentes pelos clientes únicos.

---

## 6. Pedidos, Receita e Ticket Médio

- `fato_pedidos` é a fato principal do modelo, onde o identificador oficial é `pedido_id`.
- O faturamento total do dashboard utiliza a soma de `fato_pedidos[valor_pago]`, que é agregado a partir dos pagamentos do pedido.
- Os campos `valor_produtos` e `valor_frete` são agregados a partir dos itens do pedido. Na ausência de itens ou pagamentos associados, esses valores agregados devem receber `0`.
- O ticket médio é calculado como faturamento total dividido pelo total de pedidos (contagem distinta de `pedido_id`).

---

## 7. Entrega e Atraso

- `dias_ate_entrega` mede a diferença entre a data da compra e a data real de entrega ao cliente.
- `faixa_dias_ate_entrega` classifica o prazo em: `Até 3 dias`, `4 a 6 dias`, `7 a 10 dias`, `11 a 14 dias`, `15 a 30 dias`, `Maior que 30 dias` e `Não informado`.
- O status `entrega_atrasada` define se um pedido atrasou (`Sim` se a entrega real for maior que a estimada), chegou no prazo (`Não` se for menor ou igual) ou se a data real de entrega está ausente (`Não informado`).
- O status `Não informado` deve permanecer visível nas análises de entrega para representar pedidos sem dados completos, mas a taxa de atraso deve desconsiderar esses casos no denominador do cálculo.

---

## 8. Avaliações e Satisfação

- A nota de avaliação e a nota média devem ser calculadas diretamente pela tabela `fato_avaliacoes`, nunca pela tabela de pedidos.
- A contagem de avaliações deve usar `COUNTROWS(fato_avaliacoes)`, baseando-se na chave conceitual `avaliacao_id + pedido_id` (já que o `avaliacao_id` isolado pode se repetir na origem).
- Para classificações e análises de NPS aproximado, as notas são agrupadas de forma unificada em: Negativa/Detrator (notas 1 e 2), Neutra/Neutro (nota 3), Positiva/Promotor (notas 4 e 5) e `Não informado` (nota fora da regra ou ausente).
- O campo `tem_comentario` recebe `Sim` quando o título ou a mensagem forem informados; caso contrário, `Não`.
- A camada Gold não expõe o conteúdo textual (título e mensagem) ou as datas das avaliações, pois o dashboard utiliza apenas análises agregadas de satisfação.

---

## 9. Itens, Produtos e Categorias

- A tabela `fato_itens_pedido` possui uma linha por item vendido, sendo a `quantidade_item` igual a `1` por linha. A receita de produtos e os itens vendidos totais vêm da soma de `preco_item` e `quantidade_item`, respectivamente.
- A dimensão `dim_produto` utiliza a categoria traduzida e amigável quando disponível, adotando a categoria original como fallback na ausência de tradução.
- O volume do produto (`volume_cm3`) é calculado por `comprimento_cm * altura_cm * largura_cm`.
- A faixa de peso segue a classificação: `Não informado` (peso igual a 0), `Até 500g`, `501g a 1kg`, `1kg a 5kg` e `Acima de 5kg`.
- A página de categorias do dashboard foi projetada exclusivamente para avaliar a performance comercial por faturamento e itens vendidos; ela não avalia experiência, satisfação ou entrega por categoria.

---

## 10. Pagamentos

- A tabela `fato_pagamentos` contém uma linha por pagamento de pedido, permitindo múltiplos pagamentos por pedido. Contagens de pedidos nesta tabela exigem a contagem distinta de `pedido_id`.
- Os tipos de pagamento são exibidos em português: `Cartão de crédito`, `Cartão de débito`, `Boleto`, `Voucher` e `Não informado`. A dimensão `dim_pagamento` simplifica esse agrupamento para `Cartão`, `Boleto`, `Voucher` e `Não informado`.
- A faixa de parcelas engloba as seguintes divisões: `0 parcelas`, `1 parcela`, `2 a 3 parcelas`, `4 a 6 parcelas`, `7 a 10 parcelas`, `11 a 12 parcelas` e `Acima de 12 parcelas`.

---

## 11. Geolocalização

- A geolocalização se baseia no prefixo de CEP para consolidar cidade, estado, latitude média e longitude média.
- `dim_geolocalizacao_clientes` e `dim_geolocalizacao_vendedores` apoiam análises e filtros geográficos. Quando complementadas por médias estaduais, as coordenadas funcionam como uma aproximação analítica para mapas agregados e não representam localizações exatas.

---

## 12. Tempo e Filtros do Dashboard

- A dimensão `dim_tempo` é criada a partir de `fato_pedidos[data_pedido]`, e o relacionamento temporal principal conecta `dim_tempo[data]` a `fato_pedidos[data_pedido]`.
- Os filtros globais ativos no dashboard são Ano, Mês e Estado. O campo Categoria não funciona como filtro global nesta versão.

---

## 13. Hipóteses do Dashboard

O dashboard foi estruturado para avaliar e testar hipóteses diretamente observáveis, bem como delimitar o escopo daquelas que não são cobertas na versão atual.

### Avaliadas diretamente

| Hipótese | Evidência no Dashboard |
| :--- | :--- |
| Estamos vendendo mais? | Evolução do faturamento total e do volume de pedidos mês a mês. |
| Os clientes continuam comprando conosco? | Análise de clientes únicos, clientes recorrentes e taxa de recompra. |
| A experiência de entrega impacta diretamente a satisfação? | Cruzamento da nota média por faixa de dias até a entrega. |
| Pedidos atrasados ou que demoram para chegar impactam a avaliação do cliente? | Comparação do total de pedidos e da nota média por status de atraso. |
| Atrasos afetam mais algumas regiões do que outras? | Tabela regional relacionando taxa de atraso, prazos, fretes, volumes e notas médias. |

### Não avaliadas diretamente no dashboard atual

| Hipótese | Motivo da Não Avaliação |
| :--- | :--- |
| Clientes satisfeitos têm maior potencial de recompra? | O modelo atual não cruza notas de avaliação com histórico de recompra do cliente. |
| Clientes que demoram para receber os produtos voltam a comprar? | O painel não correlaciona o tempo de entrega com eventos de recompra futuros. |
| Categorias de produto têm experiências diferentes? | A página de categorias é estritamente comercial (faturamento e volume), sem dados de notas ou prazos. |

---

## 14. Regras de Leitura no Power BI

- Todas as métricas devem respeitar os filtros ativos de Ano, Mês e Estado.
- Análises de satisfação e entrega indicam associação analítica, não causalidade isolada.
- Análises regionais devem ser interpretadas conjuntamente (volume de pedidos, taxa de atraso, frete, prazo médio e nota média).
- Não se deve assumir regras de volume mínimo para estados ou categorias se elas não estiverem visualmente implementadas.
- Não se deve afirmar que uma categoria possui melhor ou pior experiência se o visual correspondente avaliar apenas métricas de faturamento ou quantidade vendida.
- As fórmulas DAX completas estão documentadas no arquivo `power_bi/medidas_dashboard.md`.