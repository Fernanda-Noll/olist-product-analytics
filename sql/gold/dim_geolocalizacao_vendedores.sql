COPY (
    SELECT
        geolocation_zip_code_prefix AS cep_prefixo,
        geolocation_city_exibicao AS cidade,
        geolocation_state AS estado,
        geolocation_lat AS latitude_media,
        geolocation_lng AS longitude_media
    FROM read_parquet('data/silver/olist_geolocation_dataset.parquet')
)
TO 'data/gold/dim_geolocalizacao_vendedores.parquet' (FORMAT PARQUET);
