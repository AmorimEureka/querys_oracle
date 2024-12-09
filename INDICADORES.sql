/*
 * R_PAC_AGENDADOS_DATA
 * R_LISTA_ATENDE_PERIODO
 * R_PERCENTUAL_ATENDIMENTOS
 */



-- ************************************************************************************************************************************************************* --
-- ************************************************ SOMENTE ATENDIDOS [BASE ATENDIDOS] ************************************************************************* --
SELECT   
	*
FROM DBAMV.ATENDIME a
LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR 
LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
WHERE TO_CHAR(a.dt_atendimento, 'MM/YYYY')='01/2023' AND a.CD_ATENDIMENTO IN('29863') ; 



-- ************************************************************************************************************************************************************* --
-- ************************************************ SOMENTE AGENDADOS [BASE AGENDADOS] ************************************************************************* --
SELECT
   i.CD_ATENDIMENTO,
   i.HR_AGENDA,
   i.DH_PRESENCA_FALTA,
   ROUND(MONTHS_BETWEEN(i.dh_presenca_falta, i.hr_agenda)) AS DIF
FROM DBAMV.IT_AGENDA_CENTRAL i
LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
LEFT JOIN (
	SELECT   
		at.CD_ATENDIMENTO
	FROM DBAMV.ATENDIME at
	LEFT JOIN DBAMV.PACIENTE pa                ON at.cd_paciente         = pa.cd_paciente
	LEFT JOIN DBAMV.PRESTADOR p                ON at.cd_prestador        = p.CD_PRESTADOR 
	LEFT JOIN DBAMV.CONVENIO c                 ON at.cd_convenio         = c.cd_convenio
	LEFT JOIN DBAMV.ORI_ATE s                  ON at.cd_ori_ate          = s.cd_ori_ate
	LEFT JOIN DBAMV.TIP_MAR t                  ON at.cd_tip_mar          = t.cd_tip_mar
	LEFT JOIN DBAMV.ESPECIALID ia              ON at.cd_especialid       = ia.cd_especialid
	WHERE 
		EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE at.cd_atendimento = ate.cd_atendimento )
) aten									   ON i.CD_ATENDIMENTO      = aten.CD_ATENDIMENTO
WHERE 
	TO_CHAR(i.DH_PRESENCA_FALTA, 'MM/YYYY')='08/2024' AND
	i.cd_it_agenda_pai IS NULL AND
	i.cd_atendimento  IS NOT NULL AND
 	EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento ) ;  

SELECT * FROM DBAMV.IT_AGENDA_CENTRAL i WHERE i.CD_AGENDA_CENTRAL = '14070'; i.CD_ATENDIMENTO IN('98300');


WITH quantidade AS (
SELECT DISTINCT 
   i.CD_ATENDIMENTO,
   i.HR_AGENDA,
   i.DH_PRESENCA_FALTA,
   ROUND(MONTHS_BETWEEN(i.dh_presenca_falta, i.hr_agenda)) AS DIF
FROM DBAMV.IT_AGENDA_CENTRAL i
LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
WHERE 
	TO_CHAR(i.DH_PRESENCA_FALTA, 'MM/YYYY')='08/2024' AND
	i.cd_it_agenda_pai IS NULL  
)
SELECT COUNT(*) FROM quantidade ; 







-- ************************************************************************************************************************************************************* --
-- ************************************************ UNIÃO DISTINTOS [BASE ATENDIDOS + BASE AGENDADOS] ********************************************************** --
-- UNION retorna 6.556 ATENDIDOS DISTINTAMENTE PELO CD_ATENDIMENTO
-- 6.555 Atendimento + 1 Atendido Agendado da Base Agendados que NÃO consta no Atendimento Geral de ATENDIME
WITH UNIAO AS (
		-- BASE ATENDIDOS
		SELECT 
		   a.cd_atendimento
		FROM DBAMV.ATENDIME a
		LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
		LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR 
		LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
		LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
		LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
		LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
		WHERE 
			TO_CHAR(a.dt_atendimento, 'MM/YYYY')='08/2024'
		INTERSECT 
		-- BASE AGENDADOS
		SELECT DISTINCT 
		   i.cd_atendimento
		FROM DBAMV.IT_AGENDA_CENTRAL i
		LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
		LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
		LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
		LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
		LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
		LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
		LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
		LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
		WHERE 
			TO_CHAR(i.hr_agenda, 'MM/YYYY')='08/2024' AND 
			i.cd_atendimento  IS NOT NULL AND 
			i.cd_it_agenda_pai IS NULL AND
			EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento ) 
)
SELECT COUNT(*) AS QTD FROM	UNIAO ;

