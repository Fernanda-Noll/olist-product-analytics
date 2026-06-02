COPY (
    SELECT
        order_id AS pedido_id,
        order_item_id AS sequencia_item,
        product_id AS produto_id,
        seller_id AS vendedor_id,
        price AS preco_item,
        freight_value AS valor_frete,
        1 AS quantidade_item
    FROM read_parquet('data/silver/olist_order_items_dataset.parquet')
)
TO 'data/gold/fato_itens_pedido.parquet' (FORMAT PARQUET);
