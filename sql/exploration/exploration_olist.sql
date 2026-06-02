-- Consultas livres para explorar a camada silver.

-- SELECT
--     order_status,
--     COUNT(*) AS total_orders
-- FROM read_parquet('data/silver/olist_orders_dataset.parquet')
-- GROUP BY order_status
-- ORDER BY total_orders DESC;

-- SELECT
--     payment_type,
--     COUNT(*) AS total_payments,
--     SUM(payment_value) AS total_payment_value
-- FROM read_parquet('data/silver/olist_order_payments_dataset.parquet')
-- GROUP BY payment_type
-- ORDER BY total_payment_value DESC;

-- SELECT current_setting('current_directory');


-- SELECT 
--     product_category_name,
--     COUNT(*) AS total_products
-- FROM read_parquet('C:/Users/ferna/OneDrive - UFSC/Área de Trabalho/dataset_olist/data/silver/olist_products_dataset.parquet')
-- GROUP BY product_category_name
-- ORDER BY total_products DESC
-- LIMIT 100;

-- SELECT
--     product_category_name,
--     COUNT(*) AS total_products
-- FROM read_parquet('data/silver/olist_products_dataset.parquet')
-- GROUP BY product_category_name
-- ORDER BY total_products DESC;


-- SELECT 
--     seller_state AS estado_dos_vendedores,
--     COUNT(*) AS total_vendedores
-- FROM read_parquet('data/silver/olist_sellers_dataset.parquet')
-- GROUP BY seller_state
-- ORDER BY total_vendedores DESC;


-- -- Consulta referente ao total de vendedores por estado
-- SELECT 
--     seller_state AS estado_dos_vendedores,
--     COUNT(*) AS total_vendedores
-- FROM read_parquet('data/silver/olist_sellers_dataset.parquet')
-- GROUP BY seller_state
-- ORDER BY total_vendedores DESC;

-- -- Consulta referente ao total de clientes por estado
-- SELECT 
--     customer_state AS estado_dos_clientes,
--     COUNT(*) AS total_estado_clientes
-- FROM read_parquet('data/silver/olist_customers_dataset.parquet')
-- GROUP BY customer_state
-- ORDER BY total_estado_clientes DESC;



-- WITH items AS (
--     SELECT
--         order_id,
--         COUNT(*) AS total_linhas_itens,
--         SUM(price) AS total_itens,
--         SUM(freight_value) AS total_frete,
--         SUM(price + freight_value) AS total_item_frete
--     FROM read_parquet('data/silver/olist_order_items_dataset.parquet')
--     GROUP BY order_id
-- ),

-- payments AS (
--     SELECT
--         order_id,
--         COUNT(*) AS total_linhas_pagamento,
--         SUM(payment_value) AS total_pago
--     FROM read_parquet('data/silver/olist_order_payments_dataset.parquet')
--     GROUP BY order_id
-- )

-- SELECT
--     i.order_id,
--     i.total_linhas_itens,
--     p.total_linhas_pagamento,
--     i.total_itens,
--     i.total_frete,
--     i.total_item_frete,
--     p.total_pago,
--     p.total_pago - i.total_item_frete AS diferenca
-- FROM items i
-- JOIN payments p
--     ON i.order_id = p.order_id
-- ORDER BY ABS(p.total_pago - i.total_item_frete) DESC;


-- -- Consulta para verificar os dias entre compra e entrega ao cliente.
-- -- Usa a camada gold porque `dias_ate_entrega` ja e uma metrica de negocio por pedido.
-- SELECT
--     faixa_dias_ate_entrega,
--     COUNT(*) AS total_pedidos,
--     SUM(dias_ate_entrega) AS total_dias_ate_entrega,
--     ROUND(AVG(dias_ate_entrega), 2) AS media_dias_ate_entrega,
--     MIN(dias_ate_entrega) AS menor_dias_ate_entrega,
--     MAX(dias_ate_entrega) AS maior_dias_ate_entrega,
--     ROUND(AVG(nota_media_avaliacao), 2) AS nota_media
-- FROM read_parquet('data/gold/fato_pedidos.parquet')
-- GROUP BY faixa_dias_ate_entrega
-- ORDER BY
--     CASE faixa_dias_ate_entrega
--         WHEN '1 a 3 dias' THEN 1
--         WHEN '4 a 6 dias' THEN 2
--         WHEN '7 a 10 dias' THEN 3
--         WHEN '11 a 14 dias' THEN 4
--         WHEN '15 a 30 dias' THEN 5
--         WHEN 'Maior que 30 dias' THEN 6
--         WHEN 'Não informado' THEN 7
--     END;


-- -- Consulta detalhada para investigar pedidos com prazos inconsistentes ou extremos.
-- SELECT
--     pedido_id,
--     status_pedido,
--     data_pedido,
--     data_entrega_cliente,
--     data_entrega_estimada,
--     dias_ate_entrega,
--     dias_atraso_entrega,
--     entrega_atrasada,
--     nota_media_avaliacao
-- FROM read_parquet('data/gold/fato_pedidos.parquet')
-- WHERE dias_ate_entrega IS NULL
--    OR dias_ate_entrega < 0
--    OR dias_ate_entrega > 60
-- ORDER BY dias_ate_entrega DESC;

SELECT 
    seller_state AS estado_vendedor, 
    COUNT(*) AS total_vendedores_por_estado
FROM read_parquet('C:/Users/ferna/OneDrive - UFSC/Área de Trabalho/dataset_olist/data/silver/olist_sellers_dataset.parquet')
GROUP BY seller_state
ORDER BY total_vendedores_por_estado DESC;

