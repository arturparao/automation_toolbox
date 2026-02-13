SELECT
	OCP.codemp AS Empresa,
	OCP.codfil AS Filial,
	OCP.numocp AS OrdemCompra,
	SOL.numpct AS Processo_Cotacao,
	SOL.codpri AS Prioridade,
	PRI.despri AS Prioridade_Descricao,
	OCP.obsmot AS Motivo,
	IPO.vlrori AS Valor_Original,
	CTL.numcot AS Cotacao,
	SOL.numsol AS Solicitacao,
	OCP.tnspro AS Transacao,
	TNS.destns AS Transacao_Codigo,
	'PRO'	   AS 'PRO/SOL',
	USW.r910usu_nomcom AS Nome_Usuario,
	CONCAT (OCP.codfor,'-',FRN.nomfor) AS Fornecedor_Completo,
	CAST (OCP.datemi AS DATE) AS Emissao,
	CAST (SOL.datapr AS DATE) AS Aprovacao_Solicitacao,
	DATEDIFF (DAY,SOL.datapr,OCP.datemi) AS	Tempo_Processo,
	CASE WHEN OCP.sitocp = 1 THEN 'Aberto Total'
		 WHEN OCP.sitocp = 2 THEN 'Aberto Parcial'
		 WHEN OCP.sitocp = 3 THEN 'Suspenso'
		 WHEN OCP.sitocp = 4 THEN 'Liquido'
		 WHEN OCP.sitocp = 5 THEN 'Cancelado'
		 WHEN OCP.sitocp = 6 THEN 'Aguardando Integração WMS'
		 WHEN OCP.sitocp = 7 THEN 'Em Transmissão'
		 WHEN OCP.sitocp = 8 THEN 'Preparação Análise ou NF'
		 WHEN OCP.sitocp = 9 THEN 'Não Fechado'	
		 END AS Situação_Ordem,
	CASE WHEN SOL.codpri = 1 THEN	'Até 3 Dias'
		 WHEN SOL.codpri = 2 THEN 'Até 7 Dias'
		 WHEN SOL.codpri = 3 THEN 'Até 10 Dias'
		 WHEN SOL.codpri = 4 THEN 'Até 5 Dias'
		 WHEN SOL.codpri = 5 THEN 'Até 5 Dias'
		 ELSE 'Verificar'
		 END AS	Classificacao
FROM e420ocp OCP
LEFT JOIN e420ipo IPO
	ON  IPO.codemp = OCP.codemp
	AND IPO.codfil = OCP.codfil
	AND IPO.numocp = OCP.numocp
LEFT JOIN e410lco LCO
	ON  LCO.codemp = IPO.codemp
	AND LCO.filocp = IPO.codfil
	AND LCO.numocp = IPO.numocp
	AND LCO.seqipo = IPO.seqipo
LEFT JOIN e410cot CTL
	ON  CTL.codemp = LCO.codemp
	AND CTL.numcot = LCO.numcot
	AND CTL.seqcot = LCO.seqcot
LEFT JOIN e405sol SOL
	ON  SOL.codemp = CTL.codemp
	AND SOL.numcot = CTL.numcot
LEFT JOIN e012fam FAM
	ON  FAM.codemp = IPO.codemp
	AND FAM.codfam = IPO.codfam
LEFT JOIN e075pro PRO
	ON  PRO.codemp = IPO.codemp
	AND PRO.codpro = IPO.codpro
LEFT JOIN e095for FRN
	ON  FRN.codfor = OCP.codfor
LEFT JOIN e099usu USU
	ON  USU.codemp = OCP.codemp
	AND USU.codusu = OCP.usuger
	AND USU.codusu = SOL.codusu
	AND USU.codemp = SOL.codemp
LEFT JOIN e044ccu CCU
	ON  CCU.codemp = USU.codemp
	AND CCU.codccu = USU.codccu
LEFT JOIN EW99USU USW
	ON  USW.r999usu_codusu = OCP.usuger
LEFT JOIN e075der DER
	ON  DER.codemp = PRO.codemp
	AND DER.codpro = PRO.codpro
LEFT JOIN e405pri PRI
	ON  PRI.codemp = SOL.codemp
	AND PRI.codpri = SOL.codpri
LEFT JOIN e001tns TNS
	ON  TNS.codemp = OCP.codemp
	AND TNS.codtns = OCP.tnspro

