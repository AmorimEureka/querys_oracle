



-- TOTAL ATENDIMENTOS AMBULATORIAIS POR CLINICA - UP FLUX
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
            WHEN agen.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND st.cd_setor NOT IN (117, 137)
                 AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
                'CLINICA 2'
            WHEN agen.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND st.cd_setor NOT IN (117, 137)
                 AND st.nm_setor LIKE '%2%'
                 AND st.nm_setor NOT IN ('POSTO 2', 'UTI 2')
                 /*AND TRUNC(agen.hr_agenda) >= TRUNC(st.dt_inclusao)*/ THEN
                'CLINICA 2'
            WHEN agen.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
            	 AND st.cd_setor IN (117, 137) THEN
            	 st.nm_setor
            ELSE
                'CLINICA 1'
        END AS CLINICAS,
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
            WHEN a.dt_atendimento >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND st.cd_setor NOT IN (117, 137)
                 AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
                'CLINICA 2'
            WHEN a.dt_atendimento >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND st.cd_setor NOT IN (117, 137)
                 AND st.nm_setor LIKE '%2%'
                 AND st.nm_setor NOT IN ('POSTO 2', 'UTI 2')
                 /*AND TRUNC(a.dt_atendimento) >= TRUNC(st.dt_inclusao)*/ THEN
                'CLINICA 2'
            WHEN a.dt_atendimento >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
            AND  st.cd_setor IN (117, 137) THEN
            	 st.nm_setor
            ELSE
                'CLINICA 1'
        END AS CLINICAS,
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
            WHEN i.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND s.cd_setor NOT IN (117, 137)
                 AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
                'CLINICA 2'
            WHEN i.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND s.cd_setor NOT IN (117, 137)
                 AND s.nm_setor LIKE '%2%'
                 AND s.nm_setor NOT IN ('POSTO 2', 'UTI 2')
                 /*AND TRUNC(i.hr_agenda) >= TRUNC(s.dt_inclusao)*/ THEN
                'CLINICA 2'
            WHEN i.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
            	 AND s.cd_setor IN (117, 137) THEN
       			 s.nm_setor
            ELSE
                'CLINICA 1'
        END AS CLINICAS,
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
            WHEN i.DH_PRESENCA_FALTA >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND s.cd_setor NOT IN (117, 137)
                 AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
                'CLINICA 2'
            WHEN i.DH_PRESENCA_FALTA >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND s.cd_setor NOT IN (117, 137)
                 AND s.nm_setor LIKE '%2%'
                 AND s.nm_setor NOT IN ('POSTO 2', 'UTI 2')
                 /*AND TRUNC(i.hr_agenda) >= TRUNC(s.dt_inclusao)*/ THEN
                'CLINICA 2'
            WHEN i.DH_PRESENCA_FALTA >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
                 AND s.cd_setor IN (117, 137) THEN
                 s.nm_setor
            ELSE
                'CLINICA 1'
        END AS CLINICAS,
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
),
FILTRO
	AS(
		SELECT
			ANO || '-' || MES AS ANO_MES,
			CASE
				WHEN CLINICAS IN('CLINICA 2', 'RECEPCAO CLINICA 2') THEN
					'CLINICA2'
				ELSE
					'CLINICA1'
			END AS CLINICAS,
			tp_atendimento,
			count(DISTINCT CD_ATENDIMENTO ) AS QTD
		FROM CONSULTA_FINAL
		WHERE ((ANO = 2024 AND MES = 12) OR (ANO = 2025 AND MES IN (1, 2))) AND tp_atendimento IN('Consulta', 'Exame') AND STATUS_ATENDIMENTO NOT IN( 'ESCALA - OCIOSA', 'AGENDADO - ABSENTEISMO')
		GROUP BY ANO || '-' || MES, CLINICAS, tp_atendimento
		ORDER BY ANO || '-' || MES ASC
),
PIVOT_TABLE
	AS (
		SELECT * FROM FILTRO
		PIVOT
		(
			SUM(QTD)
			FOR CLINICAS IN('CLINICA1' AS "CLINICA1", 'CLINICA2' AS "CLINICA2")
		)
)
SELECT ANO_MES, CLINICA1, CLINICA2 FROM PIVOT_TABLE
UNION ALL
SELECT 'TOTAL GERAL' AS ANO_MES, SUM(CLINICA1), SUM(CLINICA2) FROM PIVOT_TABLE ;




