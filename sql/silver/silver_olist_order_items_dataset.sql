COPY (
    SELECT
        TRIM(order_id) AS order_id,
        CAST(order_item_id AS INTEGER) AS order_item_id,
        TRIM(product_id) AS product_id,
        TRIM(seller_id) AS seller_id,
        CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_date,
        CAST(price AS DECIMAL(10,2)) AS price,
        CAST(freight_value AS DECIMAL(10,2)) AS freight_value
    FROM read_parquet('data/bronze/olist_order_items_dataset.parquet')
    WHERE order_id IS NOT NULL
        AND TRIM(order_id) <> ''
        AND order_item_id IS NOT NULL
        AND product_id IS NOT NULL
        AND TRIM(product_id) <> ''
        AND seller_id IS NOT NULL
        AND TRIM(seller_id) <> ''
)
TO 'data/silver/olist_order_items_dataset.parquet' (FORMAT PARQUET);
