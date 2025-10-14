


-- QUERY FINAL COM OS EXAMES
WITH CONSULTA_FINAL
    AS(
        SELECT -- ATENDIDOS AGENDADOS
        a.cd_atendimento,
        'ATENDIDO AGENDADO' AS STATUS_ATENDIMENTO,
        EXTRACT(MONTH FROM agen.hr_agenda) AS MES,
        EXTRACT(YEAR FROM agen.hr_agenda) AS ANO,
        a.cd_paciente,
        pa.nm_paciente,
        c.cd_convenio,
        c.nm_convenio,
        a.cd_prestador,
        p.nm_prestador,
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
        a.tp_atendimento
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
            tr.ds_tip_mar
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
            EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE i.cd_atendimento = ate.cd_atendimento )
        ) agen                                     ON a.CD_ATENDIMENTO      = agen.CD_ATENDIMENTO
        LEFT JOIN DBAMV.SETOR st				   ON s.CD_SETOR            =   st.CD_SETOR
        WHERE EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
        UNION ALL
        SELECT -- ATENDIDOS NÃO AGENDADOS
        a.cd_atendimento,
        'ATENDIDO NÃO AGENDADO' AS STATUS_ATENDIMENTO,
        EXTRACT(MONTH FROM a.dt_atendimento) AS MES,
        EXTRACT(YEAR FROM a.dt_atendimento) AS ANO,
        a.cd_paciente,
        pa.nm_paciente,
        c.cd_convenio,
        c.nm_convenio,
        a.cd_prestador,
        p.nm_prestador,
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
        a.tp_atendimento
        FROM DBAMV.ATENDIME a
        LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
        LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR
        LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
        LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
        LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
        LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
        LEFT JOIN DBAMV.SETOR st				   ON s.CD_SETOR            = st.CD_SETOR
        WHERE NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )

        -- SELECT
        --     a.CD_ATENDIMENTO,
        --     EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
        --     EXTRACT(YEAR FROM  a.DT_ATENDIMENTO) AS ANO,
        --     a.CD_PACIENTE,
        --     p.NM_PACIENTE,
        --     a.TP_ATENDIMENTO
        -- FROM DBAMV.ATENDIME a
        -- JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
),
REGRA_AMBULATORIO
    AS (
			SELECT
				pf.CD_PRO_FAT,
				ia.CD_REG_AMB,
				ia.CD_PRESTADOR,
                p.NM_PRESTADOR,
				ia.CD_LANCAMENTO,
                ia.CD_GRU_FAT,
				ia.CD_CONVENIO,
				ia.CD_ATENDIMENTO,
				pf.DS_PRO_FAT,
				ia.HR_LANCAMENTO,
				ia.SN_PERTENCE_PACOTE,
				ia.VL_TOTAL_CONTA,
                ia.VL_PERCENTUAL_MULTIPLA,
				ia.VL_BASE_REPASSADO,
                ia.TP_PAGAMENTO
			FROM DBAMV.ITREG_AMB ia
			LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
			LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
            LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
			-- WHERE ia.SN_REPASSADO IN ('S', 'N') OR ia.SN_REPASSADO IS NULL
),
REGRA_FATURAMENTO
    AS (
        SELECT
            pf.CD_PRO_FAT,
            itf.CD_REG_FAT,
            itf.CD_PRESTADOR,
            p.NM_PRESTADOR,
            itf.CD_LANCAMENTO,
            itf.CD_GRU_FAT,
            rf.CD_CONVENIO,
            rf.CD_ATENDIMENTO,
            pf.DS_PRO_FAT,
            itf.DT_LANCAMENTO,
            itf.SN_PERTENCE_PACOTE,
            itf.VL_TOTAL_CONTA,
            itf.VL_PERCENTUAL_MULTIPLA,
            itf.VL_BASE_REPASSADO,
            itf.TP_PAGAMENTO
        FROM DBAMV.ITREG_FAT itf
        LEFT JOIN DBAMV.PRO_FAT pf 	   ON itf.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_FAT rf 	   ON itf.CD_REG_FAT = rf.CD_REG_FAT
        LEFT JOIN DBAMV.PRESTADOR p    ON itf.CD_PRESTADOR = p.CD_PRESTADOR
        -- WHERE itf.SN_REPASSADO IN ('S', 'N') OR itf.SN_REPASSADO IS NULL
)
SELECT
    cf.CD_ATENDIMENTO,

    cf.STATUS_ATENDIMENTO,

    CASE
        WHEN COALESCE(ra.CD_PRO_FAT, rf.CD_PRO_FAT) = 'X0000000' THEN
            'SUS'
        WHEN COALESCE(ra.TP_PAGAMENTO, rf.TP_PAGAMENTO) = 'P' OR COALESCE(ra.TP_PAGAMENTO, rf.TP_PAGAMENTO) IS NULL THEN
            'PRODUCAO'
        WHEN COALESCE(ra.TP_PAGAMENTO, rf.TP_PAGAMENTO) = 'C' THEN
            'COOPERATIVA'
        ELSE 'OUTROS'
    END AS TP_FATURAMENTO,

    cf.MES,
    cf.ANO,

    COALESCE(ra.HR_LANCAMENTO, rf.DT_LANCAMENTO) AS HR_LANCAMENTO,

    CASE cf.TP_ATENDIMENTO
        WHEN 'A' THEN 'AMBULATORIAL'
        WHEN 'E' THEN 'EXTERNO'
        WHEN 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN 'I' THEN 'INTERNACAO'
        ELSE 'Sem Correspondência'
    END AS TIPO_ATENDIMENTO,

    cf.NM_PACIENTE,

    COALESCE(ra.NM_PRESTADOR, rf.NM_PRESTADOR) AS PRESTADOR,

    cf.CLINICAS,

    CASE
        WHEN COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) IN(3,5,10) THEN
            'MEDICAMENTOS'
        WHEN COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) = 1 THEN
            'DIARIAS'
        WHEN COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) = 2 THEN
            'TAXAS'
        WHEN COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) = 4 THEN
            'MATERIAIS'
        WHEN COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) = 8 THEN
            'PACOTE'
        WHEN COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) = 7 AND cf.TP_ATENDIMENTO = 'I' THEN
            'PROCEDIMENTO_MED'
        WHEN COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) = 7 AND cf.TP_ATENDIMENTO IN('A', 'U') THEN
            'CONSULTA'
        WHEN rf.CD_GRU_FAT = 6 AND cf.TP_ATENDIMENTO = 'A'  THEN
            'EXAMES'
        WHEN COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) IN(6, 7) AND cf.TP_ATENDIMENTO IN('I', 'E', 'U') THEN
            'EXAMES'
        ELSE 'OUTROS'
    END AS PROCEDIMENTO_FATURADO,

    COALESCE(ra.DS_PRO_FAT, rf.DS_PRO_FAT) AS PROCEDIMENTO,
    COALESCE(ra.VL_TOTAL_CONTA, rf.VL_TOTAL_CONTA) AS VL_TOTAL_CONTA