-- QUERY PRESCRIÇÃO DE EXAMES
	SELECT
		a.CD_ATENDIMENTO , --
		a.TP_ATENDIMENTO ,
		a.HR_ATENDIMENTO ,
		a.CD_ORI_ATE ,
		oa.DS_ORI_ATE ,
		c.NM_CONVENIO ,
		pm.CD_PRE_MED ,    --
		pm.DH_CRIACAO ,
		tp.CD_TIP_ESQ ,
		CASE
			WHEN tp.CD_TIP_ESQ = 'EXI' THEN er.DS_EXA_RX
			WHEN tp.CD_TIP_ESQ = 'EXL' THEN el.NM_EXA_LAB
		END AS EXAMES
	FROM ATENDIME a
	LEFT JOIN PRE_MED pm
		ON pm.CD_ATENDIMENTO = a.CD_ATENDIMENTO
	LEFT JOIN ITPRE_MED im
		ON pm.CD_PRE_MED = im.CD_PRE_MED
	LEFT JOIN TIP_PRESC tp
		ON im.CD_TIP_PRESC = tp.CD_TIP_PRESC
	LEFT JOIN EXA_RX er
		ON tp.CD_EXA_RX = er.CD_EXA_RX
	LEFT JOIN EXA_LAB el
		ON tp.CD_EXA_LAB = el.CD_EXA_LAB
	LEFT JOIN ORI_ATE oa
		ON a.CD_ORI_ATE = oa.CD_ORI_ATE
	LEFT JOIN CONVENIO c
		ON a.CD_CONVENIO = c.CD_CONVENIO
	WHERE tp.CD_TIP_ESQ IN('EXI', 'EXL') AND NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento ) AND a.TP_ATENDIMENTO IN('A','U','I')
	;