SELECT * FROM DBAMV.ESCALA_CENTRAL ec ;

-- ************************************************************************************************************************************************************* --
-- ********************************************************* BASE AGENDADOS minus BASE ATENDIDOS *************************************************************** --
-- RETURN 1 
WITH AGEND_minus_ATEND AS ( 
		-- BASE AGENDADOS
		SELECT DISTINCT 
		   i.cd_atendimento
		FROM DBAMV.IT_AGENDA_CENTRAL i
		LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
		LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
		LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
		LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
		LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
		LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
		LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
		LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
		WHERE 
			TO_CHAR(i.hr_agenda, 'MM/YYYY')='01/2024' AND 
			i.cd_atendimento  IS NOT NULL AND 
			i.cd_it_agenda_pai IS NULL AND
			EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento )
		MINUS
		-- BASE ATENDIDOS
		SELECT 
		   a.cd_atendimento
		FROM DBAMV.ATENDIME a
		LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
		LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR 
		LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
		LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
		LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
		LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
		WHERE 
			TO_CHAR(a.dt_atendimento, 'MM/YYYY')='01/2024' AND 
			EXISTS( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
) SELECT COUNT(*) FROM AGEND_minus_ATEND ;



-- ************************************************************************************************************************************************************* --
-- ********************************************************* BASE ATENDIDOS minus BASE AGENDADOS *************************************************************** --
-- RETURN 4 -> ATENDIDOS POSSUÍ 4 A MAIS QUE OS DA INTERCESSÃO 3.733
WITH ATEND_minus_AGEND AS (
		-- BASE ATENDIDOS
		SELECT 
		   a.cd_atendimento
		FROM DBAMV.ATENDIME a
		LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
		LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR 
		LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
		LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
		LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
		LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
		WHERE 
			TO_CHAR(a.dt_atendimento, 'MM/YYYY')='08/2024' AND 
			EXISTS( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento ) 
			 --AND a.tp_atendimento IN(/*'A'*/ 'E') -- FILTRO CONSULTA / EXAME
		MINUS
		-- BASE AGENDADOS
		SELECT DISTINCT 
		   i.cd_atendimento
		FROM DBAMV.IT_AGENDA_CENTRAL i
		LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
		LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
		LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
		LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
		LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
		LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
		LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
		LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
		WHERE 
			TO_CHAR(i.hr_agenda, 'MM/YYYY')='08/2024' AND 
			i.cd_atendimento  IS NOT NULL AND
			i.cd_it_agenda_pai IS NULL AND
			EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento )
			 -- AND a.tp_agenda IN(/*'A'*/ 'L','I') -- FILTRO CONSULTA / EXAME		
)
SELECT * FROM ATEND_minus_AGEND ;



