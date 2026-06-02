# Dicionário de Dados - Camada Gold

## Modelagem de Dados: Tabelas Dimensão e Fato

A estrutura do modelo de dados foi dividida em dois tipos de tabelas, identificadas por seus prefixos:

* **Tabelas Dimensão (`dim_`):** Armazenam o contexto e os detalhes descritivos sobre as informações contidas na tabela fato. Elas contêm atributos qualitativos (como nome do cliente, categoria do produto, localização da loja e dados de calendário) e possuem registros com **chaves únicas** (sem duplicidade).
* **Tabelas Fato (`fato_`):** Armazenam os eventos, métricas ou transações do negócio. Elas contêm os dados quantitativos e mensuráveis (como valores de vendas, quantidades vendidas e tempo de atendimento), sendo compostas por chaves estrangeiras que se conectam às dimensões e pelos fatos numéricos.


## dim_cliente

Granularidade: uma linha por cliente.

| Coluna | Tipo | Descrição |
|---|---|---|
| cliente_id | VARCHAR | Identificador do cliente no pedido. |
| cliente_unico_id | VARCHAR | Identificador único do cliente final. |
| cep_prefixo_cliente | VARCHAR | Prefixo do CEP do cliente. |
| cidade_cliente | VARCHAR | Cidade do cliente em formato de exibição. |
| estado_cliente | VARCHAR | Estado do cliente. |

## dim_vendedor

Granularidade: uma linha por vendedor.

| Coluna | Tipo | Descrição |
|---|---|---|
| vendedor_id | VARCHAR | Identificador do vendedor. |
| cep_prefixo_vendedor | VARCHAR | Prefixo do CEP do vendedor. |
| cidade_vendedor | VARCHAR | Cidade do vendedor em formato de exibição. |
| estado_vendedor | VARCHAR | Estado do vendedor. |

## dim_pagamento

Granularidade: uma linha por tipo de pagamento.

| Coluna | Tipo | Descrição |
|---|---|---|
| tipo_pagamento | VARCHAR | Tipo de pagamento traduzido para português. Valores esperados: Cartão de crédito, Cartão de débito, Boleto, Voucher e Não informado. |
| categoria_pagamento | VARCHAR | Categoria agrupada do pagamento. Valores esperados: Cartão, Boleto, Voucher e Não informado. |

## dim_produto

Granularidade: uma linha por produto.

| Coluna | Tipo | Descrição |
|---|---|---|
| produto_id | VARCHAR | Identificador do produto. |
| categoria_produto | VARCHAR | Categoria do produto em formato de exibição, quando houver tradução disponível. |
| categoria_produto_ingles | VARCHAR | Categoria do produto em inglês ou categoria original quando não houver tradução. |
| quantidade_fotos | INTEGER | Quantidade de fotos cadastradas para o produto. |
| peso_g | INTEGER | Peso do produto em gramas. |
| comprimento_cm | INTEGER | Comprimento do produto em centímetros. |
| altura_cm | INTEGER | Altura do produto em centímetros. |
| largura_cm | INTEGER | Largura do produto em centímetros. |
| volume_cm3 | INTEGER | Volume do produto em centímetros cúbicos, calculado por comprimento, altura e largura. |
| faixa_peso | VARCHAR | Faixa de peso do produto: Não informado, Até 500 g, De 501 g a 1 kg, De 1 kg a 5 kg ou Acima de 5 kg. |

## dim_geolocalizacao_clientes

Granularidade: uma linha por prefixo de CEP.

| Coluna | Tipo | Descrição |
|---|---|---|
| cep_prefixo | VARCHAR | Prefixo do CEP usado para relacionamento com clientes. |
| cidade | VARCHAR | Cidade em formato de exibição. |
| estado | VARCHAR | Estado. |
| latitude_media | DECIMAL | Latitude média do prefixo de CEP. |
| longitude_media |

## fato_pagamentos

Granularidade: uma linha por pagamento de um pedido.

| Coluna | Tipo | Descrição |
|---|---|---|
| pedido_id | VARCHAR | Identificador do pedido associado ao pagamento. |
| sequencia_pagamento | INTEGER | Sequência do pagamento dentro do pedido. Ajuda a identificar pagamentos múltiplos para o mesmo pedido. |
| tipo_pagamento | VARCHAR | Tipo de pagamento traduzido para português. Valores esperados: Cartão de crédito, Cartão de débito, Boleto, Voucher e Não informado. |
| quantidade_parcelas | INTEGER | Quantidade de parcelas do pagamento. |
| faixa_parcelas | VARCHAR | Faixa agrupada da quantidade de parcelas: 0 parcelas, 1 parcela, 2 a 3 parcelas, 4 a 6 parcelas, 7 a 10 parcelas, 11 a 12 parcelas ou Acima de 12 parcelas. |
| valor_pagamento | DECIMAL(10,2) | Valor pago na linha de pagamento. |

Observações:
- Um mesmo `pedido_id` pode aparecer mais de uma vez quando o pedido possui múltiplos pagamentos.
- A chave conceitual da linha é `pedido_id + sequencia_pagamento`.
- Para contar pedidos nesta tabela, usar contagem distinta de `pedido_id`.

