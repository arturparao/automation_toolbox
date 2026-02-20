{{ config(materialized='table')}}

WITH

imposto_entrada AS (
    SELECT
        codemp,																						
		codfor,																			
		codfil,                                                                           
		nomfor,                                                                           
		codsnf,                                                                           
		numnfi,
		nopope,                                                                           
		datent,                                                                           
		codtns,																			
		destns,																			
		cplpro,                                                                           
		codfam,                                                                           
		desfam,
		cod_unificado,
		des_unificado,	                                                                                                                                                                             						                
		qtdent,	                                                                        
		unimed,                                                                           
		preuni,                                                                           
		vlrctb,                                                                           
		vlricm,
		codedc,                                                                           
		cstipi,
		cstpis,                                                                          
		cstcof,                                                                           
		bascre,                                                                           
		clafis,
		vlrisc,
		cprtcf,
		dt_carga,
		seqipc,
		peripi,
		vlrbip,
		vlripi,
		codstr,
		vlrmrc,
		pericm,
		vlrbic,
		perpir,
		vlrbpr,
		vlrpir,
		percor,
		vlrbcr,
		vlrcor,
		periss,
		vlrbis,
		vlriss,
		perirf,
		vlrbir,
		vlrirf,
		perins,
		vlrbin,
		vlrins,
		perour,
		vlrbor,
		vlrour,
		vlriip,
		vlroip,
		vlripn,
		vlroic,
		vlriic,
		vlrdsc,
		vlrcip,
		vlriop,
		vlrbid,
		vlripd,
        raides,
        rairem,
		datger
    FROM {{ ref('staging_imposto_entrada') }}
),

suprimento_entrada AS (
    SELECT
        codemp,
		codfil,
		codfor,
		nomfor,
		numnfc,
		codsnf,
		datent,
		qtdrec,											   
		datemi,	
		coddep,
		numprj,
		coduni,
		sequni,
		codfam,
		tnsuni,
		destns,
		desfam,
		desuni,
		Ori_Transacao,
		vlrliq,
		codstr,
	    cstpis,
	    cstcof,
		cstipi,
	    pericm,
	    perpir,
	    percor,
	    peripi,
	    vlricm,
	    vlrpis,
	    vlrcor,
	    vlrbpi,
	    vlrbcr,
	    vlrbic,
	    vlrout,
	    vlrour,
	    vlroic,
		numocp,
		cprtcf,
		dt_carga
    FROM {{ ref('staging_suprimento_entrada') }}
),

cep AS (
    SELECT
        codrai,
        sigufs
    FROM {{ ref('source_cep') }}
),

cadastro_cliente_historico AS (
    SELECT
        codemp,
      	codfil,
      	codcli,
      	confin
    FROM {{ ref('source_cadastro_cliente_historico') }}
),

preco_pauta AS (
    SELECT
        codemp,
        codtpr,
        codpro,
        datini,
        prebas
    FROM {{ ref('source_preco_pauta') }} 
),

source_compra_ordem_dado_geral AS (
    SELECT
        compra_ordem_dado_geral_numocp AS numocp,
		compra_ordem_dado_geral_codemp AS codemp,
      	compra_ordem_dado_geral_codfil AS codfil,
		obsocp
    FROM {{ ref('source_compra_ordem_dado_geral') }}
),

imposto_suprimento_entrada_I AS (
    SELECT
        I.codemp		AS codemp,																						
		I.codfor		AS codfor,																			
		I.codfil		AS codfil,                                                                           
		I.nomfor		AS nomfor,                                                                           
		I.codsnf		AS codsnf,	                                                                           
		I.numnfi		AS numnfi,                                                                       
		I.datent		AS datent,                                                                           
		I.codtns        AS codtns,															
		I.destns		AS destns,																		                                                                         
		I.codfam		AS codfam,                                                                          
		I.desfam		AS desfam,
		I.cod_unificado	AS cod_unificado,
		I.des_unificado	AS des_unificado,
		I.seqipc		AS seqipc,
		S.vlrliq,   
		S.Ori_Transacao,
        S.qtdrec,
        S.datemi,
		S.numprj,
		S.coddep, 
		S.dt_carga		AS S_dt_carga,
		I.dt_carga		AS I_dt_carga,
		I.cplpro,  
		I.nopope,  												                                                                                                                                                                         						                
		I.qtdent,	                                                                        
		I.unimed,                                                                           
		I.preuni,                                                                       
		I.vlrctb,                                                                           
		I.codedc,                                                                                                                                                                                                                           
		I.bascre,                                                                           
		I.clafis,
		I.vlrisc,
		I.codstr        AS codstr,
		I.cstpis        AS cstpis,
		I.cstcof        AS cstcof,
		I.cstipi        AS cstipi,	
		I.pericm        AS pericm,
		I.perpir        AS perpir,
		I.percor        AS percor,	
		I.peripi        AS peripi,
		I.vlricm        AS vlricm,
		S.vlrpis,
		I.vlrcor        AS vlrcor,
		I.vlrbcr        AS vlrbcr,
		I.vlrbic        AS vlrbic,
		S.vlrout,
		I.vlrour        AS vlrour,
		I.vlroic        AS vlroic,
		I.cprtcf,
		I.vlrbip,
		I.vlripi,
		I.vlrmrc,
		I.vlrbpr,
		I.vlrpir,
		I.periss,
		I.vlrbis,
		I.vlriss,
		I.perirf,
		I.vlrbir,
		I.vlrirf,
		I.perins,
		I.vlrbin,
		I.vlrins,
		I.perour,
		I.vlrbor,
		I.vlriip,
		I.vlroip,
		I.vlripn,
		I.vlriic,
		I.vlrdsc,
		I.vlrcip,
		I.vlriop,
		I.vlrbid,
		I.vlripd,
		I.datger,
		I.raides,
		I.rairem,
        C1.sigufs       AS ufsdes,
        C2.sigufs       AS ufsrem,
		CCH.confin,
		PP.prebas,
		S.numocp,
		CO.obsocp
    FROM  suprimento_entrada    S
	LEFT JOIN imposto_entrada 	I
		ON	I.codemp = S.codemp
		AND	I.codfil = S.codfil
		AND I.codfor = S.codfor
		AND I.numnfi = S.numnfc
		AND I.codsnf = S.codsnf
		AND I.cod_unificado = S.coduni
		AND I.seqipc = S.sequni 
    LEFT JOIN cep C1
       	ON  C1.codrai = I.raides
    LEFT JOIN cep C2
       	ON  C2.codrai = I.rairem
	LEFT JOIN cadastro_cliente_historico CCH
	    ON  CCH.codemp = I.codemp
	    AND CCH.codfil = I.codfil
		AND CCh.codcli = I.codfor 
	LEFT JOIN preco_pauta PP	
		ON  PP.codemp = I.codemp 
		AND PP.codpro = I.cod_unificado
	LEFT JOIN source_compra_ordem_dado_geral CO
		ON  CO.codemp = S.codemp
		AND CO.codfil = S.codfil
		AND CO.numocp = S.numocp
	
WHERE
        I.datent >= '20250101'	
	AND S.codsnf not in ('NDB','REC')
),

