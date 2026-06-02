# Medidas Power BI

As medidas abaixo estão alinhadas aos visuais do dashboard `dashboard.pbix`. Elas ficam centralizadas na tabela `Medidas` do modelo semântico.

## Página 1 - Crescimento e Retenção

### Total_de_Pedidos

Usada nos cards de volume, no gráfico de análise temporal e na tabela regional.

```DAX
DISTINCTCOUNT(fato_pedidos[pedido_id])
```

### Faturamento_Total

Usada no card de faturamento e no gráfico `Faturamento Total por Mês`.

```DAX
SUM(fato_pedidos[valor_pago])
```

### Clientes_Unicos

Usada no card `Clientes Únicos`.

```DAX
DISTINCTCOUNT(fato_pedidos[cliente_unico_id])
```

### Clientes_Recorrentes

Usada no card `Clientes Recorrentes`. Considera recorrente o cliente único com mais de um pedido.

```DAX
COUNTROWS(
    FILTER(
        VALUES(fato_pedidos[cliente_unico_id]),
        CALCULATE(DISTINCTCOUNT(fato_pedidos[pedido_id])) > 1
    )
)
```

### Taxa_de_Recompra

Usada no card `Taxa de Recompra`.

```DAX
DIVIDE(
    [Clientes_Recorrentes],
    [Clientes_Unicos]
)
```

## Página 2 - Entrega vs Satisfação

### Qtd_Avaliacoes

Usada no card `Total de Avaliações`.

```DAX
COUNTROWS(fato_avaliacoes)
```

### Nota_Media

Usada no card `Nota Média das Avaliações`, na análise por faixa de tempo de entrega e na linha do gráfico por atraso.

```DAX
AVERAGE(fato_avaliacoes[nota_avaliacao])
```

### Tempo_Medio_Entrega

Usada no card `Tempo Médio de Entrega em Dias` e na tabela regional.

```DAX
AVERAGE(fato_pedidos[dias_ate_entrega])
```

### Pedidos_Atrasados

Medida auxiliar para contagem de pedidos com entrega atrasada.

```DAX
CALCULATE(
    [Total_de_Pedidos],
    fato_pedidos[entrega_atrasada] = "Sim"
)
```

### Taxa_de_Atraso

Usada no card `Taxa de Atraso`, na tabela regional e como referência para análise logística.

```DAX
DIVIDE(
    CALCULATE(
        COUNTROWS(fato_pedidos),
        fato_pedidos[entrega_atrasada] = "Sim"
    ),
    CALCULATE(
        COUNTROWS(fato_pedidos),
        fato_pedidos[entrega_atrasada] <> "Não informado"
    )
)
```

## Página 3 - Análise Regional

### Frete_Total

Medida auxiliar para cálculos de frete.

```DAX
SUM(fato_pedidos[valor_frete])
```

### Frete_Medio_Por_Pedido

Usada como base para o frete médio por região e para o frete médio nacional.

```DAX
DIVIDE(
    [Frete_Total],
    [Total_de_Pedidos]
)
```

### Frete_Medio_Nacional

Usada no card `Preço do Frete Médio Nacional`. Remove o filtro geográfico de clientes para mostrar a referência nacional.

```DAX
CALCULATE(
    [Frete_Medio_Por_Pedido],
    REMOVEFILTERS(
        dim_geolocalizacao_clientes[estado],
        dim_geolocalizacao_clientes[cidade],
        dim_geolocalizacao_clientes[cep_prefixo]
    )
)
```

### Qtd_Media_Itens_Por_Pedido

Usada na coluna `Média de Itens` da tabela regional.

```DAX
DIVIDE(
    SUM(fato_itens_pedido[quantidade_item]),
    DISTINCTCOUNT(fato_itens_pedido[pedido_id])
)
```

## Página 4 - Performance de Categorias

### Total_de_Produtos

Usada no card `Total de Produtos`.

```DAX
DISTINCTCOUNT(dim_produto[produto_id])
```

### Total_de_Categorias

Usada no card `Total de Categorias`.

```DAX
DISTINCTCOUNT(dim_produto[categoria_produto])
```

### Ticket_Medio

Usada no card `Ticket Médio`.

```DAX
DIVIDE(
    [Faturamento_Total],
    [Total_de_Pedidos]
)
```

### Receita_Produtos

Usada no gráfico `Top 10 Categorias por Faturamento`.

```DAX
SUM(fato_itens_pedido[preco_item])
```

### Quantidade_Itens_Vendidos

Usada no gráfico `Top 5 Categorias com Itens Mais Vendidos`.

```DAX
SUM(fato_itens_pedido[quantidade_item])
```

## Observações de Uso

| Medida | Formatação recomendada | Visual principal |
| :--- | :--- | :--- |
| `Faturamento_Total` | Moeda, unidade Mi | Card e colunas por mês |
| `Taxa_de_Recompra` | Percentual, 2 casas decimais | Card de retenção |
| `Taxa_de_Atraso` | Percentual, 2 casas decimais | Card e tabela regional |
| `Nota_Media` | Decimal, 2 casas decimais | Card e gráficos de satisfação |
| `Tempo_Medio_Entrega` | Número inteiro | Cards e tabela regional |
| `Frete_Medio_Nacional` | Moeda, 2 casas decimais | Card regional |
| `Ticket_Medio` | Moeda, 2 casas decimais | Card de categorias |
| `Receita_Produtos` | Moeda, unidade Mi | Top 10 categorias |
| `Quantidade_Itens_Vendidos` | Número, unidade Mil | Top 5 categorias |