## fato_itens_pedido

Granularidade: uma linha por item vendido num pedido.

| Coluna | Tipo | Descrição |
|---|---|---|
| pedido_id | VARCHAR | Identificador do pedido. |
| sequencia_item | INTEGER | Sequência do item dentro do pedido. Ajuda a diferenciar itens repetidos no mesmo pedido. |
| produto_id | VARCHAR | Identificador do produto vendido. |
| vendedor_id | VARCHAR | Identificador do vendedor responsável pelo item. |
| preco_item | DECIMAL(10,2) | Preço do item vendido. |
| valor_frete | DECIMAL(10,2) | Valor do frete associado ao item. |
| quantidade_item | INTEGER | Quantidade representada pela linha. Como cada linha representa um item vendido, o valor é sempre 1. |

Observações:
- Um mesmo `pedido_id` pode aparecer mais de uma vez quando o pedido possui múltiplos itens.
- Um mesmo produto pode aparecer mais de uma vez no mesmo pedido.
- A chave conceitual da linha é `pedido_id + sequencia_item`.
- Para calcular a quantidade vendida, somar `quantidade_item`.
- Para calcular a receita de produtos, somar `preco_item`.

## fato_avaliacoes

Granularidade: uma linha por avaliação de pedido.

| Coluna | Tipo | Descrição |
|---|---|---|
| avaliacao_id | VARCHAR | Identificador da avaliação. |
| pedido_id | VARCHAR | Identificador do pedido avaliado. |
| nota_avaliacao | INTEGER | Nota da avaliação, normalmente de 1 a 5. |
| classificacao_avaliacao | VARCHAR | Classificação da nota: Negativa para notas 1 e 2, Neutra para nota 3, Positiva para notas 4 e 5, ou Não informado. |
| nps_aproximado | VARCHAR | Classificação aproximada no modelo NPS: Detrator para notas 1 e 2, Neutro para nota 3, Promotor para notas 4 e 5, ou Não informado. |
| tem_comentario | VARCHAR | Indica se a avaliação possui título ou mensagem de comentário informada. Valores esperados: Sim ou Não. |

Observações:
- O campo `avaliacao_id` pode repetir-se na origem.
- A chave conceitual mais confiável da linha é `avaliacao_id + pedido_id`.
- Para contar avaliações, usar a contagem de linhas da tabela.
- A tabela não expõe o título, a mensagem ou as datas da avaliação, pois está orientada para análises agregadas de satisfação.


## fato_pedidos

Granularidade: uma linha por pedido.

| Coluna | Tipo | Descrição |
|---|---|---|
| pedido_id | VARCHAR | Identificador do pedido. |
| cliente_id | VARCHAR | Identificador do cliente associado ao pedido. |
| cliente_unico_id | VARCHAR | Identificador único do cliente final, usado para análises de recompra e retenção. |
| status_pedido | VARCHAR | Status do pedido traduzido para português. Valores esperados: Entregue, Enviado, Cancelado, Indisponível, Faturado, Em processamento, Criado, Aprovado e Não informado. |
| data_pedido | DATE | Data em que o pedido foi realizado. |
| dias_ate_entrega | INTEGER | Quantidade de dias entre a compra e a entrega ao cliente. |
| faixa_dias_ate_entrega | VARCHAR | Faixa agrupada do tempo até a entrega: Não informado, Até 3 dias, 4 a 6 dias, 7 a 10 dias, 11 a 14 dias, 15 a 30 dias ou Maior que 30 dias. |
| entrega_atrasada | VARCHAR | Indica se a entrega ocorreu após a data estimada. Valores esperados: Sim, Não ou Não informado. |
| qtd_itens | INTEGER | Quantidade de itens associados ao pedido. Pedidos sem itens recebem 0. |
| qtd_pagamentos | INTEGER | Quantidade de pagamentos associados ao pedido. Pedidos sem pagamento recebem 0. |
| valor_produtos | DECIMAL | Soma dos valores dos produtos associados ao pedido. Pedidos sem itens recebem 0. |
| valor_frete | DECIMAL | Soma dos valores de frete associados ao pedido. Pedidos sem itens recebem 0. |
| valor_pago | DECIMAL | Soma dos valores pagos associados ao pedido. Pedidos sem pagamento recebem 0. |

Observações:
- A chave conceitual da tabela é `pedido_id`.
- A tabela possui uma linha por pedido da camada silver.
- `cliente_unico_id` é mantido na fato para facilitar análises de recompra, retenção e clientes recorrentes.
- `qtd_itens`, `valor_produtos` e `valor_frete` são agregados a partir da tabela de itens do pedido.
- `qtd_pagamentos` e `valor_pago` são agregados a partir da tabela de pagamentos.
- Pedidos sem itens ou pagamentos não são removidos; os campos quantitativos correspondentes recebem 0.
- `entrega_atrasada` recebe `Não informado` quando não existe data de entrega ao cliente.
- Para contar pedidos, usar contagem de linhas ou contagem distinta de `pedido_id`.