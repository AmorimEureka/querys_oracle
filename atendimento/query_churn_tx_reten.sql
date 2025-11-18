


-- QUERY FINAL COM OS EXAMES
WITH CONSULTA_FINAL
    AS(
        SELECT -- ATENDIDOS AGENDADOS
        a.cd_atendimento,
        'ATENDIDO AGENDADO' AS STATUS_ATENDIMENTO,
        a.DT_ATENDIMENTO,
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
        a.tp_atendimento,
        a.SN_OBITO
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
        a.DT_ATENDIMENTO,
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
        a.tp_atendimento,
        a.SN_OBITO
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

    cf.DT_ATENDIMENTO,
    cf.MES,
    cf.ANO,

    -- COALESCE(ra.HR_LANCAMENTO, rf.DT_LANCAMENTO) AS HR_LANCAMENTO,

    CASE cf.TP_ATENDIMENTO
        WHEN 'A' THEN 'AMBULATORIAL'
        WHEN 'E' THEN 'EXTERNO'
        WHEN 'U' THEN 'URGENCIA/EMERGENCIA'
        WHEN 'I' THEN 'INTERNACAO'
        ELSE 'Sem Correspondência'
    END AS TIPO_ATENDIMENTO,

    CASE WHEN cf.SN_OBITO = 'S' THEN 'OBITO' END AS OBITO,

    cf.NM_CONVENIO,
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
	-- cf.ANO = 2025 AND cf.MES = 9 AND
    cf.CD_ATENDIMENTO = 253399 AND
    COALESCE(rf.SN_PERTENCE_PACOTE, ra.SN_PERTENCE_PACOTE) = 'N'


ORDER BY cf.CD_ATENDIMENTO DESC

;

-- ******* R_LISTA_ATENDE_PERIODO *******

--           MV/QUERY

-- 09/2025 - 8004/8002 - 2+ [MV]
-- U       -  899/899  - ok
-- I       -  472/472  - ok
-- A       - 3335/3333 - 2
-- E       - 3298/3298 - ok

-- 08/2025 - 8445/8445 - ok

-- 07/2025 - 8887/8886 - 1+ [MV]
-- U       -  869/869  - ok
-- I       -  490/490  - ok
-- A       - 3777/3777 - ok
-- E       - 3693/3694 - 1

-- 06/2025 - 7926/7924 - 2+ [MV]
-- U       -  926/926  - ok
-- I       -  458/458  - ok
-- A       - 3275/3273 - 2
-- E       - 3324/3324 - ok

-- 05/2025 - 8173/8169 - 4+ [MV]
-- U       -  786/786  - ok
-- I       -  582/582  - ok
-- A       - 3390/3386 - 4
-- E       - 3415/3415 - ok

-- 04/2025 - 8182/8181 - 1+ [MV]
-- U       -  866/866  - ok
-- I       -  492/492  - ok
-- A       - 3612/3613 - 1
-- E       - 3212/3210 - 2

-- 03/2025 - 7790/7787 - 3+ [MV]
-- U       -  822/822  - ok
-- I       -  394/394  - ok
-- A       - 3384/3380 - 4
-- E       - 3190/3191 - 1

-- 02/2025 - 8129/8127 - 2+ [MV]
-- U       -  797/797  - ok
-- I       -  385/385  - ok
-- A       - 3445/3444 - 1
-- E       - 3502/3501 - 1

-- 01/2025 - 8885/8885 - ok



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
;



-- ################################################################################################



-- ####################################### VALIDAR COM RENATO #####################################

-- WITH FILTRO AS (
--     SELECT
--         {V_CODIGO_DA_REMESSA} AS CD_REMESSA
--     FROM DUAL
-- ),

WITH
-- Primeira parte: REG_FAT
Q_REG AS (
    SELECT DISTINCT
        ATENDIME.CD_ATENDIMENTO,
        GUIA.nr_guia,
        PACIENTE.nm_paciente,
        ATENDIME.nr_carteira,
        PRO_FAT.ds_pro_fat,
        PRO_FAT.cd_pro_fat,
        PRO_FAT.CD_GRU_PRO,
        REMESSA_FATURA.cd_remessa,
        REG_FAT.vl_total_conta,
        NULL AS cd_gru_fat, CONVENIO.CD_CONVENIO
    FROM
        DBAMV.ATENDIME,
        DBAMV.PACIENTE,
        DBAMV.CONVENIO,
        DBAMV.REG_FAT,
        DBAMV.ORI_ATE,
        DBAMV.REMESSA_FATURA,
        DBAMV.FATURA,
        DBAMV.GUIA,
        DBAMV.PRO_FAT,
        ITREG_FAT
        -- FILTRO
    WHERE
        ATENDIME.CD_PACIENTE  = PACIENTE.CD_PACIENTE
        AND ATENDIME.CD_ATENDIMENTO = REG_FAT.CD_ATENDIMENTO
        AND REG_FAT.CD_CONVENIO = CONVENIO.CD_CONVENIO
        AND REG_FAT.CD_REMESSA  = REMESSA_FATURA.CD_REMESSA
        AND REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
        AND ((REG_FAT.VL_TOTAL_CONTA > 0 AND REG_FAT.CD_CONTA_PAI IS NOT NULL)
             OR REG_FAT.CD_CONTA_PAI IS NULL)
        AND ATENDIME.CD_CONVENIO = GUIA.CD_CONVENIO(+)
        AND CONVENIO.CD_CONVENIO = REG_FAT.CD_CONVENIO
        AND ATENDIME.CD_ORI_ATE = ORI_ATE.CD_ORI_ATE
        AND ATENDIME.CD_ATENDIMENTO = GUIA.CD_ATENDIMENTO(+)
        AND REMESSA_FATURA.CD_AGRUPAMENTO IS NULL
        AND REG_FAT.CD_PRO_FAT_REALIZADO = PRO_FAT.CD_PRO_FAT(+)
        AND (GUIA.CD_GUIA IS NULL OR GUIA.CD_GUIA = (
                SELECT MIN(GUIA2.CD_GUIA)
                FROM DBAMV.GUIA GUIA2
                WHERE GUIA2.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO
                AND GUIA2.CD_CONVENIO = ATENDIME.CD_CONVENIO
        ))
        AND ITREG_FAT.CD_REG_FAT = REG_FAT.CD_REG_FAT
    --    AND ATENDIME.CD_ATENDIMENTO = :param
        AND REMESSA_FATURA.CD_REMESSA = :param -- FILTRO.CD_REMESSA
        AND ATENDIME.TP_ATENDIMENTO = 'E'
        AND ITREG_FAT.SN_PERTENCE_PACOTE = 'S'
),

-- Segunda parte: ITREG_AMB
Q_AMB AS (
    SELECT DISTINCT
        ATENDIME.CD_ATENDIMENTO,
        GUIA.nr_guia,
        PACIENTE.nm_paciente,
        ATENDIME.nr_carteira,
        PRO_FAT.ds_pro_fat,
        PRO_FAT.cd_pro_fat,
        PRO_FAT.CD_GRU_PRO,
        REMESSA_FATURA.cd_remessa,
        ITREG_AMB.vl_total_conta,
        ITREG_AMB.cd_gru_fat, ATENDIME.CD_CONVENIO
    FROM
        DBAMV.ATENDIME ATENDIME,
        DBAMV.PACIENTE PACIENTE,
        DBAMV.REG_AMB REG_AMB,
        DBAMV.ITREG_AMB ITREG_AMB,
        DBAMV.ORI_ATE ORI_ATE,
        DBAMV.REMESSA_FATURA REMESSA_FATURA,
        DBAMV.FATURA FATURA,
        DBAMV.GUIA GUIA,
        DBAMV.PRO_FAT
        -- FILTRO
    WHERE
        ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE
        AND ATENDIME.CD_ATENDIMENTO = ITREG_AMB.CD_ATENDIMENTO
        AND REG_AMB.CD_REG_AMB = ITREG_AMB.CD_REG_AMB
        AND ATENDIME.CD_ORI_ATE = ORI_ATE.CD_ORI_ATE
        AND REG_AMB.CD_REMESSA = REMESSA_FATURA.CD_REMESSA
        AND REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
        AND ATENDIME.CD_ATENDIMENTO = GUIA.CD_ATENDIMENTO(+)
        AND ITREG_AMB.CD_PRO_FAT = PRO_FAT.CD_PRO_FAT(+)
        AND (GUIA.CD_GUIA IS NULL OR GUIA.CD_GUIA = (
                SELECT MIN(GUIA2.CD_GUIA)
                FROM DBAMV.GUIA GUIA2
                WHERE GUIA2.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO
                AND GUIA2.CD_CONVENIO = ATENDIME.CD_CONVENIO
        ))
    --    AND ATENDIME.CD_ATENDIMENTO = :param
        AND REMESSA_FATURA.CD_REMESSA = :param --FILTRO.CD_REMESSA
        AND ATENDIME.TP_ATENDIMENTO = 'E'
        AND ITREG_AMB.SN_PERTENCE_PACOTE = 'S'
),

-- União final
UNIAO AS (
    SELECT * FROM Q_REG
    UNION ALL
    SELECT * FROM Q_AMB
)

-- Aqui entra o filtro condicional baseado em cd_gru_fat
SELECT
    U.*
FROM
    UNIAO U
WHERE
    -- (
    --     -- Se existir algum registro com cd_gru_fat = 8, mostra só os que têm 8
    --     EXISTS (SELECT 1 FROM UNIAO X WHERE X.cd_gru_fat = 8)
    --     AND U.cd_gru_fat = 8
    --     -- EXISTS (SELECT 1 FROM UNIAO X WHERE X.CD_GRU_PRO IN(10,30,34))
    --     -- AND U.CD_GRU_PRO IN(10,30,34)
    -- )
    -- OR
    -- (
        -- Se não existir nenhum cd_gru_fat = 8, mostra todos
        NOT EXISTS (SELECT 1 FROM UNIAO X WHERE X.cd_gru_fat = 8)
        -- NOT EXISTS (SELECT 1 FROM UNIAO X WHERE X.CD_GRU_PRO IN(10,30,34))
    -- )

;


-- ################################################################################################




-- EMERGENCIA
--  - 14875 - REMESSA

-- 253399 - ATENDIMENTO - MOACIR
--  - 40314618 - PROCEDIMENTO CORONA VIRUS


-- WITH FILTRO AS (
--     SELECT
--         {V_CODIGO_DA_REMESSA} AS CD_REMESSA
--     FROM DUAL
-- ),

WITH
-- Primeira parte: REG_FAT
Q_REG AS (
    SELECT DISTINCT
        ATENDIME.CD_ATENDIMENTO,
        GUIA.nr_guia,
        PACIENTE.nm_paciente,
        ATENDIME.nr_carteira,
        PRO_FAT.ds_pro_fat,
        PRO_FAT.cd_pro_fat,
        PRO_FAT.CD_GRU_PRO,
        REMESSA_FATURA.cd_remessa,
        REG_FAT.vl_total_conta
    FROM
        DBAMV.ATENDIME,
        DBAMV.PACIENTE,
        DBAMV.CONVENIO,
        DBAMV.REG_FAT,
        DBAMV.ORI_ATE,
        DBAMV.REMESSA_FATURA,
        DBAMV.FATURA,
        DBAMV.GUIA,
        DBAMV.PRO_FAT
        -- FILTRO
    WHERE
        ATENDIME.CD_PACIENTE  = PACIENTE.CD_PACIENTE
        AND ATENDIME.CD_ATENDIMENTO = REG_FAT.CD_ATENDIMENTO
        AND REG_FAT.CD_CONVENIO = CONVENIO.CD_CONVENIO
        AND REG_FAT.CD_REMESSA  = REMESSA_FATURA.CD_REMESSA
        AND REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
        AND ((REG_FAT.VL_TOTAL_CONTA > 0 AND REG_FAT.CD_CONTA_PAI IS NOT NULL)
             OR REG_FAT.CD_CONTA_PAI IS NULL)
        AND ATENDIME.CD_CONVENIO = GUIA.CD_CONVENIO(+)
        AND CONVENIO.CD_CONVENIO = REG_FAT.CD_CONVENIO
        AND ATENDIME.CD_ORI_ATE = ORI_ATE.CD_ORI_ATE
        AND ATENDIME.CD_ATENDIMENTO = GUIA.CD_ATENDIMENTO(+)
        AND REMESSA_FATURA.CD_AGRUPAMENTO IS NULL
        AND REG_FAT.CD_PRO_FAT_REALIZADO = PRO_FAT.CD_PRO_FAT(+)
        AND (GUIA.CD_GUIA IS NULL OR GUIA.CD_GUIA = (
                SELECT MIN(GUIA2.CD_GUIA)
                FROM DBAMV.GUIA GUIA2
                WHERE GUIA2.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO
                AND GUIA2.CD_CONVENIO = ATENDIME.CD_CONVENIO
        ))
    --    AND ATENDIME.CD_ATENDIMENTO = :param
        AND REMESSA_FATURA.CD_REMESSA = :param -- FILTRO.CD_REMESSA
        -- AND PRO_FAT.cd_pro_fat = 4031418
),

-- Segunda parte: ITREG_AMB
Q_AMB AS (
    SELECT DISTINCT
        ATENDIME.CD_ATENDIMENTO,
        GUIA.nr_guia,
        PACIENTE.nm_paciente,
        ATENDIME.nr_carteira,
        PRO_FAT.ds_pro_fat,
        PRO_FAT.cd_pro_fat,
        PRO_FAT.CD_GRU_PRO,
        REMESSA_FATURA.cd_remessa,
        ITREG_AMB.vl_total_conta
    FROM
        DBAMV.ATENDIME ATENDIME,
        DBAMV.PACIENTE PACIENTE,
        DBAMV.REG_AMB REG_AMB,
        DBAMV.ITREG_AMB ITREG_AMB,
        DBAMV.ORI_ATE ORI_ATE,
        DBAMV.REMESSA_FATURA REMESSA_FATURA,
        DBAMV.FATURA FATURA,
        DBAMV.GUIA GUIA,
        PRO_FAT
        -- FILTRO
    WHERE
        ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE
        AND ATENDIME.CD_ATENDIMENTO = ITREG_AMB.CD_ATENDIMENTO
        AND REG_AMB.CD_REG_AMB = ITREG_AMB.CD_REG_AMB
        AND ATENDIME.CD_ORI_ATE = ORI_ATE.CD_ORI_ATE
        AND REG_AMB.CD_REMESSA = REMESSA_FATURA.CD_REMESSA
        AND REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
        AND ATENDIME.CD_ATENDIMENTO = GUIA.CD_ATENDIMENTO(+)
        AND ITREG_AMB.CD_PRO_FAT = PRO_FAT.CD_PRO_FAT(+)
        AND (GUIA.CD_GUIA IS NULL OR GUIA.CD_GUIA = (
                SELECT MIN(GUIA2.CD_GUIA)
                FROM DBAMV.GUIA GUIA2
                WHERE GUIA2.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO
                AND GUIA2.CD_CONVENIO = ATENDIME.CD_CONVENIO
        ))
    --    AND ATENDIME.CD_ATENDIMENTO = :param
        AND REMESSA_FATURA.CD_REMESSA = :param --FILTRO.CD_REMESSA
        -- AND PRO_FAT.cd_pro_fat = 4031418
),

-- União final
UNIAO AS (
    SELECT * FROM Q_REG
    UNION ALL
    SELECT * FROM Q_AMB
)

-- Aqui entra o filtro condicional baseado em cd_gru_fat
SELECT
    U.*
FROM
    UNIAO U
WHERE
    (
        -- Se existir algum registro com cd_gru_fat = 8, mostra só os que têm 8
        -- EXISTS (SELECT 1 FROM UNIAO X WHERE X.cd_gru_fat = 8)
        -- AND U.cd_gru_fat = 8
        EXISTS (SELECT 1 FROM UNIAO X WHERE X.CD_GRU_PRO IN(10,30,34))
        AND U.CD_GRU_PRO IN(10,30,34)
    )
    OR
    (
        -- Se não existir nenhum cd_gru_fat = 8, mostra todos
        -- NOT EXISTS (SELECT 1 FROM UNIAO X WHERE X.cd_gru_fat = 8)
        NOT EXISTS (SELECT 1 FROM UNIAO X WHERE X.CD_GRU_PRO IN(10,30,34))
    )

;




/* ###################### RELATORIO DE GUIAS FUSMA ####################### */

-- M_REMESSA_FFCV
-- M_LAN_AMB_PARTICULAR
-- M_TUSS_FFCV



/* ############################# OCORRENCIAS #############################
 *
 * - CD_ATENDIMENTO: 238738
 *      - 2 CD_REMESSAS:
 *          - 14375 - 41001230  TC - ANGIOTOMOGRAFIA CORONARIANA [EXAME]
 *          - 13657 - 10805048  PS - ESPECIALIDADE CARDIOLOGIA   [CONSULTA]
 *      - ATENDIMENTO C/ CONSULTAS e EXAMES NA MESMA COMPETENCIA:
 *          - AGRUPA O VL_TOTAL_CONTA PELO PROCEDIMENTO DA CONSULTA
 *              - CODIGO PROCEDIMENTO DA CONSULTA
 *              - DESCRICAO CONSULTA
 *              - GUIA DA CONSULTA
 *              - CARTEIRA DA CONSULTA
 *      - ATENDIMENTO C/ CONSULTAS e EXAMES EM COMPETENCIAS DIFERENTES:
 *              - CODIGO PROCEDIMENTO DA CONSULTA ou EXAME
 *              - DESCRICAO CONSULTA ou EXAME
 *              - GUIA DA CONSULTA ou EXAME
 *              - CARTEIRA DA CONSULTA ou EXAME
 *
 * ########################################################################
 *
 *      - 2 PROCEDIMENTOS DE EXAMES NA SEGUNDA REMESSA:
 *              - RETORNA OS 2 PROCEDIMENTOS COM MESMA GUIA DE AUTORIZACAO ?
 *              - OU AGRUPA E RETORNA SÓ UM ?
 *
 * ########################################################################
 *
 *  - CD_PRO_FAT:
 *      - CD_REMESSA: 14764 -> CONSULTAS
 *          - 00040105 | 00040108 | 00040109
 *      - CD_REMESSA: 14050 -> EXAMES
 *          - 40901361
 *
 * ########################################################################
 *
 *  - CASOS COM N_GAU | NM_PACIENTE | NIP = NULL
 *      - PROCEDIMENTOS SEM GUIA EM ITREG_AMB/ITREG_FAT
 *      - POR NAO TER  CD_GUI O JOIN NAO RECUPERA OS DADOS DE ATENDIME
 *
*/

WITH CONSULTA_FINAL
    AS(
        SELECT
            a.CD_ATENDIMENTO,
            a.DT_ATENDIMENTO,
            EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
            EXTRACT(YEAR FROM  a.DT_ATENDIMENTO) AS ANO,
            a.CD_PACIENTE,
            p.NM_PACIENTE,
            a.TP_ATENDIMENTO,
            c.NM_CONVENIO,
            a.SN_OBITO,
            g.CD_GUIA,
            g.NR_GUIA,
            g.TP_GUIA,
            g.DT_AUTORIZACAO,
            a.NR_CARTEIRA
        FROM DBAMV.ATENDIME a
        JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
        JOIN DBAMV.CONVENIO c ON a.CD_CONVENIO = c.CD_CONVENIO
        JOIN DBAMV.GUIA     g ON a.CD_ATENDIMENTO = g.CD_ATENDIMENTO AND a.CD_CONVENIO = g.CD_CONVENIO
        WHERE
        -- (g.CD_GUIA IS NULL OR g.CD_GUIA = (
        --         SELECT MIN(GUIA.CD_GUIA)
        --         FROM DBAMV.GUIA GUIA
        --         WHERE GUIA.CD_ATENDIMENTO = a.CD_ATENDIMENTO
        --         AND GUIA.CD_CONVENIO = a.CD_CONVENIO
        -- ))
        g.NR_GUIA IS NOT NULL
),
REGRA_AMBULATORIO
    AS (
        SELECT
            ia.CD_ATENDIMENTO,
            CASE
                WHEN ia.CD_GRU_FAT = 8 THEN
                    COALESCE(FIRST_VALUE(CASE WHEN pf.CD_GRU_PRO = 0 THEN ia.CD_GUIA END) OVER (
                        PARTITION BY ia.CD_ATENDIMENTO
                        ORDER BY CASE WHEN pf.CD_GRU_PRO = 0 THEN 1 ELSE 2 END
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                    ), ia.CD_GUIA)
                WHEN ia.SN_PERTENCE_PACOTE = 'N' THEN
                    COALESCE(FIRST_VALUE(CASE WHEN ia.CD_GRU_FAT = 8 THEN ia.CD_GUIA END) OVER (
                        PARTITION BY ia.CD_ATENDIMENTO
                        ORDER BY CASE WHEN ia.CD_GRU_FAT = 8 THEN 1 ELSE 2 END
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                    ), ia.CD_GUIA)

                ELSE ia.CD_GUIA
            END AS CD_GUIA,
            ia.CD_REG_AMB,
            ra.CD_REMESSA,
            pf.CD_GRU_PRO,
            ia.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            ia.CD_CONVENIO,
            ia.SN_PERTENCE_PACOTE,
            ia.VL_TOTAL_CONTA,
            ia.TP_PAGAMENTO,
            'AMBULATORIO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_AMB ia
        LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
        LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
        -- WHERE ia.SN_REPASSADO IN ('S', 'N') OR ia.SN_REPASSADO IS NULL
        WHERE
            ra.CD_REMESSA = :param
            -- AND
            -- ia.CD_PRO_FAT = '40901361'
),
REGRA_FATURAMENTO
    AS (
        SELECT
            rf.CD_ATENDIMENTO,
                CASE
                    WHEN itf.CD_GRU_FAT = 8 THEN
                        COALESCE(FIRST_VALUE(CASE WHEN pf.CD_GRU_PRO = 0 THEN itf.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN pf.CD_GRU_PRO = 0 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), itf.CD_GUIA)
                    WHEN itf.SN_PERTENCE_PACOTE = 'N' THEN
                        COALESCE(FIRST_VALUE(CASE WHEN itf.CD_GRU_FAT = 8 THEN itf.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN itf.CD_GRU_FAT = 8 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), itf.CD_GUIA)

                    ELSE itf.CD_GUIA
                END AS CD_GUIA,
            itf.CD_REG_FAT,
            rf.CD_REMESSA,
            pf.CD_GRU_PRO,
            itf.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            rf.CD_CONVENIO,
            itf.SN_PERTENCE_PACOTE,
            itf.VL_TOTAL_CONTA,
            itf.TP_PAGAMENTO,
            'FATURAMENTO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_FAT itf
        LEFT JOIN DBAMV.PRO_FAT pf 	   ON itf.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_FAT rf 	   ON itf.CD_REG_FAT = rf.CD_REG_FAT
        LEFT JOIN DBAMV.PRESTADOR p    ON itf.CD_PRESTADOR = p.CD_PRESTADOR
        -- WHERE itf.SN_REPASSADO IN ('S', 'N') OR itf.SN_REPASSADO IS NULL
        WHERE
            rf.CD_REMESSA = :param
),
FILTRO
    AS (
        SELECT
            ra.CD_ATENDIMENTO,
            ra.CD_GUIA,

            ra.SN_PERTENCE_PACOTE,

            ra.DS_PRO_FAT AS PROCEDIMENTO,
            ra.CD_PRO_FAT AS CODIGO,

            ra.CD_CONVENIO,

            ra.RG_FATURAMENTO AS RG_FATURAMENTO,
            ra.VL_TOTAL_CONTA  AS VL_TOTAL_CONTA,

            CASE WHEN ra.CD_PRO_FAT = '10805048' THEN 1 END UNI,

            ROW_NUMBER() OVER ( PARTITION BY
                    ra.CD_ATENDIMENTO
                ORDER BY ra.CD_GUIA
            ) AS RW

        FROM REGRA_AMBULATORIO ra
        -- LEFT JOIN CONSULTA_FINAL cf ON cf.CD_ATENDIMENTO = ra.CD_ATENDIMENTO AND ra.CD_GUIA IS NOT NULL
        WHERE ra.SN_PERTENCE_PACOTE = 'N'

        UNION ALL

        SELECT
            rf.CD_ATENDIMENTO,
            rf.CD_GUIA,

            rf.SN_PERTENCE_PACOTE,

            rf.DS_PRO_FAT AS PROCEDIMENTO,
            rf.CD_PRO_FAT AS CODIGO,

            rf.CD_CONVENIO,

            rf.RG_FATURAMENTO AS RG_FATURAMENTO,
            rf.VL_TOTAL_CONTA  AS VL_TOTAL_CONTA,

            CASE WHEN rf.CD_PRO_FAT = '10805048' THEN 1 END UNI,

            ROW_NUMBER() OVER ( PARTITION BY
                    rf.CD_ATENDIMENTO
                ORDER BY rf.CD_GUIA
            ) AS RW

        FROM REGRA_FATURAMENTO rf
        -- LEFT JOIN CONSULTA_FINAL cf ON cf.CD_ATENDIMENTO = rf.CD_ATENDIMENTO AND rf.CD_GUIA IS NOT NULL
        WHERE rf.SN_PERTENCE_PACOTE = 'N'
),
TUSS_TAO
    AS (
        SELECT
            CD_PRO_FAT,
            CD_TUSS,
            CD_CONVENIO
        FROM DBAMV.TUSS
        -- WHERE CD_PRO_FAT = '40901360'
),
TREATS
    AS (
        SELECT
            f.CD_ATENDIMENTO,
            cf.NR_GUIA AS N_GAU,
            cf.NM_PACIENTE,

            cf.NR_CARTEIRA  AS NIP,

            f.PROCEDIMENTO,

            COALESCE(t.CD_TUSS, f.CODIGO) AS CODIGO,

            f.UNI,
            f.RW,

            CASE WHEN f.SN_PERTENCE_PACOTE = 'N' THEN
                SUM(f.VL_TOTAL_CONTA) OVER ( PARTITION BY f.CD_ATENDIMENTO )
            ELSE
                SUM(f.VL_TOTAL_CONTA) OVER ( PARTITION BY f.CD_ATENDIMENTO, cf.NR_GUIA )
            END AS VL_TOTAL_CONTA

        FROM FILTRO    f
        LEFT JOIN CONSULTA_FINAL cf  ON cf.CD_ATENDIMENTO = f.CD_ATENDIMENTO AND cf.CD_GUIA = f.CD_GUIA
        LEFT JOIN TUSS_TAO t ON f.CODIGO = t.CD_PRO_FAT AND f.CD_CONVENIO = t.CD_CONVENIO
)
SELECT
    *
FROM TREATS
WHERE RW = 1



;