
--------Consulta de Atendimentos/Agendamentos - Utilizada no painel HPC-CLINICA-Consultas e Exames--------
/*      O cógido retorna os campos em comum da tabela de AGENDAMENTOS e a tabela de ATENDIMENTOS.
 *  Devido a falta de padronização do processo de confirmação dos pacientes agendados dentro da clínica, 
 * essa consulta funciona como uma alternativa informal para o painel.    */

SELECT 
    'Realizado' CONDICAO
    ,a.cd_atendimento cod_contador
    ,INITCAP(nm_paciente) nm_paciente
    ,a.dt_atendimento dt_atendimento
    ,a.hr_atendimento hr_atendimento
    ,c.nm_convenio
    ,INITCAP(pr.nm_prestador) nm_prestador
    ,INITCAP(tm.ds_tip_mar) ds_tip_mar
    ,pf.ds_pro_fat descricao
    ,'INVÁLIDO' SITUACAO
FROM atendime a
LEFT JOIN
    paciente p ON p.cd_paciente = a.cd_paciente
LEFT JOIN
    convenio c ON c.cd_convenio = a.cd_convenio
LEFT JOIN
    prestador pr ON pr.cd_prestador = a.cd_prestador
LEFT JOIN
    pro_fat pf ON pf.cd_pro_fat = a.cd_pro_int
LEFT JOIN
    tip_mar tm ON tm.cd_tip_mar = a.cd_tip_mar
LEFT JOIN
    ori_ate oa ON oa.cd_ori_ate = a.cd_ori_ate
WHERE oa.cd_ori_ate = 2
AND a.cd_tip_mar IS NOT NULL
UNION ALL
SELECT
    'Agendado' CONDICAO
    ,i.cd_it_agenda_central cod_contador
    ,INITCAP(i.nm_paciente) nm_paciente
    ,MIN(i.hr_agenda) dt_atendimento
    ,MIN(i.hr_agenda) hr_agenda
    ,c.nm_convenio
    ,INITCAP(pr.nm_prestador) nm_prestador
    ,INITCAP(t.ds_tip_mar) ds_tip_mar
    ,ia.ds_item_agendamento descricao
    ,DECODE(i.sn_atendido,'S', 'Atendido','N', 'Não Atendido') SITUACAO
FROM 
    it_agenda_central i
LEFT JOIN 
    agenda_central a ON i.cd_agenda_central = a.cd_agenda_central
LEFT JOIN 
    item_agendamento ia ON ia.cd_item_agendamento = i.cd_item_agendamento
LEFT JOIN 
    setor s ON s.cd_setor = a.cd_setor 
LEFT JOIN 
    prestador pr ON pr.cd_prestador = a.cd_prestador
LEFT JOIN 
    convenio c ON c.cd_convenio = i.cd_convenio
LEFT JOIN 
    tip_mar t ON t.cd_tip_mar = i.cd_tip_mar
LEFT JOIN 
    pro_fat pf ON pf.cd_pro_fat = i.cd_tip_mar
WHERE 
    i.nm_paciente IS NOT NULL
    AND i.cd_tip_mar IS NOT NULL
GROUP BY 
    i.nm_paciente
    ,ia.ds_item_agendamento
    ,i.cd_agenda_central
    ,i.cd_it_agenda_central
    ,i.cd_atendimento
    ,a.tp_agenda
    ,nm_convenio
    ,ia.ds_item_agendamento
    ,i.sn_atendido
    ,i.ds_observacao_geral
    ,pr.nm_prestador
    ,s.nm_setor
    ,t.ds_tip_mar


    
/* -------------------------------------------------------------------------------------------------------------- */
    

SELECT
	*
FROM
	dbamv.escala_central ec
WHERE
	ec.CD_PRESTADOR = '366';
	AND ec.hr_inicio BETWEEN TO_DATE('2024-07-01', 'YYYY-MM-DD') AND TO_DATE('2024-07-31', 'YYYY-MM-DD');
	




