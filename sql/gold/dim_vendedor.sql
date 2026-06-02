COPY (
    SELECT
        seller_id AS vendedor_id,
        seller_zip_code_prefix AS cep_prefixo_vendedor,
        seller_city_exibicao AS cidade_vendedor,
        seller_state AS estado_vendedor
    FROM read_parquet('data/silver/olist_sellers_dataset.parquet')
)
TO 'data/gold/dim_vendedor.parquet' (FORMAT PARQUET);
