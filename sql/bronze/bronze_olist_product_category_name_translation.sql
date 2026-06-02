COPY (
    SELECT *
    FROM read_csv(
        'data/raw/product_category_name_translation.csv',
        ALL_VARCHAR = TRUE
    )
)
TO 'data/bronze/olist_product_category_name_translation.parquet' (FORMAT PARQUET);