FROM CONSULTA_FINAL cf
 LEFT JOIN REGRA_AMBULATORIO ra ON cf.CD_ATENDIMENTO = ra.CD_ATENDIMENTO
 LEFT JOIN REGRA_FATURAMENTO rf ON cf.CD_ATENDIMENTO = rf.CD_ATENDIMENTO

WHERE
	cf.ANO = 2025 AND cf.MES = 8
    -- AND COALESCE(ra.CD_GRU_FAT, rf.CD_GRU_FAT) = 8
	-- AND cf.CD_ATENDIMENTO =  255178  --248508 --248517 --248530 --255178
    AND COALESCE(rf.SN_PERTENCE_PACOTE, ra.SN_PERTENCE_PACOTE) = 'N'
    -- AND COALESCE(ra.TP_PAGAMENTO, rf.TP_PAGAMENTO) = 'C'
ORDER BY cf.CD_ATENDIMENTO DESC

;




SELECT
    pf.CD_PRO_FAT,
    COALESCE(er.CD_EXA_RX, el.CD_EXA_LAB) AS CD_EXAMES,
    ia.CD_REG_AMB,
    ia.CD_PRESTADOR,
    ia.CD_ATI_MED,
    ia.CD_LANCAMENTO,
    pf.CD_GRU_PRO,
    ia.CD_GRU_FAT,
    ia.CD_CONVENIO,
    ia.CD_ATENDIMENTO,
    ra.CD_REMESSA,
    pf.DS_PRO_FAT,
    ra.DT_REMESSA,
    ia.DT_PRODUCAO,
    ia.DT_FECHAMENTO,
    ia.HR_LANCAMENTO,
    ia.SN_FECHADA,
    ia.SN_REPASSADO,
    ia.SN_PERTENCE_PACOTE,
    ia.VL_UNITARIO,
    ia.VL_TOTAL_CONTA,
    ia.VL_BASE_REPASSADO