-- TOTAL DE PEDIDOS DE EXAMES IMAGEM  e LABORATORIO - UP FLUX
WITH PEDIDOS_UP_FLUX
	AS(
		SELECT
			a.CD_ATENDIMENTO ,
			a.TP_ATENDIMENTO ,
			a.DT_ATENDIMENTO ,
			EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
			EXTRACT(YEAR FROM a.DT_ATENDIMENTO) AS ANO,
			pr.HR_PEDIDO AS DT_PEDIDO ,
			a.CD_ORI_ATE ,
			oa.DS_ORI_ATE ,
			c.NM_CONVENIO ,
			pm.CD_PRE_MED ,    --
			pm.DH_CRIACAO ,
			CAST('EXI' AS VARCHAR2(3)) AS CD_TIP_ESQ ,
			er.DS_EXA_RX EXAMES
		FROM  ITPED_RX ir
		LEFT JOIN PED_RX pr
			ON ir.cd_ped_rx = pr.cd_ped_rx
		LEFT JOIN ATENDIME a
			ON pr.cd_atendimento = a.cd_atendimento
		LEFT JOIN EXA_RX er
			ON ir.cd_exa_rx = er.cd_exa_rx
		LEFT JOIN PRE_MED pm
			ON pr.CD_PRE_MED = pm.CD_PRE_MED
		LEFT JOIN ORI_ATE oa
			ON a.CD_ORI_ATE = oa.CD_ORI_ATE
		LEFT JOIN CONVENIO c
			ON a.CD_CONVENIO = c.CD_CONVENIO
		WHERE a.TP_ATENDIMENTO = 'I'
		UNION ALL
		SELECT
			a.CD_ATENDIMENTO ,
			a.TP_ATENDIMENTO ,
			a.DT_ATENDIMENTO ,
			EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
			EXTRACT(YEAR FROM a.DT_ATENDIMENTO) AS ANO,
			pl.HR_PED_LAB AS DT_PEDIDO ,
			a.CD_ORI_ATE ,
			oa.DS_ORI_ATE ,
			c.NM_CONVENIO ,
			pm.CD_PRE_MED ,    --
			pm.DH_CRIACAO ,
			CAST('EXL' AS VARCHAR2(3)) AS CD_TIP_ESQ ,
			el.NM_EXA_LAB EXAMES
		FROM  ITPED_lab il
		LEFT JOIN PED_lab pl
			ON il.cd_ped_lab = pl.cd_ped_lab
		LEFT JOIN ATENDIME a
			ON pl.cd_atendimento = a.cd_atendimento
		LEFT JOIN EXA_LAB el
			ON il.cd_exa_lab = el.cd_exa_lab
		LEFT JOIN PRE_MED pm
			ON pl.CD_PRE_MED = pm.CD_PRE_MED
		LEFT JOIN ORI_ATE oa
			ON a.CD_ORI_ATE = oa.CD_ORI_ATE
		LEFT JOIN CONVENIO c
			ON a.CD_CONVENIO = c.CD_CONVENIO
		WHERE a.TP_ATENDIMENTO = 'I'
),
FILTROS
	AS (
		SELECT
			ANO || '-' || MES AS ANO_MES,
			CASE WHEN CD_TIP_ESQ = 'EXI' THEN
				'EXAME IMAGEM'
				WHEN CD_TIP_ESQ = 'EXL' THEN
				'EXAME LABORATORIO'
			END AS EXAME,
			COUNT(DISTINCT CD_ATENDIMENTO) AS QTD_ATENDIMENTO
		FROM PEDIDOS_UP_FLUX
		WHERE ((ANO = 2024 AND MES = 12) OR (ANO = 2025 AND MES IN (1, 2)))
		GROUP BY ANO || '-' || MES, CASE WHEN CD_TIP_ESQ = 'EXI' THEN 'EXAME IMAGEM' WHEN CD_TIP_ESQ = 'EXL' THEN 'EXAME LABORATORIO' END
		ORDER BY ANO || '-' || MES ASC
),
PIVOT_TABLE
	AS (
		SELECT * FROM FILTROS
		PIVOT (
			SUM(QTD_ATENDIMENTO)
			FOR EXAME IN('EXAME IMAGEM' AS "EXAME_IMAGEM", 'EXAME LABORATORIO' AS "EXAME_LABORATORIO")
		)
)
SELECT ANO_MES, EXAME_IMAGEM, EXAME_LABORATORIO FROM PIVOT_TABLE

UNION ALL

SELECT
	'TOTAL GERAL' AS ANO_MES,
	SUM(EXAME_IMAGEM) AS EXAME_IMAGEM,
	SUM(EXAME_LABORATORIO) AS EXAME_LABORATORIO
FROM PIVOT_TABLE
;



