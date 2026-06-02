from pathlib import Path
import pandas as pd
import requests

URL_MUNICIPIOS = "https://servicodados.ibge.gov.br/api/v1/localidades/municipios"
OUTPUT_PATH = Path("data/reference/municipios_ibge.parquet")


def extrair_dados(municipio):
    if municipio.get("microrregiao"):
        uf = municipio["microrregiao"]["mesorregiao"]["UF"]
    else:
        uf = municipio["regiao-imediata"]["regiao-intermediaria"]["UF"]

    return {
        "codigo_municipio_ibge": municipio["id"],
        "cidade_exibicao": municipio["nome"],
        "uf": uf["sigla"],
        "nome_estado": uf["nome"],
        "regiao": uf["regiao"]["nome"],
    }


def main():
    resposta = requests.get(URL_MUNICIPIOS, timeout=30).json()

    df = pd.DataFrame([extrair_dados(m) for m in resposta])

    # 3. Normalização de texto vetorizada (remove acentos, espaços extras e deixa minúsculo)
    df["cidade_normalizada"] = (
        df["cidade_exibicao"]
        .str.normalize("NFKD")
        .str.encode("ascii", errors="ignore")
        .str.decode("utf-8")
        .str.lower()
        .str.replace(r"\s+", " ", regex=True)
        .str.strip()
    )

    df = df.sort_values(["uf", "cidade_normalizada"]).reset_index(drop=True)

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    df.to_parquet(OUTPUT_PATH, index=False)

    print(f"Arquivo gerado: {OUTPUT_PATH}")
    print(f"Total de municipios: {len(df)}")


if __name__ == "__main__":
    main()