FROM DBAMV.ITREG_AMB ia
LEFT JOIN DBAMV.PRO_FAT pf ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
LEFT JOIN DBAMV.REG_AMB ra ON ia.CD_REG_AMB = ra.CD_REG_AMB
LEFT JOIN DBAMV.EXA_RX er	   ON pf.CD_PRO_FAT = er.EXA_RX_CD_PRO_FAT
LEFT JOIN DBAMV.EXA_LAB el	   ON pf.CD_PRO_FAT = el.CD_PRO_FAT
WHERE (ia.SN_REPASSADO IN ('S', 'N') OR ia.SN_REPASSADO IS NULL) AND ia.CD_GRU_FAT = 8
;



SELECT
    pf.CD_PRO_FAT,
    COALESCE(er.CD_EXA_RX, el.CD_EXA_LAB) AS CD_EXAMES,
    itf.CD_REG_FAT,
    itf.CD_PRESTADOR,
    itf.CD_ATI_MED,
    itf.CD_LANCAMENTO,
    pf.CD_GRU_PRO,
    itf.CD_GRU_FAT,
    rf.CD_CONVENIO,
    rf.CD_ATENDIMENTO,
    rf.CD_REMESSA,
    pf.DS_PRO_FAT,
    rf.DT_REMESSA,
    itf.DT_PRODUCAO,
    CAST('' AS DATE) AS DT_FECHAMENTO,
    itf.DT_LANCAMENTO,
    CAST('SEM' AS VARCHAR2(1)) AS SN_FECHADA,
    itf.SN_REPASSADO,
    itf.SN_PERTENCE_PACOTE,
    itf.VL_UNITARIO,
    itf.VL_TOTAL_CONTA,
    itf.VL_BASE_REPASSADO
FROM DBAMV.ITREG_FAT itf
LEFT JOIN DBAMV.PRO_FAT pf 	   ON itf.CD_PRO_FAT = pf.CD_PRO_FAT
LEFT JOIN DBAMV.REG_FAT rf 	   ON itf.CD_REG_FAT = rf.CD_REG_FAT
LEFT JOIN DBAMV.EXA_RX er  	   ON pf.CD_PRO_FAT = er.EXA_RX_CD_PRO_FAT
LEFT JOIN DBAMV.EXA_LAB el	   ON pf.CD_PRO_FAT = el.CD_PRO_FAT
WHERE (itf.SN_REPASSADO IN ('S', 'N') OR itf.SN_REPASSADO IS NULL) AND  itf.CD_GRU_FAT = 8
;


SELECT DISTINCT
    rf.cd_atendimento AS cod_atend,
    rf.cd_reg_fat AS conta,
	a.cd_paciente AS cod_paciente,
    p.nm_paciente AS nome_paciente,
    rf.sn_fechada AS sn_fechada,
    rf.dt_inicio AS dt_abertura,
    rf.dt_final AS dt_alta,
    rf.dt_fechamento AS dt_fechamento,
    rf.cd_remessa AS cod_remessa,
    rf.dt_remessa AS dt_remessa,
    f.dt_competencia,
    TO_CHAR(f.dt_competencia, 'MM/YYYY') AS competencia,
    rf.cd_convenio AS cod_convenio,
    c.nm_convenio AS nome_convenio,
    rf.vl_total_conta AS vl_total,
    CASE
        WHEN a.tp_atendimento = 'A' THEN 'AMBULATORIO'
        WHEN a.tp_atendimento = 'E' THEN 'EXAMES'
        WHEN a.tp_atendimento = 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN a.tp_atendimento = 'I' THEN 'INTERNACAO'
    END AS tipo,
	CASE
		WHEN rf.cd_convenio = '3' THEN
			'PARTICULAR'
		WHEN s.CD_SUB_PLANO = '200' OR s.CD_SUB_PLANO = '300' THEN
			s.ds_sub_plano
	    WHEN rf.cd_convenio = '1' AND ot.cd_ori_ate = '3' THEN
	    	'MUNICIPIO'
	    WHEN rf.cd_convenio = '1' AND ot.cd_ori_ate = '18' THEN
	    	'ESTADO'
	    WHEN s.CD_SUB_PLANO <> '200' OR s.CD_SUB_PLANO <> '300' THEN
	    	c.nm_convenio
		ELSE NVL(s.ds_sub_plano, c.nm_convenio)
	END AS SUB_PLANO
