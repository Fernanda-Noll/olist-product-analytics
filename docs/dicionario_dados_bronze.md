# Dicionário de Dados - Camada Bronze

A camada bronze contém a cópia dos dados brutos da pasta `data/raw` para arquivos Parquet em `data/bronze`.

Os arquivos CSV foram lidos com DuckDB usando `ALL_VARCHAR = TRUE`, portanto todos os campos foram importados como `VARCHAR`. Nesta camada não houve tratamento, padronização ou limpeza.

| Tabela bronze | Origem | Formato | Dados |
|---|---|---|---|
| `olist_customers_dataset` | `data/raw/olist_customers_dataset.csv` | Parquet | Brutos, sem tratamento |
| `olist_geolocation_dataset` | `data/raw/olist_geolocation_dataset.csv` | Parquet | Brutos, sem tratamento |
| `olist_orders_dataset` | `data/raw/olist_orders_dataset.csv` | Parquet | Brutos, sem tratamento |
| `olist_order_items_dataset` | `data/raw/olist_order_items_dataset.csv` | Parquet | Brutos, sem tratamento |
| `olist_order_payments_dataset` | `data/raw/olist_order_payments_dataset.csv` | Parquet | Brutos, sem tratamento |
| `olist_order_reviews_dataset` | `data/raw/olist_order_reviews_dataset.csv` | Parquet | Brutos, sem tratamento |
| `olist_products_dataset` | `data/raw/olist_products_dataset.csv` | Parquet | Brutos, sem tratamento |
| `olist_product_category_name_translation` | `data/raw/olist_product_category_name_translation.csv` | Parquet | Brutos, sem tratamento |
| `olist_sellers_dataset` | `data/raw/olist_sellers_dataset.csv` | Parquet | Brutos, sem tratamento |

## Comando Base

Para instalar a dependência necessária:

```bash
pip install duckdb
```