{{ config(materialized='table') }}

WITH pescaixa AS (
    SELECT
        *
    FROM {{ ref('source_ais_sp_producao')}}
), pedcarit AS (
    SELECT
        *
    FROM {{ ref('source_ais_sp_recebimento_produto')}}
), pedcarreg AS (
    SELECT
        *
    FROM {{ ref('source_ais_sp_pedido_carregado')}}
), USU_TP_BC_SAIDA AS (
    SELECT
        *
    FROM {{ ref('source_ais_sp_boi_casado')}}
), t_pedcom AS (
    SELECT
        *
    FROM {{ ref('source_ais_sp_recebimento_devolucao')}}
), T_REC AS (
    SELECT
        *
    FROM {{ ref("source_ais_sp_recebimento")}}
), T_PEDCOMIT AS (
    SELECT
        *
    FROM {{ ref('source_ais_sp_recebimento_produto_item')}}
), valorprod2 AS (
    SELECT
        *
    FROM {{ ref('source_custo_sao_paulo')}}
), BM AS (
    
    SELECT PED.COD_PEDCAR
	  ,CAST(PES.data_sai AS DATE)				DATA
	  ,PED.cod_emp
	  ,PED.cod_repres
	  ,PED.status
	  ,CASE WHEN PES.cod_prod = '011000' and BC.PED IS NOT NULL
			THEN '011009'
			WHEN PES.cod_prod = '011001'  and BC.PED IS NOT NULL
			THEN '011009'
			WHEN PES.cod_prod = '011004'  and BC.PED IS NOT NULL
			THEN '011009'
			ELSE PES.cod_prod
			END								cod_prod
	  ,PES.COD_PROD2
	  ,PIT.quant
	  ,PIT.p1	P1
	  ,PES.sif
	  ,PES2.num_lote
	  ,CAST(PED.EMBARQUE AS DATE)		AS DATA_SAIDA
	  ,SUM(PES.peso_bruto)				AS PESO_BRUTO
	  ,SUM(PES.peso_liq)				AS PESO_LIQUIDO
	  ,SUM(PES.quant)					AS QUANTIDADE
	  ,SUM(PES.NUM_CAIXAS)				AS CAIXAS
	  ,CASE WHEN PES.cod_inv IS NULL
			THEN 'NÃO'
			ELSE 'SIM'
			END							AS INVENTARIO	
	  ,SUM(PES.peso_liq)*(PIT.p1)				AS VALOR
	  ,'SAIDA'							AS TIPO
	  ,pes.validade						AS VALIDADE


  FROM pescaixa						PES  
  INNER JOIN pedcarit				PIT  
		  ON PIT.COD_PROD			= PES.COD_PROD
		 AND PIT.cod_pedcar			= PES.cod_pedcar
  INNER JOIN pedcarreg				PED  
	      ON PIT.COD_PEDCAR			= PED.COD_PEDCAR
   LEFT JOIN pescaixa				PES2
		  ON PES.cod_barra_origem	= PES2.cod_barra

   LEFT JOIN USU_TP_BC_SAIDA		BC  
	      ON PES.cod_pedcar 	    = BC.PED
		 AND CASE WHEN PES.cod_prod = '011000'
				  THEN BC.TRA
				  WHEN PES.cod_prod = '011001'
				  THEN BC.DIA
				  WHEN PES.cod_prod = '011004'
				  THEN BC.PA
				  ELSE '99999'
				  END					= PES.cod_prod 
 WHERE CAST(PES.data_sai	AS DATE) >= '2025-01-01'
   AND PES.status <> 'C'		  
  GROUP BY PED.COD_PEDCAR
		  ,CAST(PES.data_sai AS DATE)
		  ,PED.cod_emp
		  ,PED.cod_repres
		  ,PED.status
	  ,CASE WHEN PES.cod_prod = '011000' and BC.PED IS NOT NULL
			THEN '011009'
			WHEN PES.cod_prod = '011001'  and BC.PED IS NOT NULL
			THEN '011009'
			WHEN PES.cod_prod = '011004'  and BC.PED IS NOT NULL
			THEN '011009'
			ELSE PES.cod_prod
			END	
		  ,PES.COD_PROD2
		  ,PIT.quant
		  ,PIT.p1
		  ,PES.sif
		  ,PES2.num_lote
		  ,CAST(PED.embarque AS DATE)
		  ,CASE WHEN PES.cod_inv IS NULL
			    THEN 'NÃO'
				ELSE 'SIM'
				END
		   ,pes.validade	
), TERCEIRO as (
 SELECT PES.cod_pedcar								COD_PEDCAR
	  , CAST(PES.data_sai AS DATE)					DATA
	  , PED.cod_emp									COD_EMP
	  , ''											COD_REPRES
	  , PED.status									STATUS
	  ,PES.cod_prod									COD_PROD
	  ,PES.cod_prod2								COD_PROD2
	  ,PES.quant									QUANT
	  ,PIT.preco									P1
	  ,pes.sif											SIF
	  ,0											SIF_TRANSFORMADO
	  , CAST(REC.data_rec AS DATE)					DATA_SAIDA
	  , -PES.peso_bruto								PESO_BRUTO
	  , -PES.peso_liq								PESO_LIQUIDO
	  , -PES.quant									QUANTIDADE
	  , -PES.num_caixas								CAIXAS
	  , 'N'											INVENTARIO
	  , -PES.peso_liq*PIT.preco						VALOR
	  , 'DEVOLUÇÃO'									TIPO
	  ,PES.validade									VALIDADE

  FROM t_pedcom										PED
  INNER JOIN T_REC									REC
		  ON PED.COD_PED							= REC.COD_PED
		 AND CAST(REC.data_rec	AS DATE)			>= '2025-01-01'
		 AND REC.tipo_rec							= 'D'
  INNER JOIN PESCAIXA								PES
		  ON REC.COD_BARRA	 					    = PES.cod_barra
		 AND PES.status								<> 'C'
  INNER JOIN T_PEDCOMIT								PIT
		  ON REC.cod_ped							= PIT.cod_ped
		 AND PES.cod_prod							= PIT.cod_prod
), union_Table AS (
SELECT * FROM BM

UNION  all

select * from TERCEIRO
)
    SELECT
        SAIDAS.COD_PEDCAR
	  ,SAIDAS.DATA
	  ,SAIDAS.COD_EMP
	  ,SAIDAS.COD_REPRES
	  ,SAIDAS.STATUS
	  ,SAIDAS.COD_PROD
	  ,SAIDAS.COD_PROD2
	  ,SAIDAS.QUANT
	  ,SAIDAS.P1
	  ,CUSTO.valor				CUSTO
	  ,SAIDAS.sif
	  ,SAIDAS.num_lote			SIF_TRANSFORMADO
	  ,CASE 
            WHEN SAIDAS.num_lote IN (0,1) OR SAIDAS.num_lote IS NULL
			    THEN cast(SAIDAS.sif as numeric)
			ELSE SAIDAS.num_lote
		END					SIF_FINAL
	  ,SAIDAS.DATA_SAIDA
	  ,SAIDAS.PESO_BRUTO
	  ,SAIDAS.PESO_LIQUIDO
	  ,SAIDAS.QUANTIDADE
	  ,SAIDAS.CAIXAS
	  ,SAIDAS.INVENTARIO
	  ,SAIDAS.VALOR
	  ,SAIDAS.TIPO
	  ,SAIDAS.VALIDADE

    FROM union_Table SAIDAS

    LEFT JOIN valorprod2								CUSTO
	  ON SAIDAS.DATA_SAIDA						= CAST((CUSTO.data+1) AS DATE)
	 AND SAIDAS.cod_prod2						= CUSTO.cod_prod