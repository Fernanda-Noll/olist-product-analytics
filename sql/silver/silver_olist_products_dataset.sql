COPY (
    WITH produtos_origem AS (
        SELECT DISTINCT
            TRIM(product_id) AS product_id,
            COALESCE(NULLIF(LOWER(TRIM(product_category_name)), ''), 'nao_informado') AS product_category_name,
            CAST(COALESCE(NULLIF(TRIM(product_name_lenght), ''), '0') AS INTEGER) AS product_name_lenght,
            CAST(COALESCE(NULLIF(TRIM(product_description_lenght), ''), '0') AS INTEGER) AS product_description_lenght,
            CAST(COALESCE(NULLIF(TRIM(product_photos_qty), ''), '0') AS INTEGER) AS product_photos_qty,
            CAST(COALESCE(NULLIF(TRIM(product_weight_g), ''), '0') AS INTEGER) AS product_weight_g,
            CAST(COALESCE(NULLIF(TRIM(product_length_cm), ''), '0') AS INTEGER) AS product_length_cm,
            CAST(COALESCE(NULLIF(TRIM(product_height_cm), ''), '0') AS INTEGER) AS product_height_cm,
            CAST(COALESCE(NULLIF(TRIM(product_width_cm), ''), '0') AS INTEGER) AS product_width_cm
        FROM read_parquet('data/bronze/olist_products_dataset.parquet')
        WHERE product_id IS NOT NULL
          AND TRIM(product_id) <> ''
    ),
    produtos_vendidos AS (
        SELECT DISTINCT
            product_id
        FROM read_parquet('data/silver/olist_order_items_dataset.parquet')
        WHERE product_id IS NOT NULL
          AND TRIM(product_id) <> ''
    ),
    produtos_complementares AS (
        SELECT
            produtos_vendidos.product_id,
            'nao_informado' AS product_category_name,
            0 AS product_name_lenght,
            0 AS product_description_lenght,
            0 AS product_photos_qty,
            0 AS product_weight_g,
            0 AS product_length_cm,
            0 AS product_height_cm,
            0 AS product_width_cm
        FROM produtos_vendidos
        LEFT JOIN produtos_origem
            ON produtos_vendidos.product_id = produtos_origem.product_id
        WHERE produtos_origem.product_id IS NULL
    )

    SELECT * FROM produtos_origem

    UNION ALL

    SELECT * FROM produtos_complementares
)
TO 'data/silver/olist_products_dataset.parquet' (FORMAT PARQUET);
