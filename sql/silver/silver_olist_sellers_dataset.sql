COPY (
    WITH vendedores AS (
        SELECT DISTINCT
            TRIM(seller_id) AS seller_id,
            TRIM(seller_zip_code_prefix) AS seller_zip_code_prefix,
            LOWER(STRIP_ACCENTS(TRIM(seller_city))) AS seller_city_normalizada,
            UPPER(TRIM(seller_state)) AS seller_state
        FROM read_parquet('data/bronze/olist_sellers_dataset.parquet')
        WHERE seller_id IS NOT NULL
          AND TRIM(seller_id) <> ''
    )
    SELECT
        vendedores.seller_id,
        vendedores.seller_zip_code_prefix,
        vendedores.seller_city_normalizada,
        COALESCE(municipios.cidade_exibicao, vendedores.seller_city_normalizada) AS seller_city_exibicao,
        vendedores.seller_state
    FROM vendedores
    LEFT JOIN read_parquet('data/reference/municipios_ibge.parquet') AS municipios
        ON vendedores.seller_city_normalizada = municipios.cidade_normalizada
       AND vendedores.seller_state = municipios.uf
)
TO 'data/silver/olist_sellers_dataset.parquet' (FORMAT PARQUET);
