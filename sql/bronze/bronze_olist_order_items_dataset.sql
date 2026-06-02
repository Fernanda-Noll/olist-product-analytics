COPY (
    SELECT *
    FROM read_csv(
        'data/raw/olist_order_items_dataset.csv',
        ALL_VARCHAR = TRUE
    )
)
TO 'data/bronze/olist_order_items_dataset.parquet' (FORMAT PARQUET);