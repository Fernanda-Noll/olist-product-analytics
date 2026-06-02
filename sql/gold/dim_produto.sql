COPY (
    SELECT
        produto.product_id AS produto_id,
        COALESCE(traducao.nome_exibicao, produto.product_category_name) AS categoria_produto,
        COALESCE(traducao.product_category_name_english, produto.product_category_name) AS categoria_produto_ingles,
        produto.product_photos_qty AS quantidade_fotos,
        produto.product_weight_g AS peso_g,
        produto.product_length_cm AS comprimento_cm,
        produto.product_height_cm AS altura_cm,
        produto.product_width_cm AS largura_cm,
        produto.product_length_cm * produto.product_height_cm * produto.product_width_cm AS volume_cm3,
        CASE
            WHEN produto.product_weight_g = 0 THEN 'Não informado'
            WHEN produto.product_weight_g <= 500 THEN 'Até 500g'
            WHEN produto.product_weight_g <= 1000 THEN '501g a 1kg'
            WHEN produto.product_weight_g <= 5000 THEN '1kg a 5kg'
            ELSE 'Acima de 5kg'
        END AS faixa_peso
    FROM read_parquet('data/silver/olist_products_dataset.parquet') AS produto
    LEFT JOIN read_parquet('data/silver/olist_product_category_name_translation.parquet') AS traducao
        ON produto.product_category_name = traducao.product_category_name
)
TO 'data/gold/dim_produto.parquet' (FORMAT PARQUET);
