import duckdb
import os
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent

scripts = [
    BASE_DIR / "sql/bronze/bronze_olist_customers_dataset.sql",
    BASE_DIR / "sql/bronze/bronze_olist_geolocation_dataset.sql",
    BASE_DIR / "sql/bronze/bronze_olist_orders_dataset.sql",
    BASE_DIR / "sql/bronze/bronze_olist_order_items_dataset.sql",
    BASE_DIR / "sql/bronze/bronze_olist_order_payments_dataset.sql",
    BASE_DIR / "sql/bronze/bronze_olist_order_reviews_dataset.sql",
    BASE_DIR / "sql/bronze/bronze_olist_products_dataset.sql",
    BASE_DIR / "sql/bronze/bronze_olist_product_category_name_translation.sql",
    BASE_DIR / "sql/bronze/bronze_olist_sellers_dataset.sql",
    BASE_DIR / "sql/silver/silver_olist_customers_dataset.sql",
    BASE_DIR / "sql/silver/silver_olist_sellers_dataset.sql",
    BASE_DIR / "sql/silver/silver_olist_orders_dataset.sql",
    BASE_DIR / "sql/silver/silver_olist_order_items_dataset.sql",
    BASE_DIR / "sql/silver/silver_olist_order_payments_dataset.sql",
    BASE_DIR / "sql/silver/silver_olist_order_reviews_dataset.sql",
    BASE_DIR / "sql/silver/silver_olist_products_dataset.sql",
    BASE_DIR / "sql/silver/silver_olist_product_category_name_translation.sql",
    BASE_DIR / "sql/silver/silver_olist_geolocation_dataset.sql",
    BASE_DIR / "sql/gold/dim_cliente.sql",
    BASE_DIR / "sql/gold/dim_produto.sql",
    BASE_DIR / "sql/gold/dim_vendedor.sql",
    BASE_DIR / "sql/gold/dim_tempo.sql",
    BASE_DIR / "sql/gold/dim_geolocalizacao_clientes.sql",
    BASE_DIR / "sql/gold/dim_geolocalizacao_vendedores.sql",
    BASE_DIR / "sql/gold/dim_pagamento.sql",
    BASE_DIR / "sql/gold/fato_pedidos.sql",
    BASE_DIR / "sql/gold/fato_itens_pedido.sql",
    BASE_DIR / "sql/gold/fato_pagamentos.sql",
    BASE_DIR / "sql/gold/fato_avaliacoes.sql",
]

connect = None

try:
    os.chdir(BASE_DIR)

    (BASE_DIR / "data/bronze").mkdir(parents=True, exist_ok=True)
    (BASE_DIR / "data/silver").mkdir(parents=True, exist_ok=True)
    (BASE_DIR / "data/gold").mkdir(parents=True, exist_ok=True)

    connect = duckdb.connect()

    for sql_path in scripts:
        with open(sql_path, "r", encoding="utf-8") as arquivo:
            sql = arquivo.read()

        connect.execute(sql)
        print(f"{sql_path} executado com sucesso.")

except Exception as erro:
    print(erro)

else:
    print("Pipeline finalizado.")

finally:
    if connect is not None:
        connect.close()
    print("Conexao encerrada.")
