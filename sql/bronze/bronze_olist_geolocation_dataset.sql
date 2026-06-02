COPY (
    SELECT *
    FROM read_csv(
        'data/raw/olist_geolocation_dataset.csv',
        ALL_VARCHAR = TRUE
    )
)
TO 'data/bronze/olist_geolocation_dataset.parquet' (FORMAT PARQUET);