-- TOTAL ALTAS PRONTO ATENDIMENTO - UP FLUX
WITH ALTA_HOSPITALAR
	AS (
		SELECT
			CD_ATENDIMENTO ,
			CD_PACIENTE ,
			CD_CONVENIO ,
			CD_PRESTADOR ,
			CD_LEITO ,
			CD_MOT_ALT ,
			DT_ATENDIMENTO ,
			DH_ALTA_LANCADA ,
			EXTRACT(MONTH FROM DH_ALTA_LANCADA) AS MES,
			EXTRACT(YEAR FROM DH_ALTA_LANCADA) AS ANO,
			DT_ALTA ,
			NM_USUARIO_ALTA ,
			DT_ALTA_MEDICA ,
			NM_USUARIO_ALTA_MEDICA ,
			DT_PREVISTA_ALTA ,
			TP_ATENDIMENTO
			FROM ATENDIME WHERE TP_ATENDIMENTO = 'I' AND HR_ALTA IS NOT NULL
),
FILTROS
	AS (
		SELECT
			ANO || '-' || MES AS ANO_MES,
			COUNT(DISTINCT CD_ATENDIMENTO) AS QTD_ATENDIMENTO
		FROM ALTA_HOSPITALAR
		WHERE ((ANO = 2024 AND MES = 12) OR (ANO = 2025 AND MES IN (1, 2)))
		GROUP BY ANO || '-' || MES
		ORDER BY ANO || '-' || MES ASC
)
SELECT ANO_MES, QTD_ATENDIMENTO FROM FILTROS

UNION ALL

SELECT
	'TOTAL GERAL' AS ANO_MES,
	SUM(QTD_ATENDIMENTO) AS QTD_ATENDIMENTO
FROM FILTROS
;

-- TOTAL ATENDIMENTOS PRONTO ATENDIMENTO - UP FLUX
WITH QTD_PRONTO_ATENDIMENTO
	AS (
		SELECT
			CD_ATENDIMENTO ,
			HR_ATENDIMENTO ,
			EXTRACT(MONTH FROM HR_ATENDIMENTO) AS MES,
			EXTRACT(YEAR FROM HR_ATENDIMENTO) AS ANO,
			TP_ATENDIMENTO
		FROM DBAMV.ATENDIME
),
FILTRO
	AS (
SELECT
	ANO || '-' || MES AS ANO_MES,
	COUNT(DISTINCT CD_ATENDIMENTO) AS QTD_ATENDIMENTO
FROM QTD_PRONTO_ATENDIMENTO
WHERE ((ANO = 2024 AND MES = 12) OR (ANO = 2025 AND MES IN (1, 2))) AND TP_ATENDIMENTO = 'I'
GROUP BY ANO || '-' || MES
ORDER BY ANO || '-' || MES ASC
)
SELECT * FROM FILTRO

UNION ALL

SELECT
	'TOTAL GERAL' AS ANO_MES,
	SUM(QTD_ATENDIMENTO) AS QTD_ATENDIMENTO
FROM FILTRO

 ;






-- METADADOS PARA ENCONTRAR COLUNAS QUE TENHAM A STRING 'ALTA'
-- PARA INFERIR CONTRAR A TELA 'CON_ATE' e IDENTIFICAR A ALTA
-- HOSPITALAR, QUE É CONSIDERADA A ALTA DO HOSPITAL
SELECT * FROM user_tab_columns WHERE TABLE_NAME = 'ATENDIME' AND COLUMN_NAME LIKE '%ALTA%'
;

-- METADADOS PARA VER OS CAMPOS DA TABELA 'PED_LAB'
-- PARA IDENTIFICAR O CAMPO CORRESPONDENTE À DATA DO PEDIDO
-- O CAMPO 'HR_PED_LAB' É A DATA DO PEDIDO DO EXAME LABORATORIAL
SELECT * FROM user_tab_columns WHERE TABLE_NAME = 'PED_LAB'
;

-- METADADOS PARA VER OS CAMPOS DA TABELA 'PED_RXB'
-- PARA IDENTIFICAR O CAMPO CORRESPONDENTE À DATA DO PEDIDO
-- O CAMPO 'HR_PEDIDO' É A DATA DO PEDIDO DO EXAME DE IMAGEM
SELECT * FROM user_tab_columns WHERE TABLE_NAME = 'PED_RX'
;



/* ************************************************************************************************ */

