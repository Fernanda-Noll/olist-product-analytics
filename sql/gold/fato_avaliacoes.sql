COPY (
    SELECT
        review_id AS avaliacao_id,
        order_id AS pedido_id,
        review_score AS nota_avaliacao,
        CASE
            WHEN review_score IN (1, 2) THEN 'Negativa'
            WHEN review_score = 3 THEN 'Neutra'
            WHEN review_score IN (4, 5) THEN 'Positiva'
            ELSE 'Não informado'
        END AS classificacao_avaliacao,
        CASE
            WHEN review_score IN (1, 2) THEN 'Detrator'
            WHEN review_score = 3 THEN 'Neutro'
            WHEN review_score IN (4, 5) THEN 'Promotor'
            ELSE 'Não informado'
        END AS nps_aproximado,
        CASE
            WHEN review_comment_title <> 'nao_informado'
              OR review_comment_message <> 'nao_informado' THEN 'Sim'
            ELSE 'Não'
        END AS tem_comentario
    FROM read_parquet('data/silver/olist_order_reviews_dataset.parquet')
)
TO 'data/gold/fato_avaliacoes.parquet' (FORMAT PARQUET);
