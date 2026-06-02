import pandas as pd 


def eda_inicial(df):
    print(df.head(10))
    print(df.info())
    print("\nTamanho:", df.shape)
    print("\nTotal de nulos:\n", df.isnull().sum())
    print("\nTotal de duplicados:", df.duplicated().sum())
    print("\nQuantidade de tipos por coluna:\n",df.nunique())
    print(df.describe())

# df_olist_customers_dataset = pd.read_parquet('data/bronze/olist_customers_dataset.parquet')
# eda_inicial(df_olist_customers_dataset)

# df_olist_geolocation_dataset = pd.read_parquet('data/bronze/olist_geolocation_dataset.parquet')
# eda_inicial(df_olist_geolocation_dataset)

# df_olist_order_items_dataset = pd.read_parquet('data/bronze/olist_order_items_dataset.parquet')
# eda_inicial(df_olist_order_items_dataset)

# df_olist_order_payments_dataset = pd.read_parquet('data/bronze/olist_order_payments_dataset.parquet')
# eda_inicial(df_olist_order_payments_dataset)

# df_olist_order_reviews_dataset = pd.read_parquet('data/bronze/olist_order_reviews_dataset.parquet')
# eda_inicial(df_olist_order_reviews_dataset)

# df_olist_orders_dataset = pd.read_parquet('data/bronze/olist_orders_dataset.parquet')
# eda_inicial(df_olist_orders_dataset)

# df_olist_products_dataset = pd.read_parquet('data/bronze/olist_products_dataset.parquet')
# eda_inicial(df_olist_products_dataset)

# df_olist_sellers_dataset = pd.read_parquet('data/bronze/olist_sellers_dataset.parquet')
# eda_inicial(df_olist_sellers_dataset)

# df_olist_product_category_name_translation = pd.read_parquet('data/bronze/olist_product_category_name_translation.parquet')
# eda_inicial(df_olist_product_category_name_translation)