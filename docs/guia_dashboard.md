# Regras do Negócio - Projeto Olist

Este documento consolida as regras de negócio usadas no tratamento dos dados, na camada Gold e no dashboard Power BI. O objetivo é deixar claro como os dados devem ser interpretados, quais cálculos são válidos e quais limites de análise devem ser respeitados.

---

## 1. Arquitetura dos Dados

| Camada | Regra de Negócio |
| :--- | :--- |
| **Raw** | Mantém os arquivos CSV originais da Olist em `data/raw`. |
| **Bronze** | Converte os dados brutos para Parquet, preservando a estrutura original. |
| **Silver** | Aplica tipagem, padronização, limpeza básica e regras de qualidade. |
| **Gold** | Cria fatos e dimensões finais, servindo como a fonte oficial para consumo analítico e Power BI. |

---

## 2. Regras Gerais de Tratamento

* IDs e chaves de relacionamento devem ser mantidos como texto.
* Chaves principais nulas ou vazias devem ser removidas nas tabelas em que a chave é obrigatória.
* Prefixos de CEP devem ser mantidos como texto para preservar zeros à esquerda.
* Campos de estado/UF devem ser padronizados em maiúsculo.
* Campos de cidade devem ter uma versão normalizada para relacionamento e uma versão de exibição com a grafia oficial do IBGE quando houver correspondência.
* Datas vazias devem ser convertidas para `NULL`.
* Valores textuais sem informação devem ser tratados como `nao_informado` na camada Silver ou `Não informado` na camada Gold, conforme a regra de exibição.
* Valores monetários devem usar o tipo decimal.

---

## 3. Tabelas Gold do Modelo Power BI

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

## 4. Clientes e Recompra

* `cliente_id` identifica o cliente no contexto de um pedido e deve ser usado no relacionamento entre `fato_pedidos` e `dim_cliente`.
* `cliente_unico_id` identifica o cliente final e deve ser usado exclusivamente para métricas de clientes únicos, recorrência e recompra. Ele não deve ser usado como chave de relacionamento com `dim_cliente` para evitar relações muitos-para-muitos.
* Cliente recorrente é definido pelo `cliente_unico_id` com mais de um pedido.
* A taxa de recompra é calculada dividindo os clientes recorrentes pelos clientes únicos.

---

## 5. Pedidos, Receita e Ticket Médio

* `fato_pedidos` é a tabela fato principal do modelo, e o identificador oficial do pedido é `pedido_id`.
* O faturamento total utiliza a soma de `fato_pedidos[valor_pago]` (agregado dos pagamentos), enquanto o `valor_produtos` e o `valor_frete` são agregados a partir dos itens do pedido. 
* Se não houver itens ou pagamentos associados ao pedido, os valores agregados devem receber `0`.
* O ticket médio é o faturamento total dividido pelo total de pedidos (que utiliza a contagem distinta de `pedido_id`).

---

## 6. Entrega e Atraso

* `dias_ate_entrega` mede a diferença entre a data da compra e a data real de entrega ao cliente.
* A classificação de `faixa_dias_ate_entrega` inclui: `Até 3 dias`, `4 a 6 dias`, `7 a 10 dias`, `11 a 14 dias`, `15 a 30 dias`, `Maior que 30 dias` e `Não informado`.
* O status `entrega_atrasada` define se um pedido atrasou (`Sim` se a entrega real for maior que a estimada), chegou no prazo (`Não` se for menor ou igual) ou está com a data real ausente (`Não informado`).
* O status `Não informado` deve continuar visível nas análises de entrega para representar pedidos sem dados completos, mas a taxa de atraso deve desconsiderar esses pedidos de seu cálculo.

---

## 7. Avaliações e Satisfação

* A nota de avaliação e a nota média devem ser calculadas diretamente pela tabela `fato_avaliacoes`, nunca pela tabela de pedidos.
* A contagem de avaliações deve usar `COUNTROWS(fato_avaliacoes)`, baseando-se na chave conceitual de `avaliacao_id + pedido_id` (já que o `avaliacao_id` isolado pode se repetir na origem).
* Para análises de classificação e NPS aproximado, os agrupamentos são consolidados como: Negativa/Detrator (notas 1 e 2), Neutra/Neutro (nota 3), Positiva/Promotor (notas 4 e 5) e `Não informado` (ausente ou fora da regra).
* O campo `tem_comentario` recebe `Sim` quando o título ou a mensagem existem e `Não` caso contrário. A camada Gold não expõe o conteúdo textual ou as datas das avaliações.

---

## 8. Itens, Produtos e Categorias

* A tabela `fato_itens_pedido` representa cada item vendido separadamente, portanto a `quantidade_item` sempre é `1` por linha. A receita e os itens totais vendidos vêm da soma de `preco_item` e `quantidade_item`.
* A dimensão `dim_produto` exibe a categoria traduzida amigável e utiliza a categoria original como fallback na ausência de tradução.
* O volume do produto (`volume_cm3`) é a multiplicação de comprimento, altura e largura.
* As faixas de peso são: `Não informado` (igual a 0), `Até 500g`, `501g a 1kg`, `1kg a 5kg` e `Acima de 5kg`.
* A página de categorias do dashboard foi projetada exclusivamente para avaliar a performance comercial por faturamento e itens vendidos; ela não avalia experiência, satisfação ou entrega por categoria.

---

## 9. Pagamentos

* A tabela `fato_pagamentos` pode conter múltiplas linhas (pagamentos) por pedido; contagens de pedidos nesta tabela exigem a contagem distinta de `pedido_id`.
* Os tipos de pagamento disponíveis são `Cartão de crédito`, `Cartão de débito`, `Boleto`, `Voucher` e `Não informado`. A tabela `dim_pagamento` simplifica esse agrupamento para `Cartão`, `Boleto`, `Voucher` e `Não informado`.
* A faixa de parcelas engloba desde `0 parcelas` até `Acima de 12 parcelas`.

---

## 10. Geolocalização

* A geolocalização se baseia no prefixo de CEP para formatar as dimensões contendo cidade, estado, latitude e longitude médias.
* Essas coordenadas representam uma aproximação analítica para mapas agregados e não devem ser interpretadas como localizações exatas.

---

## 11. Tempo e Filtros do Dashboard

* O relacionamento temporal se apoia em `dim_tempo[data]` conectado a `fato_pedidos[data_pedido]`.
* Os filtros globais ativos no dashboard são: Ano, Mês e Estado. A Categoria do produto não funciona como um filtro global nesta versão.

---

## 12. Avaliação de Hipóteses e Regras de Leitura

* O dashboard está estruturado para testar hipóteses diretamente observáveis, como o aumento das vendas (mês a mês, faturamento e total de pedidos), a retenção de clientes (base de clientes e taxa de recompra), o impacto da entrega na satisfação (notas cruzadas com dias de entrega e status de atraso) e variações regionais dessas métricas.
* Algumas análises **não** são realizadas no relatório atual: o cruzamento de recompra com notas de satisfação ou tempo de entrega, e a avaliação de satisfação e entrega isolada por categoria de produto.
* Todas as métricas dependem dos filtros ativos de Ano, Mês e Estado. As correlações de satisfação e entrega sugerem associação analítica e não uma prova isolada de causalidade.
* As fórmulas DAX completas do painel estão documentadas no arquivo `power_bi/medidas_dashboard.md`.