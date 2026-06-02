# Dicionário de Dados - Camada Silver

Este dicionário contempla as tabelas silver já verificadas: clientes, geolocalização, pedidos, itens de pedido, pagamentos, avaliações, produtos, tradução de categorias e vendedores.

## `olist_customers_dataset`

Tabela de clientes tratada a partir da camada bronze.

| Coluna | Tipo | Descrição |
|---|---|---|
| `customer_id` | VARCHAR | Identificador do cliente no pedido. |
| `customer_unique_id` | VARCHAR | Identificador único do cliente. Pode agrupar mais de um `customer_id` do mesmo cliente. |
| `customer_zip_code_prefix` | VARCHAR | Prefixo do CEP do cliente. |
| `customer_city_normalizada` | VARCHAR | Cidade do cliente em minúsculo, sem acentos e sem espaços excedentes. |
| `customer_city_exibicao` | VARCHAR | Nome da cidade para exibição, vindo da referência de municípios quando encontrado. |
| `customer_state` | VARCHAR | UF do cliente em maiúsculo. |

## `olist_geolocation_dataset`

Tabela de geolocalização consolidada por prefixo de CEP.

| Coluna | Tipo | Descrição |
|---|---|---|
| `geolocation_zip_code_prefix` | VARCHAR | Prefixo do CEP usado para geolocalização. |
| `geolocation_lat` | DECIMAL(18,15) | Latitude média consolidada para o prefixo de CEP. |
| `geolocation_lng` | DECIMAL(18,15) | Longitude média consolidada para o prefixo de CEP. |
| `geolocation_city_normalizada` | VARCHAR | Cidade em minúsculo, sem acentos e sem espaços excedentes. |
| `geolocation_city_exibicao` | VARCHAR | Nome da cidade para exibição, vindo da referência de municípios quando encontrado. |
| `geolocation_state` | VARCHAR | UF em maiúsculo. |

Observação: Conforme as regras do negócio: quando havia mais de um registro para o mesmo CEP, latitude e longitude foram consolidadas por média. A cidade/estado escolhida foi a mais frequente para o CEP. CEPs de clientes e vendedores ausentes na base original de geolocalização foram complementados usando média de latitude/longitude por estado.

## `olist_orders_dataset`

Tabela de pedidos.

| Coluna | Tipo | Descrição |
|---|---|---|
| `order_id` | VARCHAR | Identificador do pedido. |
| `customer_id` | VARCHAR | Identificador do cliente relacionado ao pedido. |
| `order_status` | VARCHAR | Status do pedido em minúsculo. Valores vazios recebem `nao_informado`. |
| `order_purchase_timestamp` | TIMESTAMP | Data e hora da compra. Valores vazios são convertidos para `NULL`. |
| `order_approved_at` | TIMESTAMP | Data e hora de aprovação do pedido. Valores vazios são convertidos para `NULL`. |
| `order_delivered_carrier_date` | TIMESTAMP | Data e hora em que o pedido foi entregue à transportadora. Valores vazios são convertidos para `NULL`. |
| `order_delivered_customer_date` | TIMESTAMP | Data e hora em que o pedido foi entregue ao cliente. Valores vazios são convertidos para `NULL`. |
| `order_estimated_delivery_date` | TIMESTAMP | Data estimada de entrega do pedido. Valores vazios são convertidos para `NULL`. |

## `olist_order_items_dataset`

Tabela de itens dos pedidos.

| Coluna | Tipo | Descrição |
|---|---|---|
| `order_id` | VARCHAR | Identificador do pedido. |
| `order_item_id` | INTEGER | Sequência do item dentro do mesmo pedido. Não representa quantidade agregada. |
| `product_id` | VARCHAR | Identificador do produto comprado. |
| `seller_id` | VARCHAR | Identificador do vendedor do item. |
| `shipping_limit_date` | TIMESTAMP | Data limite para envio do item. |
| `price` | DECIMAL(10,2) | Preço do item. |
| `freight_value` | DECIMAL(10,2) | Valor do frete do item. |

Observação: a granularidade da tabela é o item do pedido. Uma mesma `order_id` pode aparecer várias vezes, pois um pedido pode ter mais de um item. A chave conceitual da linha é `order_id + order_item_id`.

## `olist_order_payments_dataset`

Tabela de pagamentos dos pedidos.

| Coluna | Tipo | Descrição |
|---|---|---|
| `order_id` | VARCHAR | Identificador do pedido. |
| `payment_sequential` | INTEGER | Sequência do pagamento dentro do pedido. |
| `payment_type` | VARCHAR | Tipo de pagamento em minúsculo. |
| `payment_installments` | INTEGER | Quantidade de parcelas do pagamento. |
| `payment_value` | DECIMAL(10,2) | Valor pago nesta sequência de pagamento. |

