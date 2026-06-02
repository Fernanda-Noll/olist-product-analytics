COPY (
    WITH clientes AS (
        SELECT DISTINCT
            TRIM(customer_id) AS customer_id,
            TRIM(customer_unique_id) AS customer_unique_id,
            TRIM(customer_zip_code_prefix) AS customer_zip_code_prefix,
            LOWER(STRIP_ACCENTS(TRIM(customer_city))) AS customer_city_normalizada,
            UPPER(TRIM(customer_state)) AS customer_state
        FROM read_parquet('data/bronze/olist_customers_dataset.parquet')
        WHERE customer_id IS NOT NULL
          AND TRIM(customer_id) <> ''
    )
    SELECT
        clientes.customer_id,
        clientes.customer_unique_id,
        clientes.customer_zip_code_prefix,
        clientes.customer_city_normalizada,
        COALESCE(municipios.cidade_exibicao, clientes.customer_city_normalizada) AS customer_city_exibicao,
        clientes.customer_state
    FROM clientes
    LEFT JOIN read_parquet('data/reference/municipios_ibge.parquet') AS municipios
        ON clientes.customer_city_normalizada = municipios.cidade_normalizada
       AND clientes.customer_state = municipios.uf
)
TO 'data/silver/olist_customers_dataset.parquet' (FORMAT PARQUET);