-- ************************************************************************************************************************************************************* --
-- *************************************** TOTAL ATENDIDOS - [ BASE ATENDIDOS GRANULADA PELO AGENDAMENTO ] ***************************************************** --
WITH ATEN AS(
	SELECT -- ATENDIDOS AGENDADOS
	   CAST('0' AS NUMBER(8,0)) AS cd_agenda_central,
	   CAST('SEM' AS VARCHAR2(3)) AS TIPO_AGENDA,
	   agen.hr_agenda,
	   a.cd_atendimento,
	   a.cd_paciente,
	   pa.nm_paciente,
	   pa.dt_nascimento,
	   c.cd_convenio,
	   c.nm_convenio,
	   CAST('0' AS NUMBER(9,0)) AS cd_item_agendamento,
	   ia.ds_especialid AS ds_item_agendamento,
	   'ATENDIDO AGENDADO' AS STATUS_ATENDIMENTO,
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
	   agen.nm_exa_lab,
	   agen.ds_exa_rx,
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
	LEFT JOIN (
			SELECT
			   i.cd_atendimento,
			   i.hr_agenda,
		       el.nm_exa_lab,
			   er.ds_exa_rx
			FROM DBAMV.IT_AGENDA_CENTRAL i
			LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
			LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
			LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
			LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
			LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
			LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
			LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
			LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
			LEFT JOIN DBAMV.EXA_LAB el 				   ON ia.CD_EXA_LAB 		= el.CD_EXA_LAB
			LEFT JOIN DBAMV.EXA_RX er 				   ON ia.CD_EXA_RX          = er.CD_EXA_RX
			WHERE 
				i.cd_atendimento  IS NOT NULL AND i.cd_it_agenda_pai IS NULL AND
				EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento )
						) agen 				   ON a.CD_ATENDIMENTO      = agen.CD_ATENDIMENTO
	WHERE 
		EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento ) 
	UNION ALL
	SELECT --ATENDIDOS NÃO AGENDADOS
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
	   'ATENDIDO NÃO AGENDADO' AS STATUS_ATENDIMENTO,
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
	   CAST('SEM' AS VARCHAR2(30)) AS nm_exa_lab,
	   CAST('SEM' AS VARCHAR2(30)) AS ds_exa_rx,
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
		NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
)
SELECT  COUNT(*) FROM ATEN WHERE TO_CHAR(hr_agenda, 'MM/YYYY')='02/2024' ; -- ATENDIDOS TOTAL
SELECT  COUNT(*) FROM ATEN WHERE TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024' AND STATUS_ATENDIMENTO LIKE '%ATENDIDO%' AND tp_atendimento = 'Consulta' ; -- CONSULTAS ATENDIDAS
SELECT  COUNT(*) FROM ATEN WHERE TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024' AND STATUS_ATENDIMENTO LIKE '%ATENDIDO%' AND tp_atendimento = 'Exames' ; -- EXAMES ATENDIDOS





-- ************************************************************************************************************************************************************* --
-- ******************************* ATENDIDOS AGENDADOS [ BASE AGENDA ] X ATENDIDOS AGENDADOS [ BASE ATENDIMENTO - 'GRANULADA' ] ******************************** --
-- BASE AGENDADOS 4.345
SELECT  
   COUNT(*)
FROM DBAMV.IT_AGENDA_CENTRAL i
LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
WHERE 
	TO_CHAR(i.hr_agenda, 'MM/YYYY')='01/2024' AND 
	i.cd_atendimento  IS NOT NULL AND 
	i.cd_it_agenda_pai IS NULL AND
	EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento ) ;



-- BASE ATENDIDOS 4.345
WITH ATEND_AGEND AS (
	SELECT -- ATENDIDOS AGENDADOS
	   CAST('0' AS NUMBER(8,0)) AS cd_agenda_central,
	   CAST('SEM' AS VARCHAR2(3)) AS TIPO_AGENDA,
	   agen.hr_agenda,
	   a.dt_atendimento,
	   a.cd_atendimento,
	   a.cd_paciente,
	   pa.nm_paciente,
	   pa.dt_nascimento,
	   c.cd_convenio,
	   c.nm_convenio,
	   CAST('0' AS NUMBER(9,0)) AS cd_item_agendamento,
	   ia.ds_especialid AS ds_item_agendamento,
	   'ATENDIDO AGENDADO' AS STATUS_ATENDIMENTO,
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
	   agen.nm_exa_lab,
	   agen.ds_exa_rx,
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
		LEFT JOIN (
				SELECT
				   i.cd_atendimento,
				   i.hr_agenda,
			       el.nm_exa_lab,
				   er.ds_exa_rx
				FROM DBAMV.IT_AGENDA_CENTRAL i
				LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
				LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
				LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
				LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
				LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
				LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
				LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
				LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
				LEFT JOIN DBAMV.EXA_LAB el 				   ON ia.CD_EXA_LAB 		= el.CD_EXA_LAB
				LEFT JOIN DBAMV.EXA_RX er 				   ON ia.CD_EXA_RX          = er.CD_EXA_RX
				WHERE 
					i.cd_atendimento  IS NOT NULL AND 
					i.cd_it_agenda_pai IS NULL AND
					EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento )
			) agen 								   ON a.CD_ATENDIMENTO       = agen.CD_ATENDIMENTO
	WHERE 
		EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento ) 
) SELECT COUNT(*) FROM ATEND_AGEND WHERE TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024';



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



