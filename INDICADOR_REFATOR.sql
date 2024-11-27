
WITH atend AS (
	SELECT
	   st.dt_inclusao,
	   CAST('0' AS NUMBER(8,0)) AS cd_agenda_central,
	   CAST('SEM' AS VARCHAR2(3)) AS TIPO_AGENDA,
	   CAST('1' AS NUMBER(8,0)) AS ACRES,
--	   a.dt_atendimento AS hr_agenda,
	   EXTRACT(MONTH FROM a.hr_atendimento) AS MES,
	   EXTRACT(YEAR FROM a.hr_atendimento) AS ANO,
	   a.cd_atendimento,
	   a.cd_paciente,
	   pa.nm_paciente,
	   pa.dt_nascimento,
	   c.cd_convenio,
	   c.nm_convenio,
	   CAST('0' AS NUMBER(9,0)) AS cd_item_agendamento,
	   ia.ds_especialid AS ds_item_agendamento,
	   a.hr_atendimento AS dt_gravacao,
	   CAST('SEM' AS VARCHAR2(10)) AS ds_observacao_geral,
	   CAST(null AS DATE) AS dh_presenca_falta,
	   CAST('0' AS NUMBER(6,0)) AS cd_recurso_central,
	   CAST('SEM' AS VARCHAR2(30)) AS ds_recurso_central,
	   a.cd_prestador,
	   p.nm_prestador,
	   st.cd_setor,
	   st.nm_setor,
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
	LEFT JOIN DBAMV.SETOR st				   ON s.cd_setor            = st.cd_setor
),
agend AS (
	SELECT
	   i.hr_agenda,
	   s.dt_inclusao,
	   i.cd_agenda_central,
	   DECODE(a.TP_AGENDA,'L','LABORATORIO','I', 'IMAGEM','A', 'AMBULATORIO' ) AS TIPO_AGENDA,
	   CAST('1' AS NUMBER(8,0)) AS ACRES,
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
	   i.dt_gravacao,
	   i.ds_observacao_geral,
	   i.dh_presenca_falta,
	   a.cd_recurso_central,
	   r.ds_recurso_central,
	   a.cd_prestador,
	   pr.nm_prestador,
	   s.cd_setor,
	   s.nm_setor,
	   a.qt_atendimento,
	   a.qt_marcados,
	   i.cd_usuario,
	   u.nm_usuario,
	   i.cd_tip_mar,
	   tr.ds_tip_mar,
	   CASE a.tp_agenda 
	   		WHEN 'A' THEN 'Consulta'
	   		WHEN 'L' THEN 'Exame'
	   		WHEN 'I' THEN 'Exame'
	   		ELSE 'Sem Correspondência'
	   END AS tp_atendimento,
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
		i.cd_it_agenda_pai IS NULL
)
SELECT -- Atendidos Agendados até '2024-05-27 00:00:00'
	agend.hr_agenda,
	atend.*,
    agend.ds_exa_rx,
    agend.nm_exa_lab,
    CAST('CLINICA 1' AS VARCHAR2(10)) AS CLINICAS
FROM
    atend
LEFT JOIN agend ON atend.cd_atendimento = agend.cd_atendimento
WHERE
	agend.hr_agenda < TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
UNION ALL 
SELECT -- Atendidos Agendados após '2024-05-27 00:00:00' - segmentação entre 'Clinica 1' e 'Clinica 2'
	agend.hr_agenda,
	atend.*,
    agend.ds_exa_rx,
    agend.nm_exa_lab,
    CASE
        WHEN atend.cd_setor NOT IN (117, 137) 
             AND atend.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
            'CLINICA 2'
        WHEN atend.cd_setor NOT IN (117, 137)
             AND atend.nm_setor LIKE '%2%' 
             AND atend.nm_setor NOT IN ('POSTO 2', 'UTI 2') 
             AND TRUNC(agend.hr_agenda) >= TRUNC(atend.dt_inclusao) THEN
            'CLINICA 2'
        ELSE
            'CLINICA 1'
    END AS CLINICAS
FROM
    atend
LEFT JOIN agend ON atend.cd_atendimento = agend.cd_atendimento
WHERE 
    agend.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
UNION ALL
SELECT -- Atendidos Não Agendados até '2024-05-27 00:00:00'
	agend.hr_agenda,
	atend.*,
    agend.ds_exa_rx,
    agend.nm_exa_lab,
    CAST('CLINICA 1' AS VARCHAR2(10)) AS CLINICAS
FROM
    atend
LEFT JOIN agend ON atend.cd_atendimento = agend.cd_atendimento
WHERE 
	NOT EXISTS ( SELECT 1 FROM agend WHERE atend.cd_atendimento = agend.cd_atendimento ) 
	AND agend.hr_agenda < TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
