COPY (
    SELECT *
    FROM read_csv(
        'data/raw/olist_products_dataset.csv',
        ALL_VARCHAR = TRUE
    )
)
TO 'data/bronze/olist_products_dataset.parquet' (FORMAT PARQUET);