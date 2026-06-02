# Estilo do Dashboard Power BI

Este documento registra o padrão visual aplicado ao dashboard `dashboard.pbix` e ao template `modelo_dashboard.pbit`.

## Estrutura Geral

| Elemento | Padrão aplicado |
| :--- | :--- |
| **Formato das páginas** | Canvas horizontal 16:9. |
| **Navegação** | Menu lateral fixo à esquerda, com ícones brancos para filtros e páginas analíticas. |
| **Filtros globais** | Painel ocultável acionado pelo ícone de funil. Os filtros principais são Ano, Mês e Estado. |
| **Fundo da página** | Cinza médio, usado como base para destacar cards e visuais. |
| **Cards e gráficos** | Blocos brancos com cantos arredondados e espaçamento regular. |
| **Tipografia** | Arial, com números grandes nos cards e títulos simples nos visuais. |
| **Rótulos de dados** | Exibidos diretamente nos gráficos, com unidades em Mil ou Mi quando aplicável. |

## Paleta de Cores

| Elemento / Uso | Código Hex | Aplicação no dashboard |
| :--- | :---: | :--- |
| **Fundo da página** | `#A6A6A6` | Área geral das quatro páginas do relatório. |
| **Fundo dos cards e visuais** | `#FFFFFF` | Cartões de KPI, áreas de gráficos, tabela e mapa. |
| **Menu lateral** | `#1F2937` | Barra de navegação fixa à esquerda. |
| **Ícones do menu** | `#FFFFFF` | Ícones de filtro, crescimento, avaliação, mapa e análise. |
| **Texto principal** | `#000000` | Títulos, rótulos, valores e eixos. |
| **Azul principal** | `#3B82F6` | Barras gerais de faturamento e itens vendidos; bolhas do mapa. |
| **Azul escuro** | `#1E3A8A` | Entregas no prazo e faixas de entrega saudáveis. |
| **Laranja de alerta** | `#F59E0B` | Faixa de 15 a 30 dias de entrega. |
| **Vermelho crítico** | `#EF4444` | Pedidos atrasados e faixas acima de 30 dias ou sem informação. |
| **Cinza neutro** | `#9CA3AF` | Status "Não informado" no gráfico de atraso. |
| **Verde de receita** | `#10B981` | Top 10 categorias por faturamento. |
| **Cinza claro de tabela** | `#E5E5E5` | Linhas alternadas da tabela regional. |
| **Cabeçalho/total da tabela** | `#111111` | Cabeçalho e linha total da tabela da página regional. |

## Páginas e Visuais

### Página 1 - Crescimento e Retenção

| Área | Estilo |
| :--- | :--- |
| **Cards** | Taxa de Recompra, Total de Pedidos, Faturamento Total, Clientes Recorrentes e Clientes Únicos em cards brancos. |
| **Gráfico principal** | Colunas azuis para `Faturamento_Total` por `nome_mes`. |
| **Rótulos** | Valores em milhões com uma casa decimal, posicionados acima das colunas. |

### Página 2 - Entrega vs Satisfação

| Área | Estilo |
| :--- | :--- |
| **Cards** | Total de Avaliações, Nota Média das Avaliações, Taxa de Atraso e Tempo Médio de Entrega em Dias. |
| **Faixas de entrega** | Barras horizontais com escala semafórica: azul escuro para até 14 dias, laranja para 15 a 30 dias e vermelho para maior que 30 dias ou não informado. |
| **Atraso por categoria** | Barras por status de atraso e linha cinza para a nota média. |
| **Status** | "Não" em azul escuro, "Sim" em vermelho e "Não informado" em cinza. |

### Página 3 - Análise Regional

| Área | Estilo |
| :--- | :--- |
| **Tabela regional** | Cabeçalho e total em fundo preto, texto branco; linhas alternadas em branco e cinza claro. |
| **Cards** | Frete Médio Nacional e Tempo Médio de Entrega destacados no topo direito. |
| **Mapa** | Mapa do Brasil com bolhas azuis por localização dos clientes/estados. |
| **Métricas da tabela** | Estado, Total de Pedidos, Taxa de Atraso, Frete Médio, Tempo Médio de Entrega, Média de Itens e Nota Média. |

### Página 4 - Performance de Categorias

| Área | Estilo |
| :--- | :--- |
| **Cards** | Total de Produtos, Total de Categorias e Ticket Médio. |
| **Top 10 por faturamento** | Barras horizontais verdes para destacar categorias que mais geram receita. |
| **Top 5 itens vendidos** | Colunas azuis para as categorias com maior volume de itens. |
| **Rótulos** | Valores em milhões exibidos diretamente nas barras/colunas. |

## Padrões de Formatação

| Tipo de métrica | Formatação |
| :--- | :--- |
| **Valores monetários em cards** | Prefixo `R$`, separador decimal com vírgula e unidade Mi quando necessário. |
| **Percentuais** | Duas casas decimais nos cards principais. |
| **Notas médias** | Duas casas decimais. |
| **Contagens grandes** | Unidade Mil nos cards e rótulos. |
| **Tempo médio** | Número inteiro de dias. |
| **Valores de gráficos** | Rótulos ligados ao contexto do visual: Mi para receita e Mil para volume. |