/* -------------------------------------------------------------------------------------------------------------- */
/* -------------------------------- VALIDAÇÃO DE AGENDAMENTOS - 06/20024 ----------------------------------------*/
	-- FORAM IDENTIFICADAS 9 DIFERENÇAS RELACIONADAS ÀS AGENDAS '17803','17828','17806'
	-- ESSAS AGENDAS FORAM GRANULADAS EM RELAÇÃO AOS CD_IT_AGENDA_PAI
	-- PORÉM PARA A CONSULTA SÃO IRRELEVANTES

/* ----------------------------- VALIDAÇÃO DE AGENDAMENTOS - 01/2023 A 01/2024 ----------------------------------*/
   -- APÓS A REPLICAÇÃO DA SOLUÇÃO DO PROBLEMA IDENTIFICADO NO PERÍODO 06/2024
   -- FORAM IDENTIFICADAS 3 DIFERENÇAS, UMA EM CADA UM DOS PERÍODOS 02/24 , 05/24 e 01/23

SELECT * FROM DBAMV.AGENDA_CENTRAL a WHERE a.CD_AGENDA_CENTRAL='17828';

SELECT * FROM DBAMV.IT_AGENDA_CENTRAL i WHERE /*i.CD_AGENDA_CENTRAL='17828' AND*/ i.cd_atendimento='129952';

SELECT DISTINCT
	i.CD_AGENDA_CENTRAL ,
	i.CD_IT_AGENDA_CENTRAL,
	i.CD_IT_AGENDA_PAI,
	i.CD_ATENDIMENTO,
	i.CD_PACIENTE,
	i.NM_PACIENTE,
	ia.DS_ITEM_AGENDAMENTO ,
	i.HR_AGENDA,
	i.HR_FIM
FROM
	DBAMV.IT_AGENDA_CENTRAL i
LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 
	ON i.CD_ITEM_AGENDAMENTO = ia.CD_ITEM_AGENDAMENTO
WHERE i.CD_AGENDA_CENTRAL IN('17803','17828','17806') AND i.cd_atendimento IN('124391','127211','129952') 
ORDER BY i.CD_IT_AGENDA_CENTRAL, i.CD_IT_AGENDA_PAI ;




-- ************************************************************************************************************************************************************* --
-- ************************************************* CD_IT_AGENDA_PAI [BASE AGENDADOS] ************************************************************************* --
SELECT DISTINCT
	i.CD_AGENDA_CENTRAL ,
	i.CD_IT_AGENDA_CENTRAL,
	i.CD_IT_AGENDA_PAI,
	i.CD_ATENDIMENTO,
	i.CD_PACIENTE,
	i.NM_PACIENTE,
	ia.CD_ITEM_AGENDAMENTO,
	ia.DS_ITEM_AGENDAMENTO ,
	i.HR_AGENDA,
	i.HR_FIM
FROM
	DBAMV.IT_AGENDA_CENTRAL i
LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 
	ON i.CD_ITEM_AGENDAMENTO = ia.CD_ITEM_AGENDAMENTO
WHERE 
/*	i.CD_IT_AGENDA_PAI  IS NOT NULL AND
	i.CD_ATENDIMENTO IS NOT NULL AND*/
	TO_CHAR(i.HR_AGENDA, 'MM/YYYY')='01/2024' AND
--	i.CD_IT_AGENDA_PAI  IN('486451','515627','535684') AND --IN('396391','395950','396425','403013','402836','395922') AND -- 01.2024 
	i.cd_atendimento IN('93560','94909','92232','93687','94986') -- 01.2024 -- IN('135646', '131505','138361') --07.2024 
ORDER BY i.CD_IT_AGENDA_CENTRAL, i.CD_IT_AGENDA_PAI ;

/* -------------------------------------------------------------------------------------------------------------- */