imposto_suprimento_entrada_S AS (
    SELECT
        S.codemp        AS codemp,																						
		S.codfor        AS codfor,																			
		S.codfil        AS codfil,                                                                           
		S.nomfor        AS nomfor,                                                                           
		S.codsnf        AS codsnf,	                                                                           
		S.numnfc        AS numnfi,                                                                       
		S.datent        AS datent,                                                                           
		S.tnsuni        AS codtns,															
		S.destns        AS destns,																		                                                                         
		S.codfam        AS codfam,                                                                          
		S.desfam        AS desfam,
		S.coduni        AS cod_unificado,
		S.desuni        AS des_unificado,
		S.sequni        AS seqipc,
		S.vlrliq,   
		S.Ori_Transacao,
        S.qtdrec,
        S.datemi,
		S.numprj,
		S.coddep, 
		S.dt_carga      AS S_dt_carga,
		S.dt_carga      AS I_dt_carga,
		I.cplpro,  
		I.nopope,  												                                                                                                                                                                         						                
		I.qtdent,	                                                                        
		I.unimed,                                                                           
		I.preuni,                                                                       
		I.vlrctb,                                                                           
		I.codedc,                                                                                                                                                                                                                           
		I.bascre,                                                                           
		I.clafis,
		I.vlrisc,
		S.codstr 	    AS codstr,
		S.cstpis        AS cstpis,
		S.cstcof        AS cstcof,
		S.cstipi        AS cstipi,	
		S.pericm        AS pericm,
		S.perpir        AS perpir,
		S.percor        AS percor,	
		S.peripi        AS peripi,
		S.vlricm        AS vlricm,
		S.vlrpis,
		S.vlrcor		AS vlrcor,
		S.vlrbcr        AS vlrbcr,
		S.vlrbic		AS vlrbic,
		S.vlrout,
		S.vlrour 		AS vlrour,
		S.vlroic  		AS vlroic,
		S.cprtcf,
		I.vlrbip,
		I.vlripi,
		I.vlrmrc,
		S.vlrbpi		AS vlrbpr,
		S.vlrpis		AS vlrpir,
		I.periss,
		I.vlrbis,
		I.vlriss,
		I.perirf,
		I.vlrbir,
		I.vlrirf,
		I.perins,
		I.vlrbin,
		I.vlrins,
		I.perour,
		I.vlrbor,
		I.vlriip,
		I.vlroip,
		I.vlripn,
		I.vlriic,
		I.vlrdsc,
		I.vlrcip,
		I.vlriop,
		I.vlrbid,
		I.vlripd,
		I.datger,
		I.raides,
		I.rairem,
        C1.sigufs       AS ufsdes,
        C2.sigufs       AS ufsrem,
		CCH.confin,
		PP.prebas,
		S.numocp,
		CO.obsocp
    FROM  suprimento_entrada    S
	LEFT JOIN imposto_entrada 	I
		ON	I.codemp = S.codemp
		AND	I.codfil = S.codfil
		AND I.codfor = S.codfor
		AND I.numnfi = S.numnfc
		AND I.codsnf = S.codsnf
		AND I.cod_unificado = S.coduni
		AND I.seqipc = S.sequni 
    LEFT JOIN cep C1
    	ON  C1.codrai = I.raides
    LEFT JOIN cep C2
    	ON  C2.codrai = I.rairem
	LEFT JOIN cadastro_cliente_historico CCH
		ON  CCH.codemp = I.codemp
		AND CCH.codfil = I.codfil
		AND CCH.codcli = I.codfor 
	LEFT JOIN preco_pauta PP	
		ON  PP.codemp = I.codemp 
		AND PP.codpro = I.cod_unificado
	LEFT JOIN source_compra_ordem_dado_geral CO
		ON  CO.codemp = S.codemp
		AND CO.codfil = S.codfil
		AND CO.numocp = S.numocp
	
	WHERE   S.datent >= '20250101' 
		AND S.codsnf in ('NDB','REC')
),

consolidado AS (
    SELECT *
    FROM imposto_suprimento_entrada_I

    UNION ALL

    SELECT * 
    FROM imposto_suprimento_entrada_S
)
	
SELECT * 
FROM consolidado
	
WHERE numnfi is not null