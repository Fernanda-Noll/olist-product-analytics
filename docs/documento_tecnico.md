# Documento Técnico

Este documento resume as principais tecnologias utilizadas no projeto e o motivo de cada escolha.

| Tecnologia | Onde foi usada | Motivo da escolha |
| :--- | :--- | :--- |
| **Python** | Scripts `eda_inicial.py`, `api_ibge.py` e `pipeline_dados.py`. | Automatizar a leitura, validação, enriquecimento e execução do pipeline de dados. |
| **Pandas** | `eda_inicial.py` e `api_ibge.py`. | Facilitar a exploração inicial dos dados e a estruturação da base de municípios do IBGE. |
| **Requests** | `api_ibge.py`. | Consumir a API pública do IBGE de forma simples e salvar os dados de municípios na camada de referência. |
| **DuckDB** | Execução dos arquivos SQL e geração das camadas Bronze, Silver e Gold. | Permitir trabalhar com SQL localmente, de forma simples e eficiente, usando arquivos Parquet. |
| **SQL** | Consultas das pastas `sql/bronze`, `sql/silver` e `sql/gold`. | Praticar transformações analíticas e deixar as regras de tratamento mais claras e reproduzíveis. |
| **Parquet** | Armazenamento das camadas `data/bronze`, `data/silver`, `data/gold` e `data/reference`. | Reduzir o tamanho dos arquivos e melhorar o desempenho de leitura em comparação com CSV. |
| **API do IBGE** | `api_ibge.py`, gerando `data/reference/municipios_ibge.parquet`. | Obter nomes oficiais de municípios, UFs e regiões para padronizar cidades e melhorar a qualidade geográfica dos dados. |
| **Power BI** | Dashboard e template na pasta `power_bi`. | Construir os indicadores, filtros e visuais finais para análise de negócio. |
| **Figma** | `docs/figma_produto.png`. | Organizar a árvore de oportunidades e a matriz RICE usadas na etapa de produto. |

## Função dos Arquivos Python

| Arquivo | Funcionalidade |
| :--- | :--- |
| `api_ibge.py` | Consulta a API pública do IBGE, extrai dados de municípios, normaliza o nome das cidades e salva o resultado em `data/reference/municipios_ibge.parquet`. |
| `eda_inicial.py` | Reúne uma função de EDA para verificar uma amostra dos dados, tipos, tamanho, valores nulos, duplicados, quantidade de valores distintos e estatísticas descritivas. |
| `pipeline_dados.py` | Executa os arquivos SQL em ordem, criando as camadas Bronze, Silver e Gold e garantindo a sequência correta do pipeline Medallion. |

## Arquitetura

O projeto utiliza a arquitetura **Medallion**:

- **Bronze:** conversão dos CSVs originais para Parquet.
- **Silver:** limpeza, padronização e tratamento dos dados.
- **Gold:** criação das tabelas finais usadas no Power BI.

Essa estrutura foi escolhida para separar dados brutos, dados tratados e dados prontos para análise, facilitando a manutenção e a rastreabilidade.