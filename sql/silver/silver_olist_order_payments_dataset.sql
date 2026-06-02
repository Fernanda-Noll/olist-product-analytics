COPY (
    SELECT
        TRIM(order_id) AS order_id,
        CAST(payment_sequential AS INTEGER) AS payment_sequential,
        LOWER(TRIM(payment_type)) AS payment_type,
        CAST(payment_installments AS INTEGER) AS payment_installments,
        CAST(payment_value AS DECIMAL(10,2)) AS payment_value
    FROM read_parquet('data/bronze/olist_order_payments_dataset.parquet')
    WHERE order_id IS NOT NULL
      AND TRIM(order_id) <> ''
)
TO 'data/silver/olist_order_payments_dataset.parquet' (FORMAT PARQUET);
