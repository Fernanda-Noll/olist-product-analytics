COPY (
    SELECT *
    FROM read_csv(
        'data/raw/olist_customers_dataset.csv',
        ALL_VARCHAR = TRUE
    )
)
TO 'data/bronze/olist_customers_dataset.parquet'(FORMAT PARQUET);