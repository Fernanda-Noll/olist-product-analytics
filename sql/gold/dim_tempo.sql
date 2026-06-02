COPY (
    WITH limites AS (
        SELECT
            MIN(CAST(order_purchase_timestamp AS DATE)) AS data_inicio,
            MAX(CAST(order_purchase_timestamp AS DATE)) AS data_fim
        FROM read_parquet('data/silver/olist_orders_dataset.parquet')
        WHERE order_purchase_timestamp IS NOT NULL
    ),
    calendario AS (
        SELECT
            CAST(data AS DATE) AS data
        FROM limites,
        GENERATE_SERIES(data_inicio, data_fim, INTERVAL 1 DAY) AS serie(data)
    )
    SELECT
        data,
        EXTRACT(YEAR FROM data) AS ano,
        EXTRACT(MONTH FROM data) AS mes,
        EXTRACT(QUARTER FROM data) AS trimestre,
        STRFTIME(data, '%Y-%m') AS ano_mes
    FROM calendario
    ORDER BY data
)
TO 'data/gold/dim_tempo.parquet' (FORMAT PARQUET);