-- ************************************************************************************************************************************************************* --
-- ******************************* ATENDIDOS AGENDADOS [ BASE AGENDA ] X ATENDIDOS AGENDADOS [ BASE ATENDIMENTO ] ********************************************** --
WITH CONSULTA_FINAL AS(
	SELECT -- ATENDIDOS AGENDADOS
	   CAST('0' AS NUMBER(8,0)) AS cd_agenda_central,
	   CAST('SEM' AS VARCHAR2(3)) AS TIPO_AGENDA,
	   CAST('1' AS NUMBER(8,0)) AS ACRES,
	   agen.hr_agenda,
	   EXTRACT(MONTH FROM agen.hr_agenda) AS MES,
	   EXTRACT(YEAR FROM agen.hr_agenda) AS ANO,
	   a.cd_atendimento,
	   a.cd_paciente,
	   pa.nm_paciente,
	   pa.dt_nascimento,
	   c.cd_convenio,
	   c.nm_convenio,
	   CAST('0' AS NUMBER(9,0)) AS cd_item_agendamento,
	   ia.ds_especialid AS ds_item_agendamento,
	   'ATENDIDO AGENDADO' AS STATUS_ATENDIMENTO,
--	   'ESCALA' AS FORMA,
	   a.hr_atendimento AS dt_gravacao,
	   CAST('SEM' AS VARCHAR2(600)) AS ds_observacao_geral,
	   CAST('' AS DATE) AS dh_presenca_falta,
	   CAST('0' AS NUMBER(6,0)) AS cd_recurso_central,
	   CAST('SEM' AS VARCHAR2(30)) AS ds_recurso_central,
	   a.cd_prestador,
	   p.nm_prestador,
	   st.cd_setor,
	   st.nm_setor,
	   CASE
	   		WHEN st.nm_setor LIKE '%2%' AND st.nm_setor NOT IN('POSTO 2', 'UTI 2') AND TRUNC(agen.hr_agenda) >= TRUNC(st.dt_inclusao) THEN
	   			'CLINICA 2'
	 		ELSE
	 			'CLINICA 1'
	   END AS CLINICAS,
/*	   CASE
	   		WHEN s.ds_ori_ate LIKE '%2%'THEN
	   			'CLINICA 2'
	   		WHEN s.ds_ori_ate LIKE '%RECEPCAO CLINICA%' THEN
	   			'CLINICA 1'
	   		ELSE s.ds_ori_ate
	   END AS CLINICAS,*/
	   CAST('0' AS NUMBER(3,0)) AS qt_atendimento,
	   CAST('0' AS NUMBER(3,0)) AS qt_marcados,
	   CAST('SEM' AS VARCHAR2(30)) AS cd_usuario,
	   CAST('SEM' AS VARCHAR2(30)) AS nm_usuario,
	   CAST('0' AS NUMBER(4,0)) AS cd_tip_mar,
	   t.ds_tip_mar,
	   agen.nm_exa_lab,
	   agen.ds_exa_rx,
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
	LEFT JOIN (
		SELECT
		   i.cd_atendimento,
		   i.hr_agenda,
	       el.nm_exa_lab,
		   er.ds_exa_rx
		FROM DBAMV.IT_AGENDA_CENTRAL i
		LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
		LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
		LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
		LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
		LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
		LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
		LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
		LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
		LEFT JOIN DBAMV.EXA_LAB el 				   ON ia.CD_EXA_LAB 		= el.CD_EXA_LAB
		LEFT JOIN DBAMV.EXA_RX er 				   ON ia.CD_EXA_RX          = er.CD_EXA_RX
		WHERE i.cd_atendimento  IS NOT NULL AND i.cd_it_agenda_pai IS NULL AND
		EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE i.cd_atendimento = ate.cd_atendimento )
	) agen                                     ON a.CD_ATENDIMENTO      = agen.CD_ATENDIMENTO
	LEFT JOIN DBAMV.SETOR st				   ON s.CD_SETOR            =   st.CD_SETOR
	WHERE
		EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
	UNION ALL
	SELECT --ATENDIDOS NÃO AGENDADOS
	   CAST('0' AS NUMBER(8,0)) AS cd_agenda_central,
	   CAST('SEM' AS VARCHAR2(3)) AS TIPO_AGENDA,
	   CAST('1' AS NUMBER(8,0)) AS ACRES,
	   a.dt_atendimento AS hr_agenda,
	   EXTRACT(MONTH FROM a.dt_atendimento) AS MES,
	   EXTRACT(YEAR FROM a.dt_atendimento) AS ANO,
	   a.cd_atendimento,
	   a.cd_paciente,
	   pa.nm_paciente,
	   pa.dt_nascimento,
	   c.cd_convenio,
	   c.nm_convenio,
	   CAST('0' AS NUMBER(9,0)) AS cd_item_agendamento,
	   ia.ds_especialid AS ds_item_agendamento,
	   'ATENDIDO NÃO AGENDADO' AS STATUS_ATENDIMENTO,