Observação: uma mesma `order_id` pode aparecer mais de uma vez quando o pedido possui mais de um pagamento ou mais de uma sequência de pagamento. A chave conceitual da linha é `order_id + payment_sequential`.

## `olist_order_reviews_dataset`

Tabela de avaliações dos pedidos.

| Coluna | Tipo | Descrição |
|---|---|---|
| `review_id` | VARCHAR | Identificador da avaliação. Pode se repetir na origem. |
| `order_id` | VARCHAR | Identificador do pedido avaliado. Um pedido pode ter mais de uma avaliação. |
| `review_score` | INTEGER | Nota da avaliação atribuída pelo cliente. |
| `review_comment_title` | VARCHAR | Título do comentário da avaliação. Espaços duplicados, quebras de linha e tabs são reduzidos para um espaço. Valores vazios recebem `nao_informado`. O texto original é preservado sem padronização para minúsculo ou remoção de acentos. |
| `review_comment_message` | VARCHAR | Mensagem do comentário da avaliação. Espaços duplicados, quebras de linha e tabs são reduzidos para um espaço. Valores vazios recebem `nao_informado`. O texto original é preservado sem padronização para minúsculo ou remoção de acentos. |
| `review_creation_date` | TIMESTAMP | Data de criação/disponibilização da avaliação. Valores vazios são convertidos para `NULL`. |
| `review_answer_timestamp` | TIMESTAMP | Data e hora em que o cliente respondeu/enviou a avaliação. Valores vazios são convertidos para `NULL`. |

Observação: a tabela pode conter mais de uma avaliação para o mesmo `order_id`. Para identificar uma linha de forma mais segura, considere a combinação dos campos da avaliação, especialmente `review_id` e `order_id`.

## `olist_products_dataset`

Tabela de produtos.

| Coluna | Tipo | Descrição |
|---|---|---|
| `product_id` | VARCHAR | Identificador do produto. |
| `product_category_name` | VARCHAR | Categoria do produto em português, em minúsculo. Valores vazios recebem `nao_informado`. |
| `product_name_lenght` | INTEGER | Quantidade de caracteres do nome do produto. Valores vazios recebem `0`. |
| `product_description_lenght` | INTEGER | Quantidade de caracteres da descrição do produto. Valores vazios recebem `0`. |
| `product_photos_qty` | INTEGER | Quantidade de fotos do produto. Valores vazios recebem `0`. |
| `product_weight_g` | INTEGER | Peso do produto em gramas. Valores vazios recebem `0`. |
| `product_length_cm` | INTEGER | Comprimento do produto em centímetros. Valores vazios recebem `0`. |
| `product_height_cm` | INTEGER | Altura do produto em centímetros. Valores vazios recebem `0`. |
| `product_width_cm` | INTEGER | Largura do produto em centímetros. Valores vazios recebem `0`. |

Observação: o tratamento em `produtos_origem` vale para produtos existentes na bronze `olist_products_dataset`. A etapa `produtos_complementares` adiciona produtos que aparecem em `olist_order_items_dataset`, mas não existem na base original de produtos. Esses produtos complementares recebem `nao_informado` para categoria e `0` para os atributos numéricos.

## `olist_product_category_name_translation`

Tabela de tradução e exibição das categorias de produtos.

| Coluna | Tipo | Descrição |
|---|---|---|
| `product_category_name` | VARCHAR | Nome da categoria do produto em português, em minúsculo. |
| `product_category_name_english` | VARCHAR | Nome da categoria do produto em inglês, em minúsculo. |
| `nome_exibicao` | VARCHAR | Nome tratado para exibição da categoria. Quando vazio, recebe o valor de `product_category_name`. |

## `olist_sellers_dataset`

Tabela de vendedores tratada a partir da camada bronze.

| Coluna | Tipo | Descrição |
|---|---|---|
| `seller_id` | VARCHAR | Identificador do vendedor. |
| `seller_zip_code_prefix` | VARCHAR | Prefixo do CEP do vendedor. |
| `seller_city_normalizada` | VARCHAR | Cidade do vendedor em minúsculo, sem acentos e sem espaços excedentes. |
| `seller_city_exibicao` | VARCHAR | Nome da cidade para exibição, vindo da referência de municípios quando encontrado. |
| `seller_state` | VARCHAR | UF do vendedor em maiúsculo. |
