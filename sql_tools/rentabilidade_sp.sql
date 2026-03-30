{{ config(materialized='table') }}

WITH 
pescaixa AS (
   	SELECT  *
   	FROM {{ ref('source_ais_sp_producao')}}
), 
pedcarit AS (
   	SELECT *
   	FROM {{ ref('source_ais_sp_recebimento_produto')}}
), 
pedcarreg AS (
   	SELECT *
    	FROM {{ ref('source_ais_sp_pedido_carregado')}}
), 
USU_TP_BC_SAIDA AS (
   	SELECT *
   	FROM {{ ref('source_ais_sp_boi_casado')}}
), 
t_pedcom AS (
    SELECT *
    FROM {{ ref('source_ais_sp_recebimento_devolucao')}}
), 
T_REC AS (
    SELECT *
    FROM {{ ref("source_ais_sp_recebimento")}}
), 
T_PEDCOMIT AS (
    SELECT *
    FROM {{ ref('source_ais_sp_recebimento_produto_item')}}
), 
valorprod2 AS (
    SELECT *
    FROM {{ ref('source_custo_sao_paulo')}}
), 
BM AS (
    SELECT 
        PED.cod_pedcar,
	    CAST(PES.data_sai AS DATE) AS DATA,
	    PED.cod_emp,
	    PED.cod_repres,
	    PED.status,
	    PES.COD_PROD2
	    PIT.quant
	    PIT.p1	P1
	    PES.sif
	    PES2.num_lote
	    CAST(PED.EMBARQUE AS DATE)  AS DATA_SAIDA
	    SUM(PES.peso_bruto)         AS PESO_BRUTO
	    SUM(PES.peso_liq)           AS PESO_LIQUIDO
	    SUM(PES.quant)              AS QUANTIDADE
	    SUM(PES.NUM_CAIXAS)         AS CAIXAS
	    CASE 
            WHEN PES.cod_inv IS NULL
    	    THEN 'NÃO'
    	    ELSE 'SIM'
    	END							AS INVENTARIO	
	    SUM(PES.peso_liq)*(PIT.p1)	AS VALOR
	    'SAIDA'						AS TIPO
	    pes.validade				AS VALIDADE
        CASE
            WHEN PES.cod_prod = '011000' AND BC.PED IS NOT NULL THEN '011009'
    	    WHEN PES.cod_prod = '011001' AND BC.PED IS NOT NULL THEN '011009'
    	    WHEN PES.cod_prod = '011004' AND BC.PED IS NOT NULL THEN '011009'
    	    ELSE PES.cod_prod
    	END                         AS cod_prod
    FROM pescaixa PES  
    INNER JOIN pedcarit PIT  
        ON  PIT.COD_PROD = PES.COD_PROD
	    AND PIT.cod_pedcar = PES.cod_pedcar
    INNER JOIN pedcarreg PED  
	    ON  PIT.COD_PEDCAR = PED.COD_PEDCAR
    LEFT JOIN pescaixa PES2
	    ON  PES.cod_barra_origem = PES2.cod_barra
    LEFT JOIN USU_TP_BC_SAIDA BC  
	    ON  PES.cod_pedcar = BC.PED
	    AND CASE 
                WHEN PES.cod_prod = '011000' THEN BC.TRA
	    	    WHEN PES.cod_prod = '011001' THEN BC.DIA
	    	    WHEN PES.cod_prod = '011004' THEN BC.PA
	    	    ELSE '99999'
	        END	= PES.cod_prod 

WHERE   CAST(PES.data_sai AS DATE) >= '2025-01-01'
    AND PES.status <> 'C'		  

GROUP BY 
    PED.COD_PEDCAR,
	CAST(PES.data_sai AS DATE),
	PED.cod_emp,
	PED.cod_repres,
	PED.status,
	CASE 
        WHEN PES.cod_prod = '011000' and BC.PED IS NOT NULL THEN '011009'
        WHEN PES.cod_prod = '011001' and BC.PED IS NOT NULL THEN '011009'
	    WHEN PES.cod_prod = '011004' and BC.PED IS NOT NULL THEN '011009'
	    ELSE PES.cod_prod
	END,
	PES.cod_prod2,
	PIT.quant,
	PIT.p1,
	PES.sif,
	PES2.num_lote,
	CAST(PED.embarque AS DATE),
	CASE 
        WHEN PES.cod_inv IS NULL
	    THEN 'NÃO'
	    ELSE 'SIM'
	END
	pes.validade	
), 
terceiro as (
    SELECT 
		PES.cod_pedcar		    	AS pedcar,
	    CAST(PES.data_sai AS DATE)  AS data,
	    PED.cod_emp				    AS empresa,
	    ''						    AS representante,
	    PED.status				    AS status,
	    PES.cod_prod			    AS produto,
	    PES.cod_prod2			    AS produto2,
	    PES.quant				    AS quantidade,
	    PIT.preco				    AS P1,
	    pes.sif					    AS sif,
	    CAST(REC.data_rec AS DATE)  AS data_saida,
	    PES.peso_bruto			    AS peso_bruto,
	    PES.peso_liq			    AS peso_liquido,
	    PES.quant				    AS quantidade,
	    -PES.num_caixas			    AS caixas,
	    'N'						    AS inventario,
	    PES.peso_liq*PIT.preco	    AS valor,
	    'DEVOLUCAO'				    AS tipo,
	    PES.validade			    AS validade
FROM t_pedcom PED
INNER JOIN t_rec REC
	ON  PED.cod_ped	= REC.cod_ped
	AND CAST(REC.data_rec AS DATE) >= '2027-01-01'
	AND REC.tipo_rec = 'D'
INNER JOIN pescaixa	PES
	ON  REC.cod_barra = PES.cod_barra
	AND PES.status <> 'C'
INNER JOIN t_pedcomit PIT
	ON  REC.cod_ped  = PIT.cod_ped
	AND PES.cod_prod = PIT.cod_prod
), 
union_table AS (
    SELECT * 
    FROM BM
    
    UNION  ALL
    
    SELECT * 
    FROM terceiro
)

SELECT
    SAIDAS.cod_pedcar   AS pedcar,
	SAIDAS.data         AS data,
	SAIDAS.cod_temp     AS tempo,
	SAIDAS.cod_repres   AS representante,
	SAIDAS.status       AS status,
	SAIDAS.cod_prod     AS codigo1,
	SAIDAS.cod_prod2    AS codigo2,
	SAIDAS.quant        AS quantidade,
	SAIDAS.p1           AS P1,
	SAIDAS.sif          AS sif,
	SAIDAS.num_lote	    AS lote,
	SAIDAS.data_saida   AS data_saida,
	SAIDAS.peso_bruto   AS peso_bruto,
	SAIDAS.peso_liquido AS peso_liquido,
	SAIDAS.quantidade   AS quantidade2,
	SAIDAS.caixas       AS caixas,
	SAIDAS.inventario   AS inventario,
	SAIDAS.valor        AS valor,
	SAIDAS.tipo         AS tipo,
	SAIDAS.validade     AS validade,
    CUSTO.valor         AS custo,
    CASE 
        WHEN SAIDAS.num_lote IN (0,1) OR SAIDAS.num_lote IS NULL
		THEN cast(SAIDAS.sif as numeric)
		ELSE SAIDAS.num_lote
	END	                AS sif_final
FROM union_Table SAIDAS
LEFT JOIN valorprod2 CUSTO
	ON  SAIDAS.data_saida = CAST((CUSTO.data+1) AS DATE)
	AND SAIDAS.cod_prod2  = CUSTO.cod_prod