--	   'ATENDIDO' AS FORMA,
	   a.hr_atendimento AS dt_gravacao,
	   CAST('SEM' AS VARCHAR2(600)) AS ds_observacao_geral,
	   CAST('' AS DATE) AS dh_presenca_falta,
	   CAST('0' AS NUMBER(6,0)) AS cd_recurso_central,
	   CAST('SEM' AS VARCHAR2(30)) AS ds_recurso_central,
	   a.cd_prestador,
	   p.nm_prestador,
	   st.cd_setor,
	   st.nm_setor,
	   CASE
	   		WHEN st.nm_setor LIKE '%2%' AND st.nm_setor NOT IN('POSTO 2', 'UTI 2') AND TRUNC(a.dt_atendimento) >= TRUNC(st.dt_inclusao) THEN
	   			'CLINICA 2'
	 		ELSE
	 			'CLINICA 1'
	   END AS CLINICAS,
/*	   S.cd_ori_ate cd_setor,
	   s.ds_ori_ate nm_setor,
	   CASE
	   		WHEN s.ds_ori_ate LIKE '%2%'THEN
	   			'CLINICA 2'
	   		WHEN s.ds_ori_ate LIKE '%RECEPCAO CLINICA%' THEN
	   			'CLINICA 1'
	   		ELSE s.ds_ori_ate
	   END AS CLINICAS,*/
	   CAST('0' AS NUMBER(3,0)) AS qt_atendimento,
	   CAST('0' AS NUMBER(3,0)) AS qt_marcados,
	   CAST('SEM' AS VARCHAR2(30)) AS cd_usuario,
	   CAST('SEM' AS VARCHAR2(30)) AS nm_usuario,
	   CAST('0' AS NUMBER(4,0)) AS cd_tip_mar,
	   t.ds_tip_mar,
	   CAST('SEM' AS VARCHAR2(30)) AS nm_exa_lab,
	   CAST('SEM' AS VARCHAR2(30)) AS ds_exa_rx,
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
	LEFT JOIN DBAMV.SETOR st				   ON s.CD_SETOR            = st.CD_SETOR
	WHERE
		NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
	UNION ALL
	SELECT  -- AGENDADOS *REST
	   i.cd_agenda_central,
	   DECODE(a.TP_AGENDA,'L','LABORATORIO','I', 'IMAGEM','A', 'AMBULATORIO' ) AS TIPO_AGENDA,
	   CAST('1' AS NUMBER(8,0)) AS ACRES,
	   i.hr_agenda,
	   EXTRACT(MONTH FROM i.hr_agenda) AS MES,
	   EXTRACT(YEAR FROM i.hr_agenda) AS ANO,
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
	   			'AGENDADO - ABSENTEISMO'
	   		WHEN i.cd_atendimento IS NOT NULL THEN
	   			'AGENDADO ATENDIDO'
	   		ELSE 'ESCALA - OCIOSA'
	   END AS STATUS_ATENDIMENTO,
--	   CASE 
--	   		WHEN i.cd_atendimento IS NULL AND i.nm_paciente IS NOT NULL THEN
--	   			'AGENDADO'
--	   		WHEN i.cd_atendimento IS NOT NULL THEN
--	   			'ATENDIDO'
--	   		ELSE 'ESCALA'
--	   END AS FORMA,
	   i.dt_gravacao,
	   i.ds_observacao_geral,
	   i.dh_presenca_falta,
	   a.cd_recurso_central,
	   r.ds_recurso_central,
	   a.cd_prestador,
	   pr.nm_prestador,
	   s.cd_setor,
	   s.nm_setor,
	   CASE
	   		WHEN s.nm_setor LIKE '%2%' AND s.nm_setor NOT IN('POSTO 2', 'UTI 2') AND TRUNC(i.dh_presenca_falta) >= TRUNC(s.dt_inclusao) THEN
	   			'CLINICA 2'
	 		ELSE
	 			'CLINICA 1'
	   END AS CLINICAS,
