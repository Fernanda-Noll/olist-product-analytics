COPY (
    WITH itens AS (
        SELECT
            order_id,
            COUNT(*) AS qtd_itens,
            SUM(price) AS valor_produtos,
            SUM(freight_value) AS valor_frete
        FROM read_parquet('data/silver/olist_order_items_dataset.parquet')
        GROUP BY order_id
    ),
    pagamentos AS (
        SELECT
            order_id,
            COUNT(*) AS qtd_pagamentos,
            SUM(payment_value) AS valor_pago
        FROM read_parquet('data/silver/olist_order_payments_dataset.parquet')
        GROUP BY order_id
    )
    SELECT
        pedidos.order_id AS pedido_id,
        pedidos.customer_id AS cliente_id,
        clientes.customer_unique_id AS cliente_unico_id,
        CASE pedidos.order_status
            WHEN 'delivered' THEN 'Entregue'
            WHEN 'shipped' THEN 'Enviado'
            WHEN 'canceled' THEN 'Cancelado'
            WHEN 'unavailable' THEN 'Indisponível'
            WHEN 'invoiced' THEN 'Faturado'
            WHEN 'processing' THEN 'Em processamento'
            WHEN 'created' THEN 'Criado'
            WHEN 'approved' THEN 'Aprovado'
            WHEN 'nao_informado' THEN 'Não informado'
            ELSE pedidos.order_status
        END AS status_pedido,
        CAST(pedidos.order_purchase_timestamp AS DATE) AS data_pedido,
        DATE_DIFF('day', pedidos.order_purchase_timestamp, pedidos.order_delivered_customer_date) AS dias_ate_entrega,
        CASE
            WHEN pedidos.order_delivered_customer_date IS NULL THEN 'Não informado'
            WHEN DATE_DIFF('day', pedidos.order_purchase_timestamp, pedidos.order_delivered_customer_date) <= 3 THEN 'Até 3 dias'
            WHEN DATE_DIFF('day', pedidos.order_purchase_timestamp, pedidos.order_delivered_customer_date) <= 6 THEN '4 a 6 dias'
            WHEN DATE_DIFF('day', pedidos.order_purchase_timestamp, pedidos.order_delivered_customer_date) <= 10 THEN '7 a 10 dias'
            WHEN DATE_DIFF('day', pedidos.order_purchase_timestamp, pedidos.order_delivered_customer_date) <= 14 THEN '11 a 14 dias'
            WHEN DATE_DIFF('day', pedidos.order_purchase_timestamp, pedidos.order_delivered_customer_date) <= 30 THEN '15 a 30 dias'
            ELSE 'Maior que 30 dias'
        END AS faixa_dias_ate_entrega,
        CASE
            WHEN pedidos.order_delivered_customer_date IS NULL THEN 'Não informado'
            WHEN pedidos.order_delivered_customer_date > pedidos.order_estimated_delivery_date THEN 'Sim'
            ELSE 'Não'
        END AS entrega_atrasada,
        COALESCE(itens.qtd_itens, 0) AS qtd_itens,
        COALESCE(pagamentos.qtd_pagamentos, 0) AS qtd_pagamentos,
        COALESCE(itens.valor_produtos, 0) AS valor_produtos,
        COALESCE(itens.valor_frete, 0) AS valor_frete,
        COALESCE(pagamentos.valor_pago, 0) AS valor_pago
    FROM read_parquet('data/silver/olist_orders_dataset.parquet') AS pedidos
    LEFT JOIN read_parquet('data/silver/olist_customers_dataset.parquet') AS clientes
        ON pedidos.customer_id = clientes.customer_id
    LEFT JOIN itens
        ON pedidos.order_id = itens.order_id
    LEFT JOIN pagamentos
        ON pedidos.order_id = pagamentos.order_id
)
TO 'data/gold/fato_pedidos.parquet' (FORMAT PARQUET);