/* -------------------------------------------------------------------------------------------------------------- */
/* --------------------------- CONSULTA CARREGADA NO PAINEL HPC-CLINICA-Agendamentos ---------------------------- */
	-- QUERY AGENDAMENTO - AJUSTADA P/ RETIRAR cd_it_agenda_pai is null QUE GRANULA A CONSULTA E GERA DIFERENÇAS
	-- ESSA QUERY FOI VALIDADA COM O RELATÓRIO MV R_PAC_AGENDADOS_DATA

	-- QUERY ATENDIMENTO - VALIDAÇÃO DA LÓGICA IMPLEMENTADA PELA TRIGGER TRG_LOG_CONSULTA_SIDRA
	-- BASICAMENTE A TRIGGER ...

WITH cardio_agend3 AS (
SELECT 
   i.cd_agenda_central,
   DECODE(a.TP_AGENDA,'L','LABORATORIO','I', 'IMAGEM','A', 'AMBULATORIO' ) AS TIPO_AGENDA,
   i.hr_agenda,
   i.cd_atendimento,
   i.cd_paciente,
   i.nm_paciente,
   i.dt_nascimento,
   i.cd_convenio,
   c.nm_convenio,
   i.cd_item_agendamento,
   ia.ds_item_agendamento,
   CASE 
   		WHEN i.cd_atendimento IS NULL THEN
   			'AGENDADO NAO ATENDIDO'
   		ELSE 
   			'AGENDADO ATENDIDO'
   END AS STATUS_ATENDIMENTO,
   i.dt_gravacao,
   i.ds_observacao_geral,
   i.dh_presenca_falta,
   a.cd_recurso_central,
   r.ds_recurso_central,
   a.cd_prestador,
   pr.nm_prestador,
   a.cd_setor,
   s.nm_setor,
   a.qt_atendimento,
   a.qt_marcados,
   i.cd_usuario,
   u.nm_usuario,
   i.cd_tip_mar,
   tr.ds_tip_mar,
   CASE a.tp_agenda 
   		WHEN 'A' THEN 'Consulta'
   		WHEN 'L' THEN 'Exame Lab.'
   		WHEN 'I' THEN 'Exame Ima.'
   		ELSE 'Sem Correspondência'
   END AS tp_atendimento
FROM DBAMV.IT_AGENDA_CENTRAL i
LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
WHERE i.cd_atendimento  IS NOT NULL AND i.cd_it_agenda_pai IS NULL
UNION ALL
SELECT
   CAST('0' AS NUMBER(8,0)) AS cd_agenda_central,
   CAST('SEM' AS VARCHAR2(3)) AS TIPO_AGENDA,
   a.dt_atendimento AS hr_agenda,
   a.cd_atendimento,
   a.cd_paciente,
   pa.nm_paciente,
   pa.dt_nascimento,
   c.cd_convenio,
   c.nm_convenio,
   CAST('0' AS NUMBER(9,0)) AS cd_item_agendamento,
   ia.ds_especialid AS ds_item_agendamento,
   'ATENDIDO NAO AGENDADO' AS STATUS_ATENDIMENTO,
   a.hr_atendimento AS dt_gravacao,
   CAST('SEM' AS VARCHAR2(600)) AS ds_observacao_geral,
   CAST('' AS DATE) AS dh_presenca_falta,
   CAST('0' AS NUMBER(6,0)) AS cd_recurso_central,
   CAST('SEM' AS VARCHAR2(30)) AS ds_recurso_central,
   a.cd_prestador,
   p.nm_prestador,
   S.cd_ori_ate cd_setor,
   s.ds_ori_ate nm_setor,
   CAST('0' AS NUMBER(3,0)) AS qt_atendimento,
   CAST('0' AS NUMBER(3,0)) AS qt_marcados,
   CAST('SEM' AS VARCHAR2(30)) AS cd_usuario,
   CAST('SEM' AS VARCHAR2(30)) AS nm_usuario,
   CAST('0' AS NUMBER(4,0)) AS cd_tip_mar,
   t.ds_tip_mar,
   CASE a.tp_atendimento 
   		WHEN 'A' THEN 'Consulta'
   		WHEN 'E' THEN 'Exame'
   		WHEN 'U' THEN 'Urgência/Emergência'
   		WHEN 'I' THEN 'Internação'
   		ELSE 'Sem Correspondência'
   END AS tp_atendimento
FROM DBAMV.ATENDIME a
LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR 
LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
WHERE
	NOT EXISTS (
				 SELECT 1 FROM IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento
					)
)
SELECT
	COUNT(*) AS QTD