/*	   a.cd_setor,
	   s.nm_setor,
	   CASE 
	   		WHEN s.nm_setor LIKE '%2%'THEN
	   			'CLINICA 2'
	   		WHEN s.nm_setor LIKE '%RECEPCAO CLINICA%' THEN
	   			'CLINICA 1'
	   		ELSE s.nm_setor
	   END AS CLINICAS,*/
	   a.qt_atendimento,
	   a.qt_marcados,
	   i.cd_usuario,
	   u.nm_usuario,
	   i.cd_tip_mar,
	   tr.ds_tip_mar,
	   el.nm_exa_lab,
	   er.ds_exa_rx,
	   CASE a.tp_agenda 
	   		WHEN 'A' THEN 'Consulta'
	   		WHEN 'L' THEN 'Exame'
	   		WHEN 'I' THEN 'Exame'
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
	LEFT JOIN DBAMV.EXA_LAB el 				   ON ia.CD_EXA_LAB 		= el.CD_EXA_LAB
	LEFT JOIN DBAMV.EXA_RX er 				   ON ia.CD_EXA_RX          = er.CD_EXA_RX
	WHERE 
		i.cd_atendimento  IS NULL AND
		i.cd_it_agenda_pai IS NULL
	UNION ALL
	SELECT  -- AGENDA REUTILIZADA
	   i.cd_agenda_central,
	   DECODE(a.TP_AGENDA,'L','LABORATORIO','I', 'IMAGEM','A', 'AMBULATORIO' ) AS TIPO_AGENDA,
	   CAST('1' AS NUMBER(8,0)) AS ACRES,
	   i.DH_PRESENCA_FALTA AS hr_agenda,
	   EXTRACT(MONTH FROM i.DH_PRESENCA_FALTA) AS MES,
	   EXTRACT(YEAR FROM i.DH_PRESENCA_FALTA) AS ANO,
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
	   			'AGENDADO - ABSENTEISMO'
	   		WHEN i.cd_atendimento IS NOT NULL THEN
	   			'AGENDADO ATENDIDO'
	   		ELSE 'ESCALA - OCIOSA'
	   END AS STATUS_ATENDIMENTO,
--	   CASE 
--	   		WHEN i.cd_atendimento IS NULL AND i.nm_paciente IS NOT NULL THEN
--	   			'AGENDADO'
--	   		WHEN i.cd_atendimento IS NOT NULL THEN
--	   			'ATENDIDO'
--	   		ELSE 'ESCALA'
--	   END AS FORMA,
	   i.dt_gravacao,
	   i.ds_observacao_geral,
	   i.dh_presenca_falta,
	   a.cd_recurso_central,
	   r.ds_recurso_central,
	   a.cd_prestador,
	   pr.nm_prestador,
	   s.cd_setor,
	   s.nm_setor,
	   CASE
	   		WHEN s.nm_setor LIKE '%2%' AND s.nm_setor NOT IN('POSTO 2', 'UTI 2') AND TRUNC(i.dh_presenca_falta) >= TRUNC(s.dt_inclusao) THEN
	   			'CLINICA 2'
	 		ELSE
	 			'CLINICA 1'
	   END AS CLINICAS,
