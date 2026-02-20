{{config(materialized='table')}}

WITH 

t_ordem_retorno AS (
    SELECT
        cod_inc_pai,
        dt_desembarque
    FROM {{ref('source_ais_ordem_retorno')}}
), 

t_ordem_retorno_gta AS (
    SELECT
        cod_inc_pai,
        cod_veiculo
    FROM {{ref('source_ais_ordem_retorno_gta')}}
), 

T_TOTEM_GADO AS (
    SELECT
        data,
        placa,
        data_abate
    FROM {{ref('source_ais_totem_gado')}}
),

Desembarque AS (
    SELECT
        G.cod_veiculo,
        R.dt_desembarque
    FROM t_ordem_retorno R
    LEFT JOIN t_ordem_retorno_gta G
        ON G.cod_inc_pai = R.cod_inc_pai
),

match AS (
    SELECT
        t.data_abate,
        t.'data',
        t.placa,
        d.dt_desembarque,
        ROW_NUMBER() OVER (
            PARTITION BY t.placa, t.data_abate, t.'data'
            ORDER BY d.dt_desembarque ASC
        ) AS rn
    FROM t_totem_gado t
    LEFT JOIN desembarque d
        ON  d.cod_veiculo = t.placa
        AND d.dt_desembarque >= t.'data'
),

pick_next AS (
    SELECT 
        data_abate, 
        'data', 
        placa, 
        dt_desembarque
    FROM match

    WHERE 
        rn = 1
),

dedup AS (
    SELECT
        data_abate, 
        'data', 
        placa, 
        dt_desembarque,
        ROW_NUMBER() OVER (
            PARTITION BY placa, dt_desembarque, data_abate
            ORDER BY "data" DESC
        ) AS rk
    FROM pick_next
)

SELECT
    data_abate, 
    'data', 
    placa, 
    dt_desembarque
FROM dedup

WHERE 
    rk = 1