WHERE	IPO.codemp = 1
	AND IPO.codfil = 4
	AND USU.supime = '829'
	AND OCP.sitocp NOT IN ('1','3','5','9')

UNION

SELECT
	OCP.codemp AS Empresa,
	OCP.codfil AS Filial,
	OCP.numocp AS OrdemCompra,
	SOL.numpct AS Processo_Cotacao,
	SOL.codpri AS Prioridade,
	PRI.despri AS Prioridade_Descricao,
	OCP.obsmot AS Motivo,
	ISO.vlrori AS Valor_Original,
	CTO.numcot AS Cotacao,
	SOL.numsol AS Solicitacao,
	OCP.tnsser AS Transacao,
	TNS.destns AS Transacao_codigo,
	'SOL'	   AS 'SER/SOL',
	USW.r910usu_nomcom AS Nome_Usuario,
	CONCAT (OCP.codfor, '-',FRN.nomfor)	AS Fornecedor_Completo,
	CAST (OCP.datemi AS DATE) AS Emissao,
	CAST (SOL.datapr AS DATE) AS Aprovacao_Solicitacao,
	DATEDIFF (DAY,SOL.datapr,OCP.datemi) AS	Tempo_Processo,
	CASE WHEN OCP.sitocp = 1 THEN 'Aberto Total'
		 WHEN OCP.sitocp = 2 THEN 'Aberto Parcial'
		 WHEN OCP.sitocp = 3 THEN 'Suspenso'
		 WHEN OCP.sitocp = 4 THEN 'Liquido'
		 WHEN OCP.sitocp = 5 THEN 'Cancelado'
		 WHEN OCP.sitocp = 6 THEN 'Aguardando Integração WMS'
		 WHEN OCP.sitocp = 7 THEN 'Em Transmissão'
		 WHEN OCP.sitocp = 8 THEN 'Preparação Análise ou NF'
		 WHEN OCP.sitocp = 9 THEN 'Não Fechado'
		 END AS	Situacao_Ordem,
	CASE WHEN SOL.codpri = 1 THEN 'Até 3 Dias'
		 WHEN SOL.codpri = 2 THEN 'Até 7 Dias'
		 WHEN SOL.codpri = 3 THEN 'Até 10 Dias'
		 WHEN SOL.codpri = 4 THEN 'Até 5 Dias'
		 WHEN SOL.codpri = 5 THEN 'Até 5 Dias'
							 ELSE 'Sem Solicitação'
		 END AS	Classificacao
FROM e420ocp OCP
LEFT JOIN e420iso ISO
	ON  ISO.codemp = OCP.codemp
	AND ISO.codfil = OCP.codfil
	AND ISO.numocp = OCP.numocp
LEFT JOIN e410lco LCO
	ON  LCO.codemp = ISO.codemp
	AND LCO.filocp = ISO.codfil
	AND LCO.numocp = ISO.numocp
	AND LCO.seqipo = ISO.seqiso
LEFT JOIN e410cot CTO
	ON  CTO.codemp = LCO.codemp
	AND CTO.numcot = LCO.numcot
	AND CTO.seqcot = LCO.seqcot
LEFT JOIN e405sol SOL
	ON  SOL.codemp = CTO.codemp
	AND SOL.numcot = CTO.numcot
LEFT JOIN e012fam FAM
	ON  FAM.codemp = ISO.codemp
	AND FAM.codfam = ISO.codfam
LEFT JOIN e080ser SER
	ON  SER.codemp = ISO.codemp
	AND SER.codser = ISO.codser
LEFT JOIN e095for FRN
	ON  FRN.codfor = OCP.codfor
LEFT JOIN e099usu USU
	ON  USU.codemp = OCP.codemp
	AND USU.codusu = OCP.usuger
	AND USU.codusu = SOL.codusu
	AND USU.codemp = SOL.codemp
LEFT JOIN e044ccu CCU
	ON  CCU.codemp = USU.codemp
	AND CCU.codccu = USU.codccu
LEFT JOIN EW99USU USW
	ON  USW.r999usu_codusu = OCP.usuger
LEFT JOIN e405pri PRI
	ON  PRI.codemp = SOL.codemp
	AND PRI.codpri = SOL.codpri
LEFT JOIN e001tns TNS
	ON  TNS.codemp = OCP.codemp
	AND TNS.codtns = OCP.tnsser

WHERE	ISO.codemp = 1
	AND ISO.codfil = 4
	AND USU.supime = '829'
	AND OCP.sitocp NOT IN ('1','3','5','9')