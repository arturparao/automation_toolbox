# 📊 SQL Quick Guide para Controladoria & Dados
Este guia contém as consultas e funções essenciais para o dia a dia de análise de dados financeiros e auditoria.

## 📅 Manipulação de Datas (KPIs de Prazo)
Essenciais para calcular **Prazo Médio de Pagamento (PMP)** e **Recebimento (PMR)**.
```sql
-- Diferença de dias entre datas (SQL Server/Postgres)
SELECT DATEDIFF(day, data_vencimento, data_pagamento) AS dias_atraso;

-- Filtrar apenas movimentações do mês atual
SELECT * 
FROM lancamentos

WHERE MONTH(data_emissao) = MONTH(GETDATE()) 
  AND YEAR(data_emissao) = YEAR(GETDATE());
```
## 💰 Agregações e Filtros de Negócio
Para consolidar gastos por Centro de Custo e filtrar desvios.
```sql
SELECT 
    centro_custo, 
    SUM(valor) AS total_gasto,
    COUNT(id_nota) AS qtd_notas
FROM notas_fiscais

WHERE status = 'Pago'

GROUP BY centro_custo

HAVING SUM(valor) > 10000 -- Mostra apenas centros que gastaram mais de 10k

ORDER BY 
    total_gasto DESC;
```
## 🔍 Consultas de Auditoria (Data Quality)
Para encontrar erros na base antes de importar para o Power BI.
```sql
-- Encontrar notas sem Centro de Custo (Nulos)
SELECT * 
FROM notas_fiscais 
WHERE centro_custo IS NULL;
-- Encontrar possíveis duplicidade de lançamentos
SELECT 
    numero_nota, 
    COUNT(*) 
FROM notas_fiscais 

GROUP BY 
    numero_nota 

HAVING COUNT(*) > 1;
```
## 🏆 Window Functions (Ranking e Evolução)
Para comparar o gasto de um Centro de Custo com o total da empresa.
```sql
SELECT 
    centro_custo, 
    valor,
    -- Calcula a participação percentual de cada linha no total
    valor / SUM(valor) OVER() * 100 AS perc_do_total,
    -- Ranking dos maiores gastos
    RANK() OVER(ORDER BY valor DESC) AS ranking_gasto
FROM despesas;
```
## 🛠️ Boas Práticas
Alias (AS): Sempre use apelidos claros para colunas calculadas.
Indentação: Mantenha o código legível (Palavras-chave em MAIÚSCULO).
Filtros: Use sempre o WHERE antes do GROUP BY para ganhar performance.