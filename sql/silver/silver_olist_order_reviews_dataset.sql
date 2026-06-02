COPY (
    SELECT 
        TRIM(review_id) AS review_id,
        TRIM(order_id) AS order_id,
        CAST(review_score AS INTEGER) AS review_score,
        COALESCE(
            NULLIF(REGEXP_REPLACE(TRIM(review_comment_title), '[[:space:]]+', ' ', 'g'), ''),
            'nao_informado'
        ) AS review_comment_title,
        COALESCE(
            NULLIF(REGEXP_REPLACE(TRIM(review_comment_message), '[[:space:]]+', ' ', 'g'), ''),
            'nao_informado'
        ) AS review_comment_message,
        CAST(NULLIF(TRIM(review_creation_date), '') AS TIMESTAMP) AS review_creation_date,
        CAST(NULLIF(TRIM(review_answer_timestamp), '') AS TIMESTAMP) AS review_answer_timestamp
    FROM read_parquet('data/bronze/olist_order_reviews_dataset.parquet')
    WHERE review_id IS NOT NULL
      AND TRIM(review_id) <> ''
      AND order_id IS NOT NULL
      AND TRIM(order_id) <> ''
)
TO 'data/silver/olist_order_reviews_dataset.parquet' (FORMAT PARQUET);
