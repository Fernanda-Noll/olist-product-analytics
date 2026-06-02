# Produto e Estratégia de Soluções

Este documento descreve como chegamos às oportunidades, soluções priorizadas e próximos passos de produto a partir das hipóteses de negócio, da árvore de oportunidades e da matriz RICE.

Imagem de referência: `docs/figma_produto.png`.

---

## 1. Contexto

O dashboard mostrou indicadores de vendas, recompra, satisfação, entrega, atraso, regiões e categorias. A partir dessa leitura, o problema de produto escolhido foi:

**Como aumentar o número de clientes que voltam a comprar?**

Esse recorte foi escolhido porque crescimento de vendas sozinho não garante sustentabilidade. Para gerar valor recorrente, o produto precisa melhorar a recompra e reduzir fatores que afastam o cliente depois da primeira experiência.

---

## 2. Hipóteses Consideradas

As hipóteses usadas no discovery foram:

| Tema | Hipótese |
| :--- | :--- |
| Vendas | Estamos vendendo mais? |
| Retenção | Os clientes continuam comprando conosco? |
| Satisfação | Clientes satisfeitos têm maior potencial de recompra? |
| Entrega e recompra | Os clientes que demoram para receber os produtos voltam a comprar? |
| Entrega e satisfação | A experiência de entrega impacta diretamente a satisfação? |
| Atraso e avaliação | Pedidos atrasados ou que demoram para chegar impactam a avaliação do cliente? |
| Região | Atrasos afetam mais algumas regiões do que outras? |
| Categoria | Categorias de produto têm experiências diferentes? |

Nem todas as hipóteses foram validadas diretamente no dashboard atual. Para a etapa de produto, elas serviram como ponto de partida para organizar oportunidades de retenção.

---

## 3. Árvore de Oportunidades

### Objetivo

**Aumentar a taxa de recompra para 20%.**

### Oportunidades Priorizadas

| Oportunidade | Racional | Solução/experimento |
| :--- | :--- | :--- |
| **Diminuir o tempo de entrega e atraso** | Entregas lentas ou atrasadas prejudicam a experiência e podem reduzir a chance de recompra. | Teste piloto de novo centro logístico na região Sudeste. |
| **O cliente não tem incentivo claro para fazer a segunda compra** | Depois da primeira compra, falta um estímulo direto para o cliente voltar. | Teste A/B: 50% dos clientes recebem cupom após a primeira compra e 50% seguem sem cupom. |
| **Clientes com baixa avaliação não voltam a comprar** | Clientes detratores precisam de uma ação de recuperação para evitar perda definitiva. | Teste A/B: 50% recebem cupom após avaliação baixa e 50% recebem contato da equipe. |

### Indicadores de Sucesso

| Experimento | Pergunta de validação |
| :--- | :--- |
| Novo centro logístico | A redução de atrasos aumenta a recompra e a satisfação? |
| Cupom após primeira compra | A taxa de recompra aumentou em até 30 dias? |
| Recuperação de clientes detratores | O cliente voltou a comprar depois da ação de recuperação? |

---

## 4. Priorização RICE

A matriz RICE foi usada para comparar os experimentos de forma objetiva.

### Critérios

Pontuação de 1 a 5:

- **5:** maior importância.
- **1:** sem importância ou menor relevância.

### Fórmula

```text
RICE Score = (Alcance x Impacto x Confiança) / Esforço
```

### Resultado

| Solução / Experimento | Reach | Impact | Confidence | Effort | RICE Score |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Teste piloto de novo centro logístico na região Sudeste. | 5 | 5 | 5 | 4 | **31.25** |
| Teste A/B: 50% dos clientes ganham cupom após a primeira compra e 50% seguem sem cupom. | 4 | 3 | 3 | 2 | **18** |
| Teste A/B: 50% dos clientes com avaliação baixa ganham cupom e 50% recebem contato da equipe. | 5 | 5 | 3 | 3 | **25** |

---

## 5. Conclusão

A solução prioritária é o **teste piloto de novo centro logístico na região Sudeste**, pois teve o maior RICE Score. Mesmo com maior esforço, ela combina alto alcance, alto impacto e alta confiança.

Ordem sugerida:

1. **Novo centro logístico na região Sudeste** - prioridade 1.
2. **Recuperação de clientes com avaliação baixa** - prioridade 2.
3. **Cupom após primeira compra** - prioridade 3.

O objetivo dos próximos passos é validar se essas iniciativas aumentam a recompra, reduzem o atrito na experiência e aproximam o produto da meta de **20% de taxa de recompra**.