FROM
	cardio_agend3
WHERE 
TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024' AND tp_atendimento = 'Consulta';
GROUP BY STATUS_ATENDIMENTO;
--hr_agenda BETWEEN  TO_DATE('2024-06-01', 'YYYY-MM-DD') AND TO_DATE('2024-06-30', 'YYYY-MM-DD');


/* -------------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */




WITH TESTE AS (
		SELECT
		   CAST('0' AS NUMBER(8,0)) AS cd_agenda_central,
		   CAST('SEM' AS VARCHAR2(3)) AS TIPO_AGENDA,
		   a.dt_atendimento AS hr_agenda,
		   a.cd_atendimento,
		   a.cd_paciente,
		   pa.nm_paciente,
		   pa.dt_nascimento,
		   c.cd_convenio,
		   c.nm_convenio,
		   CAST('0' AS NUMBER(9,0)) AS cd_item_agendamento,
		   ia.ds_especialid AS ds_item_agendamento,
		   'ATENDIDO NAO AGENDADO' AS STATUS_ATENDIMENTO,
		   a.hr_atendimento AS dt_gravacao,
		   CAST('SEM' AS VARCHAR2(600)) AS ds_observacao_geral,
		   CAST('' AS DATE) AS dh_presenca_falta,
		   CAST('0' AS NUMBER(6,0)) AS cd_recurso_central,
		   CAST('SEM' AS VARCHAR2(30)) AS ds_recurso_central,
		   a.cd_prestador,
		   p.nm_prestador,
		   S.cd_ori_ate cd_setor,
		   s.ds_ori_ate nm_setor,
		   CAST('0' AS NUMBER(3,0)) AS qt_atendimento,
		   CAST('0' AS NUMBER(3,0)) AS qt_marcados,
		   CAST('SEM' AS VARCHAR2(30)) AS cd_usuario,
		   CAST('SEM' AS VARCHAR2(30)) AS nm_usuario,
		   CAST('0' AS NUMBER(4,0)) AS cd_tip_mar,
		   t.ds_tip_mar,
		   CASE a.tp_atendimento 
		   		WHEN 'A' THEN 'Consulta'
		   		WHEN 'E' THEN 'Exame'
		   		WHEN 'U' THEN 'Urgência/Emergência'
		   		WHEN 'I' THEN 'Internação'
		   		ELSE 'Sem Correspondência'
		   END AS tp_atendimento
		FROM DBAMV.ATENDIME a
		LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
		LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR 
		LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
		LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
		LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
		LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
		WHERE TO_CHAR(a.dt_atendimento, 'MM/YYYY')='01/2024' /* AND EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )*/ 
		UNION ALL
		SELECT DISTINCT
		   i.cd_agenda_central,
		   DECODE(a.TP_AGENDA,'L','LABORATORIO','I', 'IMAGEM','A', 'AMBULATORIO' ) AS TIPO_AGENDA,
		   i.hr_agenda,
		   i.cd_atendimento,
		   i.cd_paciente,
		   i.nm_paciente,
		   i.dt_nascimento,
		   i.cd_convenio,
		   c.nm_convenio,
		   i.cd_item_agendamento,
		   ia.ds_item_agendamento,
		   CASE 
		   		WHEN i.cd_atendimento IS NULL AND i.nm_paciente IS NOT NULL THEN
		   			'AGENDADO NAO ATENDIDO - ABSENTEISMO'
		   		WHEN i.cd_atendimento IS NOT NULL THEN
		   			'AGENDADO ATENDIDO'
		   		ELSE 'AGENDADO NAO ATENDIDO - CANCELADOS'
		   END AS STATUS_ATENDIMENTO,
		   i.dt_gravacao,
		   i.ds_observacao_geral,
		   i.dh_presenca_falta,
		   a.cd_recurso_central,
		   r.ds_recurso_central,
		   a.cd_prestador,
		   pr.nm_prestador,
		   a.cd_setor,
		   s.nm_setor,
		   a.qt_atendimento,
		   a.qt_marcados,
		   i.cd_usuario,
		   u.nm_usuario,
		   i.cd_tip_mar,
		   tr.ds_tip_mar,
		   CASE a.tp_agenda 
		   		WHEN 'A' THEN 'Consulta'
		   		WHEN 'L' THEN 'Exame Lab.'
		   		WHEN 'I' THEN 'Exame Ima.'
		   		ELSE 'Sem Correspondência'
		   END AS tp_atendimento
		FROM DBAMV.IT_AGENDA_CENTRAL i
		LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
		LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
		LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
		LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
		LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
		LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
		LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
		LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
		WHERE i.cd_atendimento  IS NOT NULL AND i.cd_it_agenda_pai IS NULL AND
		EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento )
		AND TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024'
)
SELECT
/*	tp_atendimento,
	STATUS_ATENDIMENTO,*/
	COUNT(*) AS QTD
