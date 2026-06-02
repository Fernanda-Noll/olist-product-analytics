COPY (
    SELECT *
    FROM read_csv(
        'data/raw/olist_orders_dataset.csv',
        ALL_VARCHAR = TRUE
    )
)
TO 'data/bronze/olist_orders_dataset.parquet' (FORMAT PARQUET);