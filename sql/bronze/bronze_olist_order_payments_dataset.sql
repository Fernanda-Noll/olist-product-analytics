COPY (
    SELECT *
    FROM read_csv(
        'data/raw/olist_order_payments_dataset.csv',
        ALL_VARCHAR = TRUE
    )
)
TO 'data/bronze/olist_order_payments_dataset.parquet' (FORMAT PARQUET);