/*	   a.cd_setor,
	   s.nm_setor,
	   CASE 
	   		WHEN s.nm_setor LIKE '%2%'THEN
	   			'CLINICA 2'
	   		WHEN s.nm_setor LIKE '%RECEPCAO CLINICA%' THEN
	   			'CLINICA 1'
	   		ELSE s.nm_setor
	   END AS CLINICAS,*/
	   a.qt_atendimento,
	   a.qt_marcados,
	   i.cd_usuario,
	   u.nm_usuario,
	   i.cd_tip_mar,
	   tr.ds_tip_mar,
	   el.nm_exa_lab,
	   er.ds_exa_rx,
	   CASE a.tp_agenda 
	   		WHEN 'A' THEN 'Consulta'
	   		WHEN 'L' THEN 'Exame'
	   		WHEN 'I' THEN 'Exame'
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
	LEFT JOIN DBAMV.EXA_LAB el 				   ON ia.CD_EXA_LAB 		= el.CD_EXA_LAB
	LEFT JOIN DBAMV.EXA_RX er 				   ON ia.CD_EXA_RX          = er.CD_EXA_RX
	LEFT JOIN (
		SELECT   
			at.CD_ATENDIMENTO
		FROM DBAMV.ATENDIME at
		LEFT JOIN DBAMV.PACIENTE pa                ON at.cd_paciente         = pa.cd_paciente
		LEFT JOIN DBAMV.PRESTADOR p                ON at.cd_prestador        = p.CD_PRESTADOR 
		LEFT JOIN DBAMV.CONVENIO c                 ON at.cd_convenio         = c.cd_convenio
		LEFT JOIN DBAMV.ORI_ATE s                  ON at.cd_ori_ate          = s.cd_ori_ate
		LEFT JOIN DBAMV.TIP_MAR t                  ON at.cd_tip_mar          = t.cd_tip_mar
		LEFT JOIN DBAMV.ESPECIALID ia              ON at.cd_especialid       = ia.cd_especialid
		WHERE 
			EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE at.cd_atendimento = ate.cd_atendimento )
	) aten									   ON i.CD_ATENDIMENTO      = aten.CD_ATENDIMENTO
	WHERE 
		i.cd_atendimento  IS NOT NULL AND
		i.cd_it_agenda_pai IS NULL AND
		EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento ) AND
		ROUND(MONTHS_BETWEEN(i.dh_presenca_falta, i.hr_agenda)) >= 3 OR ROUND(MONTHS_BETWEEN(i.dh_presenca_falta, i.hr_agenda)) < 0
)
SELECT * FROM CONSULTA_FINAL; WHERE TO_CHAR(hr_agenda, 'MM/YYYY')= '01/2024' ;






SELECT
	CONSULTA_FINAL.*,
	COUNT(*) OVER( PARTITION BY CONSULTA_FINAL.STATUS_ATENDIMENTO ORDER BY CONSULTA_FINAL.hr_agenda ) AS qtd
FROM
	CONSULTA_FINAL
WHERE
	TO_CHAR(hr_agenda, 'MM/YYYY')= '01/2024' ;

SELECT nm_prestador, STATUS_ATENDIMENTO, COUNT(*) FROM CONSULTA_FINAL WHERE TO_CHAR(hr_agenda, 'MM/YYYY')='02/2024' GROUP BY nm_prestador, STATUS_ATENDIMENTO ORDER BY 1;
SELECT * FROM CONSULTA_FINAL WHERE hr_agenda BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD') AND TO_DATE('2024-07-31', 'YYYY-MM-DD') AND CD_ATENDIMENTO IN('98300', '98260') ;
TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024'
SELECT STATUS_ATENDIMENTO, COUNT(*) FROM CONSULTA_FINAL WHERE TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024' AND STATUS_ATENDIMENTO LIKE '%ATENDIDO%' GROUP BY STATUS_ATENDIMENTO ;
SELECT COUNT(*) FROM CONSULTA_FINAL WHERE TO_CHAR(hr_agenda, 'MM/YYYY')='01/2024' AND STATUS_ATENDIMENTO LIKE '%ATENDIDO%' ; 





WITH exa_lab AS (
    SELECT
        o.DS_ORI_ATE,
        p.CD_PACIENTE,
        p.NM_PACIENTE,
        pl.DT_PEDIDO,
        EXTRACT(MONTH FROM pl.DT_PEDIDO) AS MES,
        EXTRACT(YEAR FROM pl.DT_PEDIDO) AS ANO,
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
    TO_DATE(COMP, 'MM/YYYY') BETWEEN TO_DATE('08/2024', 'MM/YYYY') AND TO_DATE('09/2024', 'MM/YYYY')
    AND DS_ORI_ATE LIKE '%2%' ;
GROUP BY
    DT_EXAME,
    DS_ORI_ATE
ORDER BY
    DT_EXAME,
    DS_ORI_ATE;


SELECT
st.CD_SETOR ,
st.nm_setor,
CASE
	WHEN st.nm_setor LIKE '%2%' AND st.nm_setor NOT IN('POSTO 2', 'UTI 2') /*AND TRUNC(agen.hr_agenda) >= TRUNC(st.dt_inclusao)*/ THEN
		'CLINICA 2'
	ELSE
		'CLINICA 1'
END AS CLINICAS,
st.dt_inclusao
FROM DBAMV.SETOR st ;



		
	



		
		
		
		
		
		
	
		
		
		
		