UNION ALL 
SELECT -- Atendidos Não Agendados após '2024-05-27 00:00:00' - segmentação entre 'Clinica 1' e 'Clinica 2'
	agend.hr_agenda,
	atend.*,
    agend.ds_exa_rx,
    agend.nm_exa_lab,
    CASE
        WHEN atend.cd_setor NOT IN (117, 137) 
             AND atend.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
            'CLINICA 2'
        WHEN atend.cd_setor NOT IN (117, 137)
             AND atend.nm_setor LIKE '%2%' 
             AND atend.nm_setor NOT IN ('POSTO 2', 'UTI 2') 
             AND TRUNC(agend.hr_agenda) >= TRUNC(atend.dt_inclusao) THEN
            'CLINICA 2'
        ELSE
            'CLINICA 1'
    END AS CLINICAS
FROM
    atend
LEFT JOIN agend ON atend.cd_atendimento = agend.cd_atendimento
WHERE 
	NOT EXISTS ( SELECT 1 FROM agend WHERE atend.cd_atendimento = agend.cd_atendimento ) 
	AND agend.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
UNION ALL
SELECT -- Agendados com CÓDIGO REUTILIZADO até '2024-05-27 00:00:00'
    agend.*,
    CAST('CLINICA 1' AS VARCHAR2(10)) AS CLINICAS
FROM
    agend
LEFT JOIN atend ON agend.cd_atendimento = atend.cd_atendimento
WHERE 
	EXISTS ( SELECT 1 FROM agend WHERE atend.cd_atendimento = agend.cd_atendimento )
	AND agend.cd_atendimento  IS NOT NULL
	AND ROUND(MONTHS_BETWEEN(agend.dh_presenca_falta, agend.hr_agenda)) >= 3 OR ROUND(MONTHS_BETWEEN(agend.dh_presenca_falta, agend.hr_agenda)) < 0
	AND agend.hr_agenda < TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
UNION ALL
SELECT -- Agendados com CÓDIGO REUTILIZADO após '2024-05-27 00:00:00' - segmentação entre 'Clinica 1' e 'Clinica 2'
    agend.*,
    CASE
        WHEN agend.cd_setor NOT IN (117, 137) 
             AND agend.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
            'CLINICA 2'
        WHEN agend.cd_setor NOT IN (117, 137)
             AND agend.nm_setor LIKE '%2%' 
             AND agend.nm_setor NOT IN ('POSTO 2', 'UTI 2') 
             AND TRUNC(agend.dh_presenca_falta) >= TRUNC(agend.dt_inclusao) THEN
            'CLINICA 2'
        ELSE
            'CLINICA 1'
    END AS CLINICAS
FROM
    agend
LEFT JOIN atend ON agend.cd_atendimento = atend.cd_atendimento
WHERE 
	EXISTS ( SELECT 1 FROM agend WHERE atend.cd_atendimento = agend.cd_atendimento )
	AND agend.cd_atendimento  IS NOT NULL
	AND ROUND(MONTHS_BETWEEN(agend.dh_presenca_falta, agend.hr_agenda)) >= 3 OR ROUND(MONTHS_BETWEEN(agend.dh_presenca_falta, agend.hr_agenda)) < 0
	AND agend.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
UNION ALL
SELECT -- Agendados REST até '2024-05-27 00:00:00'
    agend.*,
    CAST('CLINICA 1' AS VARCHAR2(10)) AS CLINICAS
FROM
    agend
WHERE 
	agend.cd_atendimento  IS NULL
	AND agend.hr_agenda < TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS')
UNION ALL
SELECT -- Agendados REST após '2024-05-27 00:00:00' - segmentação entre 'Clinica 1' e 'Clinica 2'
    agend.*,
    CASE
        WHEN agend.cd_setor NOT IN (117, 137) 
             AND agend.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
            'CLINICA 2'
        WHEN agend.cd_setor NOT IN (117, 137)
             AND agend.nm_setor LIKE '%2%' 
             AND agend.nm_setor NOT IN ('POSTO 2', 'UTI 2') 
             AND TRUNC(agend.dh_presenca_falta) >= TRUNC(agend.dt_inclusao) THEN
            'CLINICA 2'
        ELSE
            'CLINICA 1'
    END AS CLINICAS
FROM
    agend
WHERE 
	agend.cd_atendimento  IS NULL
	AND agend.hr_agenda >= TO_TIMESTAMP(:pdate, 'YYYY-MM-DD HH24:MI:SS');
;





-- '2024-05-27 00:00:00'








WITH cte1 AS (
    -- Primeira CTE
    SELECT column1, column2
    FROM table1
    WHERE condition1
),
cte2 AS (
    -- Segunda CTE que usa a primeira CTE
    SELECT column1, column2
    FROM cte1
    WHERE condition2
),
cte3 AS (
    -- Terceira CTE que usa a segunda CTE
    SELECT column1, column2
    FROM cte2
    WHERE condition3
)
-- Consulta final que utiliza a última CTE
SELECT * FROM cte1 
UNION 
SELECT * FROM cte2 WHERE NOT EXISTS ( SELECT 1 FROM ct1.column1 = ct1.column2 )
UNION
SELECT * FROM cte1;












