-- QUERY FINAL COM OS EXAMES
WITH CONSULTA_FINAL AS(
SELECT -- ATENDIDOS AGENDADOS
   agen.cd_agenda_central ,
   agen.TIPO_AGENDA ,
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
   agen.cd_item_agendamento,
   ia.ds_especialid AS ds_item_agendamento,
   'ATENDIDO AGENDADO' AS STATUS_ATENDIMENTO,
   a.hr_atendimento AS dt_gravacao,
   agen.ds_observacao_geral ,
   agen.dh_presenca_falta,
   agen.cd_recurso_central ,
   agen.ds_recurso_central ,
   a.cd_prestador,
   p.nm_prestador,
   st.cd_setor,
   st.nm_setor,
    CASE
        WHEN agen.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND st.cd_setor NOT IN (117,137)
             AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
            'CLINICA 2'
        WHEN agen.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND st.cd_setor NOT IN (117, 137)
             AND st.nm_setor LIKE '%2%'
             AND st.nm_setor NOT IN ('POSTO 2', 'UTI 2') THEN
            'CLINICA 2'
        WHEN agen.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
        	 AND st.cd_setor IN (117, 137) THEN
        	'CLINICA 2'
        ELSE
            'CLINICA 1'
    END AS CLINICAS,
    agen.qt_atendimento ,
   agen.qt_marcados ,
   agen.cd_usuario ,
   agen.nm_usuario ,
   agen.cd_tip_mar ,
   t.ds_tip_mar,
   agen.TIPO_EXAMES ,
   agen.EXAMES,
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
	   i.cd_agenda_central,
	   i.ds_observacao_geral,
	   i.cd_item_agendamento,
	   i.dh_presenca_falta,
	   r.cd_recurso_central,
	   r.ds_recurso_central,
	   DECODE(a.TP_AGENDA,'L','LABORATORIO','I', 'IMAGEM','A', 'AMBULATORIO' ) AS TIPO_AGENDA,
       a.qt_atendimento,
	   a.qt_marcados,
	   i.cd_usuario,
	   u.nm_usuario,
	   i.cd_tip_mar,
	   tr.ds_tip_mar,
	   CASE
	   		WHEN el.nm_exa_lab IS NOT NULL THEN 'EXL'
	   		WHEN er.ds_exa_rx IS NOT NULL THEN 'EXI'
	   END AS TIPO_EXAMES,
	   NVL(el.nm_exa_lab, er.ds_exa_rx) AS EXAMES
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
WHERE EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
UNION ALL
SELECT -- ATENDIDOS NÃO AGENDADOS
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
        WHEN a.dt_atendimento >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND st.cd_setor NOT IN (117,137)
             AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
            'CLINICA 2'
        WHEN a.dt_atendimento >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND st.cd_setor NOT IN (117, 137)
             AND st.nm_setor LIKE '%2%'
             AND st.nm_setor NOT IN ('POSTO 2', 'UTI 2') THEN
            'CLINICA 2'
        WHEN a.dt_atendimento >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
        AND  st.cd_setor IN (117, 137) THEN
        	'CLINICA 2'
        ELSE
            'CLINICA 1'
    END AS CLINICAS,
   CAST('0' AS NUMBER(3,0)) AS qt_atendimento,
   CAST('0' AS NUMBER(3,0)) AS qt_marcados,
   CAST('SEM' AS VARCHAR2(30)) AS cd_usuario,
   CAST('SEM' AS VARCHAR2(30)) AS nm_usuario,
   CAST('0' AS NUMBER(4,0)) AS cd_tip_mar,
   t.ds_tip_mar,
   ex.CD_TIP_ESQ AS TIPO_EXAMES ,
   ex.EXAMES,
   CASE a.tp_atendimento
   		WHEN 'A' THEN 'Consulta'             -- prescrição sem pedidos
   		WHEN 'E' THEN 'Exame'  				 -- pedido [RECEPÇÃO] ou prescrição [MEDICO]
   		WHEN 'U' THEN 'Urgência/Emergência'  -- prescrição -> gera pedido
   		WHEN 'I' THEN 'Internação'           -- prescrição -> gera pedido
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
LEFT JOIN (
	SELECT
		a.CD_ATENDIMENTO , --
		a.TP_ATENDIMENTO ,
		a.HR_ATENDIMENTO ,
		a.CD_ORI_ATE ,
		oa.DS_ORI_ATE ,
		c.NM_CONVENIO ,
		pm.CD_PRE_MED ,    --
		pm.DH_CRIACAO ,
		tp.CD_TIP_ESQ ,
		CASE
			WHEN tp.CD_TIP_ESQ = 'EXI' THEN er.DS_EXA_RX
			WHEN tp.CD_TIP_ESQ = 'EXL' THEN el.NM_EXA_LAB
		END AS EXAMES
	FROM ATENDIME a
	LEFT JOIN PRE_MED pm
		ON pm.CD_ATENDIMENTO = a.CD_ATENDIMENTO
	LEFT JOIN ITPRE_MED im
		ON pm.CD_PRE_MED = im.CD_PRE_MED
	LEFT JOIN TIP_PRESC tp
		ON im.CD_TIP_PRESC = tp.CD_TIP_PRESC
	LEFT JOIN EXA_RX er
		ON tp.CD_EXA_RX = er.CD_EXA_RX
	LEFT JOIN EXA_LAB el
		ON tp.CD_EXA_LAB = el.CD_EXA_LAB
	LEFT JOIN ORI_ATE oa
		ON a.CD_ORI_ATE = oa.CD_ORI_ATE
	LEFT JOIN CONVENIO c
		ON a.CD_CONVENIO = c.CD_CONVENIO
	WHERE tp.CD_TIP_ESQ IN('EXI', 'EXL') AND NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento ) AND a.TP_ATENDIMENTO IN('A','U','I')
	UNION ALL
	SELECT
		a.CD_ATENDIMENTO ,
		a.TP_ATENDIMENTO ,
		a.HR_ATENDIMENTO ,
		a.CD_ORI_ATE ,
		oa.DS_ORI_ATE ,
		c.NM_CONVENIO ,
		pm.CD_PRE_MED ,    --
		pm.DH_CRIACAO ,
		CAST('EXI' AS VARCHAR2(3)) AS CD_TIP_ESQ ,
		er.DS_EXA_RX EXAMES
	FROM  ITPED_RX ir
	LEFT JOIN PED_RX pr
		ON ir.cd_ped_rx = pr.cd_ped_rx
	LEFT JOIN ATENDIME a
		ON pr.cd_atendimento = a.cd_atendimento
	LEFT JOIN EXA_RX er
		ON ir.cd_exa_rx = er.cd_exa_rx
	LEFT JOIN PRE_MED pm
		ON pr.CD_PRE_MED = pm.CD_PRE_MED
	LEFT JOIN ORI_ATE oa
		ON a.CD_ORI_ATE = oa.CD_ORI_ATE
	LEFT JOIN CONVENIO c
		ON a.CD_CONVENIO = c.CD_CONVENIO
	WHERE NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento ) AND a.TP_ATENDIMENTO = 'E'
	UNION ALL
	SELECT
		a.CD_ATENDIMENTO ,
		a.TP_ATENDIMENTO ,
		a.HR_ATENDIMENTO ,
		a.CD_ORI_ATE ,
		oa.DS_ORI_ATE ,
		c.NM_CONVENIO ,
		pm.CD_PRE_MED ,    --
		pm.DH_CRIACAO ,
		CAST('EXL' AS VARCHAR2(3)) AS CD_TIP_ESQ ,
		el.NM_EXA_LAB EXAMES
	FROM  ITPED_lab il
	LEFT JOIN PED_lab pl
		ON il.cd_ped_lab = pl.cd_ped_lab
	LEFT JOIN ATENDIME a
		ON pl.cd_atendimento = a.cd_atendimento
	LEFT JOIN EXA_LAB el
		ON il.cd_exa_lab = el.cd_exa_lab
	LEFT JOIN PRE_MED pm
		ON pl.CD_PRE_MED = pm.CD_PRE_MED
	LEFT JOIN ORI_ATE oa
		ON a.CD_ORI_ATE = oa.CD_ORI_ATE
	LEFT JOIN CONVENIO c
		ON a.CD_CONVENIO = c.CD_CONVENIO
	WHERE NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento ) AND  a.TP_ATENDIMENTO = 'E'
	) ex									   ON a.cd_atendimento      =   ex.cd_atendimento
