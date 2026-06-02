COPY (
    SELECT DISTINCT
        LOWER(TRIM(product_category_name)) AS product_category_name,
        LOWER(TRIM(product_category_name_english)) AS product_category_name_english,
        COALESCE(NULLIF(TRIM(nome_exibicao), ''), LOWER(TRIM(product_category_name))) AS nome_exibicao
    FROM read_parquet('data/bronze/olist_product_category_name_translation.parquet')
    WHERE product_category_name IS NOT NULL
      AND TRIM(product_category_name) <> ''
)
TO 'data/silver/olist_product_category_name_translation.parquet' (FORMAT PARQUET);