FROM
    dbamv.reg_fat rf
LEFT JOIN
    dbamv.atendime a ON rf.cd_atendimento = a.cd_atendimento
LEFT JOIN
	dbamv.ori_ate ot ON ot.cd_ori_ate = a.cd_ori_ate
LEFT JOIN
    dbamv.paciente p ON a.cd_paciente = p.cd_paciente
LEFT JOIN
    dbamv.remessa_fatura re ON rf.cd_remessa = re.cd_remessa
LEFT JOIN
    dbamv.fatura f ON re.cd_fatura = f.cd_fatura
LEFT JOIN
    dbamv.convenio c ON rf.cd_convenio = c.cd_convenio
LEFT JOIN
    dbamv.sub_plano s ON s.cd_convenio = c.cd_convenio AND s.cd_sub_plano = a.cd_sub_plano
WHERE rf.cd_atendimento IS NOT NULL
UNION ALL
SELECT DISTINCT
    ib.cd_atendimento AS cod_atend,
    rb.cd_reg_amb AS conta,
    a.cd_paciente AS cod_paciente,
    p.nm_paciente AS nome_paciente,
    rb.sn_fechada AS sn_fechada,
    a.dt_atendimento AS dt_abertura,
    a.dt_alta AS dt_alta,
    ib.dt_fechamento AS dt_fechamento,
    rb.cd_remessa AS cod_remessa,
    rb.dt_remessa AS dt_remessa,
    f.dt_competencia,
    TO_CHAR(f.dt_competencia, 'MM/YYYY') AS competencia,
    rb.cd_convenio AS cod_convenio,
    c.nm_convenio AS nome_convenio,
    rb.vl_total_conta AS vl_total,
    CASE
        WHEN a.tp_atendimento = 'A' THEN 'AMBULATORIO'
        WHEN a.tp_atendimento = 'E' THEN 'EXAMES'
        WHEN a.tp_atendimento = 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN a.tp_atendimento = 'I' THEN 'INTERNACAO'
    END AS tipo,
	CASE
		WHEN rb.cd_convenio = '3' THEN
			'PARTICULAR'
		WHEN s.CD_SUB_PLANO = '200' OR s.CD_SUB_PLANO = '300' THEN
			s.ds_sub_plano
	    WHEN rb.cd_convenio = '1' AND ot.cd_ori_ate = '3' THEN
	    	'MUNICIPIO'
	    WHEN rb.cd_convenio = '1' AND ot.cd_ori_ate = '18' THEN
	    	'ESTADO'
	    WHEN s.CD_SUB_PLANO <> '200' OR s.CD_SUB_PLANO <> '300' THEN
	    	c.nm_convenio
		ELSE NVL(s.ds_sub_plano, c.nm_convenio)
	END AS SUB_PLANO
FROM
    dbamv.reg_amb rb
LEFT JOIN
    dbamv.itreg_amb ib ON rb.cd_reg_amb = ib.cd_reg_amb
LEFT JOIN
    dbamv.atendime a ON ib.cd_atendimento = a.cd_atendimento
LEFT JOIN
	dbamv.ori_ate ot ON ot.cd_ori_ate = a.cd_ori_ate
LEFT JOIN
    dbamv.paciente p ON a.cd_paciente = p.cd_paciente
LEFT JOIN
    dbamv.remessa_fatura re ON rb.cd_remessa = re.cd_remessa
LEFT JOIN
    dbamv.fatura f ON re.cd_fatura = f.cd_fatura
LEFT JOIN
    dbamv.convenio c ON a.cd_convenio = c.cd_convenio
LEFT JOIN
    dbamv.sub_plano s ON a.cd_convenio = s.cd_convenio AND s.cd_sub_plano = a.cd_sub_plano
    WHERE ib.cd_atendimento IS NOT NULL