FROM
	TESTE ;
WHERE 
TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024';
GROUP BY tp_atendimento, STATUS_ATENDIMENTO;
/*SELECT
	STATUS_ATENDIMENTO,
	COUNT(*) AS QTD
FROM
	TESTE
WHERE 
TO_CHAR(hr_agenda, 'MM/YYYY')='06/2024'
GROUP BY STATUS_ATENDIMENTO;*/




SELECT * FROM DBAMV.ATENDIME a WHERE a.CD_PACIENTE = '73923';

SELECT * FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE iac.CD_PACIENTE = '73923' /*iac.CD_ATENDIMENTO = '131318'*/;

WITH valid AS (
	-- 5.573
	SELECT
		a.*
	FROM
		DBAMV.ATENDIME a
	WHERE
		a.TP_ATENDIMENTO IN('A') /*AND a.HR_AGENDA IS NULL*/ AND TO_CHAR(a.HR_ATENDIMENTO , 'MM/YYYY')= '01/2024'
UNION ALL 
	-- 1.268
	SELECT
		a.*
	FROM
		DBAMV.ATENDIME a
	WHERE
		NOT EXISTS ( SELECT 1 FROM IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
		AND TO_CHAR(a.HR_ATENDIMENTO , 'MM/YYYY')='06/2024' AND a.TP_ATENDIMENTO IN('A', 'E')
)
SELECT COUNT(*) FROM valid; -- MINUS 4305 / INTER 1.268



/* -------------------------------------------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------------------------------------------- */




/* -------------------------------------------------------------------------------------------------------------- */


WITH DETALHAMENTO_EXAMES AS (
		SELECT
			a.CD_ATENDIMENTO,
			pa.CD_PACIENTE ,
			pa.NM_PACIENTE ,
			p.CD_PRESTADOR ,
			p.NM_PRESTADOR ,
			pr.CD_PRE_MED ,
			pr.DT_PRE_MED AS DT_PEDIDO,
			tip.CD_TIP_ESQ AS EXAME
		FROM
			dbamv.itpre_med itp
		LEFT JOIN dbamv.pre_med pr
			ON itp.cd_pre_med = pr.cd_pre_med
		LEFT JOIN dbamv.tip_esq tip
			ON tip.CD_TIP_ESQ = itp.CD_TIP_ESQ 
		LEFT JOIN dbamv.atendime a
			ON a.cd_atendimento = pr.cd_atendimento
		LEFT JOIN dbamv.prestador p
			ON p.cd_prestador = pr.cd_prestador
		LEFT JOIN dbamv.paciente pa
			ON pa.cd_paciente = a.cd_paciente
		WHERE a.TP_ATENDIMENTO IN('A') /*AND TO_CHAR(a.DT_ATENDIMENTO, 'YYYY-MM-DD') = '2024-07-16' AND p.CD_PRESTADOR='277' AND a.CD_ATENDIMENTO ='135683'*/ 
)
SELECT
	EXAME, COUNT(*)
FROM
	DETALHAMENTO_EXAMES
WHERE
	TO_CHAR(DT_PEDIDO,
	'MM/YYYY') = '06/2024'
GROUP BY EXAME;




-- IPM
WITH consulta2 AS (
    SELECT Ate.Cd_Atendimento,
           Ate.Dt_Atendimento,
           Ate.Hr_Atendimento,
           Pac.Cd_Paciente,
           Pac.Nm_Paciente,
           NVL(NVL(Pmd.Cd_Pre_Med, Cvt.Cd_Coleta_Sinal_Vital), Pec.Cd_Documento) Cd_Documento,
           Pec.cd_editor_registro Cd_Registro,
           Ptd.Cd_Tipo_Documento,
           UPPER(Ptd.Ds_Tipo_Documento) Ds_Tipo_Documento,
           NVL(Doc.Ds_Documento, Obj.Nm_Objeto) Ds_Documento,
           Pdc.Tp_Status,
           EcB.Cd_Campo Cd_Campo_Pai,
           EcB.Ds_Campo Ds_Campo_Pai,
           EcB.Ds_Identificador Ds_Identificador_Pai,
           EcA.Cd_Campo Cd_Campo_Filho,
           EcA.Ds_Campo Ds_Campo_Filho,
           EcA.Ds_Identificador Ds_Identificador_Filho,
           Pdc.Dh_Documento,
           Pdc.Dh_Criacao,
           DECODE(Pec.Cd_Documento, NULL, Pdc.Dh_Documento, Pdc.Dh_Fechamento) Dh_Fechamento,
           DECODE(Pec.Cd_Documento, NULL, Pdc.Dh_Documento, Pdc.Dh_Impresso) Dh_Impresso,
           Pdc.Cd_Objeto,
           Pdc.Cd_Usuario Cd_Usuario_Criou,
           Pdc.Cd_Prestador Cd_Prestador_Criou,
           (SELECT Und.Ds_Unid_Int
              FROM Dbamv.Unid_Int Und,
                   Dbamv.Leito Lei
             WHERE Und.Cd_Unid_Int = Lei.Cd_Unid_Int
               AND Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(Ate.Cd_Atendimento, NVL(Pdc.Dh_Referencia, Pdc.Dh_Criacao))) Ds_Unidade_Internacao,
           (SELECT Str.Nm_Setor
              FROM Dbamv.Unid_Int Und,
                   Dbamv.Leito Lei,
                   Dbamv.Setor Str
             WHERE Und.Cd_Unid_Int = Lei.Cd_Unid_Int
               AND Und.Cd_Setor = Str.Cd_Setor
               AND Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(Ate.Cd_Atendimento, NVL(Pdc.Dh_Referencia, Pdc.Dh_Criacao))) Ds_Setor_Documento,
           (SELECT Lei.Ds_Leito
              FROM Dbamv.Leito Lei
             WHERE Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(Ate.Cd_Atendimento, NVL(Pdc.Dh_Referencia, Pdc.Dh_Criacao))) ds_leito,
           (SELECT Lei.Ds_Resumo
              FROM Dbamv.Leito Lei
             WHERE Lei.Cd_leito = Dbamv.Fnc_Leito_Atendimento(Ate.Cd_Atendimento, NVL(Pdc.Dh_Referencia, Pdc.Dh_Criacao))) ds_resumo_leito,
           (SELECT MAX(Itpre_Med.Cd_Itpre_Med)
              FROM Dbamv.Itpre_Med,
                   Dbamv.Pre_Med,
                   Dbamv.Itpre_Pad
             WHERE Itpre_Med.Cd_Pre_Med = Pre_Med.Cd_Pre_Med
               AND Itpre_Med.Cd_Itpre_Pad = Itpre_Pad.Cd_Itpre_Pad
               AND TO_CHAR(Itpre_Pad.Cd_Pre_Pad) = DBMS_LOB.SUBSTR(Erc.Lo_Valor, 4000, 1)
               AND TRUNC(Pre_Med.Hr_Pre_Med) = TRUNC(Pdc.Dh_Documento)
               AND Pre_Med.Cd_Atendimento = Ate.Cd_AtendimentO) Cd_ItPre_Med,
           DBMS_LOB.SUBSTR(Erc.Lo_Valor, 4000, 1) Ds_Resposta,
 		   Pres.Cd_prestador,
 		   Pres.Nm_prestador
      FROM Dbamv.Pw_Documento_Clinico Pdc,
           Dbamv.Pw_Editor_Clinico Pec,
           Dbamv.Pw_Tipo_Documento Ptd,
           Dbamv.Pre_Med Pmd,
           Dbamv.Coleta_Sinal_Vital Cvt,
           Dbamv.Pagu_Objeto Obj,
           Dbamv.Editor_Registro_Campo Erc,
           Dbamv.Editor_Registro Erg,
           Dbamv.Editor_Documento Doc,
           Dbamv.Editor_Versao_Documento Evs,
           Dbamv.Editor_Tipo_Versao Etv,
           Dbamv.Editor_Campo EcA,
           Dbamv.Editor_Tipo_Visualizacao Etv,
           Dbamv.Editor_Campo EcB,
           Dbamv.Editor_Grupo_Campo Egc,
           Dbamv.Editor_Grupo Egr,
           Dbamv.Atendime Ate,
           Dbamv.Paciente Pac,
           Dbamv.Prestador Pres
     WHERE Pec.Cd_Documento_Clinico(+) = Pdc.Cd_Documento_Clinico
       AND Pdc.Cd_Tipo_Documento = Ptd.Cd_Tipo_Documento
       AND Pdc.Cd_Documento_Clinico = Pmd.Cd_Documento_Clinico(+)
       AND Pdc.Cd_Documento_Clinico = Cvt.Cd_Documento_Clinico(+)
       AND Pdc.Cd_Objeto(+) = Obj.Cd_Objeto
       AND Erc.Cd_Registro(+) = Pec.Cd_Editor_Registro
       AND Erg.Cd_Registro(+) = Erc.Cd_Registro
       AND Pec.Cd_Documento = Doc.Cd_Documento(+)
       AND Doc.Cd_Documento = Evs.Cd_Documento(+)
       AND Evs.Cd_Tipo_Versao(+) = 3 --Versão Atual (Não remova este filtro)
       AND Evs.Cd_Tipo_Versao = Etv.Cd_Tipo_Versao(+)
       AND EcA.Cd_Campo(+) = Erc.Cd_campo
       AND EcA.Cd_Tipo_Visualizacao = Etv.Cd_Tipo_Visualizacao(+)
       AND EcA.Cd_Metadado = EcB.Cd_Campo(+)
       AND Egc.Cd_Campo(+) = EcB.cd_Campo
       AND Egc.Cd_Grupo = Egr.Cd_Grupo(+)
       AND Pdc.Cd_Atendimento = Ate.Cd_Atendimento
       AND Ate.Cd_Paciente = Pac.Cd_Paciente
       AND Pres.cd_prestador = Pdc.cd_prestador
       AND Ptd.Cd_Tipo_Documento NOT IN (36, 44)
       /*AND Ate.cd_atendimento = '135683'*/
       AND Doc.cd_documento IN('978', '975')
       AND DBMS_LOB.SUBSTR(Erc.Lo_Valor, 4000, 1) IS NOT NULL
       AND EcA.Ds_Campo LIKE '%Nome do Procedimento%'
)
SELECT 
   Cd_Atendimento,
   Cd_Paciente,
   Nm_Paciente,
   Cd_prestador,
   Nm_prestador,
   Cd_ItPre_Med AS CD_PRE_MED,
   Dh_Documento AS DT_PEDIDO,
   TRIM(REGEXP_SUBSTR(Ds_Resposta, '[^,]+', 1, LEVEL)) AS EXAME
FROM consulta2
WHERE TRIM(REGEXP_SUBSTR(Ds_Resposta, '[^,]+', 1, LEVEL)) IS NOT NULL AND TO_CHAR(Dh_Documento, 'YYYY-MM-DD') = '2024-07-16'
CONNECT BY PRIOR cd_campo_pai = cd_campo_pai
       AND PRIOR SYS_GUID() IS NOT NULL
       AND LEVEL <= LENGTH(Ds_Resposta) - LENGTH(REPLACE(Ds_Resposta, ',', '')) + 1 ;





/* -------------------------------------------------------------------------------------------------------------- */

SELECT * FROM dbamv.ped_lab pl;



WITH exa_lab AS (
    SELECT
        o.DS_ORI_ATE,
        p.CD_PACIENTE,
        p.NM_PACIENTE,
        pl.DT_PEDIDO,
        TO_CHAR(pl.DT_EXAME, 'YYYY-MM-dd') AS DT_EXAME,
        TO_CHAR(pl.DT_EXAME, 'MM/YYYY') AS COMP,
        pl.CD_ATENDIMENTO
    FROM
        dbamv.ped_lab pl
    LEFT JOIN dbamv.atendime a
        ON pl.cd_atendimento = a.cd_atendimento
    LEFT JOIN dbamv.ori_ate o
        ON a.cd_ori_ate = o.cd_ori_ate
    LEFT JOIN dbamv.paciente p
        ON a.cd_prestador = p.cd_paciente
)
SELECT
	exa_lab.*
FROM
    exa_lab
WHERE
    TO_DATE(COMP, 'MM/YYYY') BETWEEN TO_DATE('01/2024', 'MM/YYYY') AND TO_DATE('08/2024', 'MM/YYYY')
    AND DS_ORI_ATE LIKE '%2%' ;
GROUP BY
    DT_EXAME,
    DS_ORI_ATE
ORDER BY
    DT_EXAME,
    DS_ORI_ATE;

 

/* -------------------------------------------------------------------------------------------------------------- */

WITH INTERNACAO AS (
		SELECT
			a.CD_PRESTADOR ,
			p.NM_PRESTADOR ,
			a.DT_ATENDIMENTO ,
			a.CD_PACIENTE ,
			pa.NM_PACIENTE ,
			a.SN_INTERNADO ,
			(
				SELECT 
					COUNT(*) 
				FROM dbamv.atendime a1 
				WHERE TO_CHAR(a1.DT_ATENDIMENTO, 'MM/YYYY')= '08/2024' AND
					 a1.cd_prestador = a.cd_prestador
				) AS QTD_ATENDIMENTOS
		FROM
			dbamv.atendime a
		LEFT JOIN dbamv.prestador p
			ON a.CD_PRESTADOR = p.CD_PRESTADOR 
		LEFT JOIN dbamv.PACIENTE pa
			ON a.CD_PACIENTE = pa.CD_PACIENTE 
		WHERE
			TO_CHAR(a.DT_ATENDIMENTO, 'MM/YYYY')= '08/2024'
			AND a.SN_INTERNADO = 'S'
)
SELECT
	CD_PRESTADOR,
	NM_PRESTADOR,
	QTD_ATENDIMENTOS,
	COUNT(*) AS QTD
FROM
	INTERNACAO
GROUP BY
	CD_PRESTADOR,
	NM_PRESTADOR,
	QTD_ATENDIMENTOS
ORDER BY
	COUNT(*);



