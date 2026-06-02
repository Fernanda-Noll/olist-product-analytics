COPY (
    SELECT
        TRIM(order_id) AS order_id,
        TRIM(customer_id) AS customer_id,
        COALESCE(NULLIF(LOWER(TRIM(order_status)), ''), 'nao_informado') AS order_status,
        CAST(NULLIF(TRIM(order_purchase_timestamp), '') AS TIMESTAMP) AS order_purchase_timestamp,
        CAST(NULLIF(TRIM(order_approved_at), '') AS TIMESTAMP) AS order_approved_at,
        CAST(NULLIF(TRIM(order_delivered_carrier_date), '') AS TIMESTAMP) AS order_delivered_carrier_date,
        CAST(NULLIF(TRIM(order_delivered_customer_date), '') AS TIMESTAMP) AS order_delivered_customer_date,
        CAST(NULLIF(TRIM(order_estimated_delivery_date), '') AS TIMESTAMP) AS order_estimated_delivery_date
    FROM read_parquet('data/bronze/olist_orders_dataset.parquet')
    WHERE order_id IS NOT NULL
      AND TRIM(order_id) <> ''
      AND customer_id IS NOT NULL
      AND TRIM(customer_id) <> ''
)
TO 'data/silver/olist_orders_dataset.parquet' (FORMAT PARQUET);
