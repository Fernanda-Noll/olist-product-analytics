COPY (
    SELECT
        customer_id AS cliente_id,
        customer_unique_id AS cliente_unico_id,
        customer_zip_code_prefix AS cep_prefixo_cliente,
        customer_city_exibicao AS cidade_cliente,
        customer_state AS estado_cliente
    FROM read_parquet('data/silver/olist_customers_dataset.parquet')
)
TO 'data/gold/dim_cliente.parquet' (FORMAT PARQUET);
