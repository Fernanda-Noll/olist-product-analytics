COPY (
    WITH geolocalizacao_origem AS (
        SELECT
            TRIM(geolocation_zip_code_prefix) AS geolocation_zip_code_prefix,
            CAST(geolocation_lat AS DECIMAL(18,15)) AS geolocation_lat,
            CAST(geolocation_lng AS DECIMAL(18,15)) AS geolocation_lng,
            LOWER(STRIP_ACCENTS(TRIM(geolocation_city))) AS geolocation_city,
            UPPER(TRIM(geolocation_state)) AS geolocation_state
        FROM read_parquet('data/bronze/olist_geolocation_dataset.parquet')
        WHERE geolocation_zip_code_prefix IS NOT NULL
          AND TRIM(geolocation_zip_code_prefix) <> ''
    ),
    coordenadas_origem AS (
        SELECT
            geolocation_zip_code_prefix,
            CAST(AVG(geolocation_lat) AS DECIMAL(18,15)) AS geolocation_lat,
            CAST(AVG(geolocation_lng) AS DECIMAL(18,15)) AS geolocation_lng
        FROM geolocalizacao_origem
        GROUP BY geolocation_zip_code_prefix
    ),
    cidade_estado_origem AS (
        SELECT
            geolocation_zip_code_prefix,
            geolocation_city,
            geolocation_state
        FROM (
            SELECT
                geolocation_zip_code_prefix,
                geolocation_city,
                geolocation_state,
                ROW_NUMBER() OVER (
                    PARTITION BY geolocation_zip_code_prefix
                    ORDER BY COUNT(*) DESC, geolocation_city, geolocation_state
                ) AS ordem
            FROM geolocalizacao_origem
            GROUP BY
                geolocation_zip_code_prefix,
                geolocation_city,
                geolocation_state
        )
        WHERE ordem = 1
    ),
    geolocalizacao_consolidada AS (
        SELECT
            coordenadas_origem.geolocation_zip_code_prefix,
            coordenadas_origem.geolocation_lat,
            coordenadas_origem.geolocation_lng,
            cidade_estado_origem.geolocation_city,
            cidade_estado_origem.geolocation_state
        FROM coordenadas_origem
        LEFT JOIN cidade_estado_origem
            ON coordenadas_origem.geolocation_zip_code_prefix = cidade_estado_origem.geolocation_zip_code_prefix
    ),
    media_estado AS (
        SELECT
            geolocation_state,
            CAST(AVG(geolocation_lat) AS DECIMAL(18,15)) AS latitude_media_estado,
            CAST(AVG(geolocation_lng) AS DECIMAL(18,15)) AS longitude_media_estado
        FROM geolocalizacao_consolidada
        GROUP BY geolocation_state
    ),
    ceps_clientes_vendedores AS (
        SELECT
            customer_zip_code_prefix AS geolocation_zip_code_prefix,
            customer_city_normalizada AS geolocation_city,
            customer_state AS geolocation_state
        FROM read_parquet('data/silver/olist_customers_dataset.parquet')
        WHERE customer_zip_code_prefix IS NOT NULL
          AND TRIM(customer_zip_code_prefix) <> ''

        UNION ALL

        SELECT
            seller_zip_code_prefix AS geolocation_zip_code_prefix,
            seller_city_normalizada AS geolocation_city, 
            seller_state AS geolocation_state
        FROM read_parquet('data/silver/olist_sellers_dataset.parquet')
        WHERE seller_zip_code_prefix IS NOT NULL
          AND TRIM(seller_zip_code_prefix) <> ''
    ),
    ceps_faltantes AS (
        SELECT
            geolocation_zip_code_prefix,
            geolocation_city,
            geolocation_state
        FROM (
            SELECT
                ceps_clientes_vendedores.geolocation_zip_code_prefix,
                ceps_clientes_vendedores.geolocation_city,
                ceps_clientes_vendedores.geolocation_state,
                ROW_NUMBER() OVER (
                    PARTITION BY ceps_clientes_vendedores.geolocation_zip_code_prefix
                    ORDER BY COUNT(*) DESC, ceps_clientes_vendedores.geolocation_city, ceps_clientes_vendedores.geolocation_state
                ) AS ordem
            FROM ceps_clientes_vendedores
            LEFT JOIN geolocalizacao_consolidada
                ON ceps_clientes_vendedores.geolocation_zip_code_prefix = geolocalizacao_consolidada.geolocation_zip_code_prefix
            WHERE geolocalizacao_consolidada.geolocation_zip_code_prefix IS NULL
            GROUP BY
                ceps_clientes_vendedores.geolocation_zip_code_prefix,
                ceps_clientes_vendedores.geolocation_city,
                ceps_clientes_vendedores.geolocation_state
        )
        WHERE ordem = 1
    ),
    geolocalizacao_complementar AS (
        SELECT
            ceps_faltantes.geolocation_zip_code_prefix,
            media_estado.latitude_media_estado AS geolocation_lat,
            media_estado.longitude_media_estado AS geolocation_lng,
            ceps_faltantes.geolocation_city,
            ceps_faltantes.geolocation_state
        FROM ceps_faltantes
        LEFT JOIN media_estado
            ON ceps_faltantes.geolocation_state = media_estado.geolocation_state
    )
    SELECT
        geolocalizacao_final.geolocation_zip_code_prefix,
        geolocalizacao_final.geolocation_lat,
        geolocalizacao_final.geolocation_lng,
        geolocalizacao_final.geolocation_city AS geolocation_city_normalizada, -- Mantido o padrão _normalizada
        COALESCE(municipios.cidade_exibicao, geolocalizacao_final.geolocation_city) AS geolocation_city_exibicao,
        geolocalizacao_final.geolocation_state
    FROM (
        SELECT
            geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            geolocation_city,
            geolocation_state
        FROM geolocalizacao_consolidada

        UNION ALL

        SELECT
            geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            geolocation_city,
            geolocation_state
        FROM geolocalizacao_complementar
    ) AS geolocalizacao_final
    LEFT JOIN read_parquet('data/reference/municipios_ibge.parquet') AS municipios
        ON geolocalizacao_final.geolocation_city = municipios.cidade_normalizada
       AND geolocalizacao_final.geolocation_state = municipios.uf
)
TO 'data/silver/olist_geolocation_dataset.parquet' (FORMAT PARQUET);