WHERE NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
UNION ALL
SELECT -- AGENDADOS *REST [ ABSENTEISTA | OCIOSO ]
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
        WHEN i.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND s.cd_setor NOT IN (117, 137)
             AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
            'CLINICA 2'
        WHEN i.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND s.cd_setor NOT IN (117, 137)
             AND s.nm_setor LIKE '%2%'
             AND s.nm_setor NOT IN ('POSTO 2', 'UTI 2') THEN
            'CLINICA 2'
        WHEN i.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
        	 AND s.cd_setor IN (117, 137) THEN
   			'CLINICA 2'
        ELSE
            'CLINICA 1'
    END AS CLINICAS,
   a.qt_atendimento,
   a.qt_marcados,
   i.cd_usuario,
   u.nm_usuario,
   i.cd_tip_mar,
   tr.ds_tip_mar,
   CASE
   		WHEN el.nm_exa_lab IS NOT NULL THEN 'EXL'
   		WHEN er.ds_exa_rx IS NOT NULL THEN 'EXI'
   END AS TIPO_EXAMES,
   NVL(el.nm_exa_lab, er.ds_exa_rx) AS EXAMES ,
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
WHERE i.cd_atendimento  IS NULL AND	i.cd_it_agenda_pai IS NULL
UNION ALL
SELECT -- AGENDA REUTILIZADA
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
        WHEN i.DH_PRESENCA_FALTA >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND s.cd_setor NOT IN (117, 137)
             AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
            'CLINICA 2'
        WHEN i.DH_PRESENCA_FALTA >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND s.cd_setor NOT IN (117, 137)
             AND s.nm_setor LIKE '%2%'
             AND s.nm_setor NOT IN ('POSTO 2', 'UTI 2') THEN
            'CLINICA 2'
        WHEN i.DH_PRESENCA_FALTA >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
             AND s.cd_setor IN (117, 137) THEN
            'CLINICA 2'
        ELSE
            'CLINICA 1'
    END AS CLINICAS,
   a.qt_atendimento,
   a.qt_marcados,
   i.cd_usuario,
   u.nm_usuario,
   i.cd_tip_mar,
   tr.ds_tip_mar,
   CASE
   		WHEN el.nm_exa_lab IS NOT NULL THEN 'EXL'
   		WHEN er.ds_exa_rx IS NOT NULL THEN 'EXI'
   END AS TIPO_EXAMES,
   NVL(el.nm_exa_lab, er.ds_exa_rx) AS EXAMES ,
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
	i.cd_atendimento  IS NOT NULL AND
	i.cd_it_agenda_pai IS NULL AND
	EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE ate.cd_atendimento = i.cd_atendimento ) AND
	ROUND(MONTHS_BETWEEN(i.dh_presenca_falta, i.hr_agenda)) >= 3 OR ROUND(MONTHS_BETWEEN(i.dh_presenca_falta, i.hr_agenda)) < 0
)
SELECT STATUS_ATENDIMENTO, count(*) AS QTD FROM CONSULTA_FINAL
WHERE ANO = 2025 AND MES = 1 AND tp_atendimento IN('Consulta', 'Exame')
GROUP BY STATUS_ATENDIMENTO;

SELECT * FROM CONSULTA_FINAL WHERE EXAMES LIKE '%TESTE ERGOMETRI%' ;





