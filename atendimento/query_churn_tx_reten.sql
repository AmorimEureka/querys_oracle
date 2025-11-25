


-- QUERY FINAL COM OS EXAMES
-- WITH CONSULTA_FINAL
--     AS(
--         SELECT -- ATENDIDOS AGENDADOS
--         a.cd_atendimento,
--         'ATENDIDO AGENDADO' AS STATUS_ATENDIMENTO,
--         a.DT_ATENDIMENTO,
--         EXTRACT(MONTH FROM agen.hr_agenda) AS MES,
--         EXTRACT(YEAR FROM agen.hr_agenda) AS ANO,
--         a.cd_paciente,
--         pa.nm_paciente,
--         c.cd_convenio,
--         c.nm_convenio,
--         a.cd_prestador,
--         p.nm_prestador,
--             CASE
--                 WHEN agen.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
--                     AND st.cd_setor NOT IN (117,137)
--                     AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
--                     'CLINICA 2'
--                 WHEN agen.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
--                     AND st.cd_setor NOT IN (117, 137)
--                     AND st.nm_setor LIKE '%2%'
--                     AND st.nm_setor NOT IN ('POSTO 2', 'UTI 2') THEN
--                     'CLINICA 2'
--                 WHEN agen.hr_agenda >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
--                     AND st.cd_setor IN (117, 137) THEN
--                     'CLINICA 2'
--                 ELSE
--                     'CLINICA 1'
--             END AS CLINICAS,
--         a.tp_atendimento,
--         a.SN_OBITO
--         FROM DBAMV.ATENDIME a
--         LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
--         LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR
--         LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
--         LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
--         LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
--         LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
--         LEFT JOIN (
--             SELECT
--             i.cd_atendimento,
--             i.hr_agenda,
--             i.cd_agenda_central,
--             i.ds_observacao_geral,
--             i.cd_item_agendamento,
--             i.dh_presenca_falta,
--             r.cd_recurso_central,
--             r.ds_recurso_central,
--             DECODE(a.TP_AGENDA,'L','LABORATORIO','I', 'IMAGEM','A', 'AMBULATORIO' ) AS TIPO_AGENDA,
--             a.qt_atendimento,
--             a.qt_marcados,
--             i.cd_usuario,
--             u.nm_usuario,
--             i.cd_tip_mar,
--             tr.ds_tip_mar
--             FROM DBAMV.IT_AGENDA_CENTRAL i
--             LEFT JOIN DBAMV.AGENDA_CENTRAL a    	   ON i.cd_agenda_central   = a.cd_agenda_central
--             LEFT JOIN DBAMV.ITEM_AGENDAMENTO ia 	   ON i.cd_item_agendamento = ia.cd_item_agendamento
--             LEFT JOIN DBAMV.SETOR s             	   ON s.cd_setor            = a.cd_setor
--             LEFT JOIN DBAMV.PRESTADOR pr        	   ON pr.cd_prestador       = a.cd_prestador
--             LEFT JOIN DBAMV.convenio c          	   ON c.cd_convenio         = i.cd_convenio
--             LEFT JOIN DBASGU.USUARIOS u         	   ON u.cd_usuario          = i.cd_usuario
--             LEFT JOIN DBAMV.RECURSO_CENTRAL r   	   ON r.cd_recurso_central  = a.cd_recurso_central
--             LEFT JOIN DBAMV.TIP_MAR tr          	   ON tr.cd_tip_mar         = i.cd_tip_mar
--             WHERE i.cd_atendimento  IS NOT NULL AND i.cd_it_agenda_pai IS NULL AND
--             EXISTS ( SELECT 1 FROM DBAMV.ATENDIME ate WHERE i.cd_atendimento = ate.cd_atendimento )
--         ) agen                                     ON a.CD_ATENDIMENTO      = agen.CD_ATENDIMENTO
--         LEFT JOIN DBAMV.SETOR st				   ON s.CD_SETOR            =   st.CD_SETOR
--         WHERE EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )
--         UNION ALL
--         SELECT -- ATENDIDOS NÃO AGENDADOS
--         a.cd_atendimento,
--         'ATENDIDO NÃO AGENDADO' AS STATUS_ATENDIMENTO,
--         a.DT_ATENDIMENTO,
--         EXTRACT(MONTH FROM a.dt_atendimento) AS MES,
--         EXTRACT(YEAR FROM a.dt_atendimento) AS ANO,
--         a.cd_paciente,
--         pa.nm_paciente,
--         c.cd_convenio,
--         c.nm_convenio,
--         a.cd_prestador,
--         p.nm_prestador,
--             CASE
--                 WHEN a.dt_atendimento >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
--                     AND st.cd_setor NOT IN (117,137)
--                     AND a.cd_prestador IN ('245', '268', '277', '318', '366', '372', '619', '645', '655', '682', '747', '762', '787', '874', '925', '945', '960') THEN
--                     'CLINICA 2'
--                 WHEN a.dt_atendimento >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
--                     AND st.cd_setor NOT IN (117, 137)
--                     AND st.nm_setor LIKE '%2%'
--                     AND st.nm_setor NOT IN ('POSTO 2', 'UTI 2') THEN
--                     'CLINICA 2'
--                 WHEN a.dt_atendimento >= TO_TIMESTAMP('2024-05-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
--                 AND  st.cd_setor IN (117, 137) THEN
--                     'CLINICA 2'
--                 ELSE
--                     'CLINICA 1'
--             END AS CLINICAS,
--         a.tp_atendimento,
--         a.SN_OBITO
--         FROM DBAMV.ATENDIME a
--         LEFT JOIN DBAMV.PACIENTE pa                ON a.cd_paciente         = pa.cd_paciente
--         LEFT JOIN DBAMV.PRESTADOR p                ON a.cd_prestador        = p.CD_PRESTADOR
--         LEFT JOIN DBAMV.CONVENIO c                 ON a.cd_convenio         = c.cd_convenio
--         LEFT JOIN DBAMV.ORI_ATE s                  ON a.cd_ori_ate          = s.cd_ori_ate
--         LEFT JOIN DBAMV.TIP_MAR t                  ON a.cd_tip_mar          = t.cd_tip_mar
--         LEFT JOIN DBAMV.ESPECIALID ia              ON a.cd_especialid       = ia.cd_especialid
--         LEFT JOIN DBAMV.SETOR st				   ON s.CD_SETOR            = st.CD_SETOR
--         WHERE NOT EXISTS ( SELECT 1 FROM DBAMV.IT_AGENDA_CENTRAL iac WHERE a.cd_atendimento = iac.cd_atendimento )

        -- SELECT
        --     a.CD_ATENDIMENTO,
        --     EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
        --     EXTRACT(YEAR FROM  a.DT_ATENDIMENTO) AS ANO,
        --     a.CD_PACIENTE,
        --     p.NM_PACIENTE,
        --     a.TP_ATENDIMENTO
        -- FROM DBAMV.ATENDIME a
        -- JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
-- )




WITH JN_PARAMETRO
    AS (
        SELECT
            :param AS CD_ATENDIMENTO
        FROM DUAL
)
SELECT
    a.CD_ATENDIMENTO,
    a.DT_ATENDIMENTO,
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
JOIN DBAMV.PACIENTE p       ON a.CD_PACIENTE    = p.CD_PACIENTE
JOIN DBAMV.CONVENIO c       ON a.CD_CONVENIO    = c.CD_CONVENIO
JOIN DBAMV.GUIA     g       ON a.CD_ATENDIMENTO = g.CD_ATENDIMENTO AND a.CD_CONVENIO = g.CD_CONVENIO
LEFT JOIN DBAMV.ORI_ATE s   ON a.cd_ori_ate     = s.cd_ori_ate
LEFT JOIN DBAMV.SETOR st	ON s.CD_SETOR       = st.CD_SETOR
CROSS JOIN JN_PARAMETRO par
WHERE
    a.CD_ATENDIMENTO = par.CD_ATENDIMENTO AND
    g.NR_GUIA IS NOT NULL
;















WITH
--     JN_PARAMETRO
--     AS (
--         SELECT
--             :param AS CD_ATENDIMENTO
--             -- :param AS PERIODO
--         FROM DUAL
-- ),
JN_ATENDIMENTO
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            a.DT_ATENDIMENTO,
            TO_CHAR(a.DT_ATENDIMENTO, 'MM/YYYY') AS MES_ANO,
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
            EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
            EXTRACT(YEAR FROM  a.DT_ATENDIMENTO) AS ANO,
            a.CD_PACIENTE,
            p.NM_PACIENTE,
            a.TP_ATENDIMENTO,
            c.NM_CONVENIO,
            a.SN_OBITO,

            a.NR_CARTEIRA
        FROM DBAMV.ATENDIME a
        JOIN DBAMV.PACIENTE p       ON a.CD_PACIENTE    = p.CD_PACIENTE
        JOIN DBAMV.CONVENIO c       ON a.CD_CONVENIO    = c.CD_CONVENIO

        JOIN DBAMV.ORI_ATE s   ON a.cd_ori_ate     = s.cd_ori_ate
        JOIN DBAMV.SETOR st	ON s.CD_SETOR       = st.CD_SETOR
        -- CROSS JOIN JN_PARAMETRO par
        WHERE
            -- a.CD_ATENDIMENTO = par.CD_ATENDIMENTO
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) IN(EXTRACT(YEAR FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE)-1)
            -- TO_CHAR(a.DT_ATENDIMENTO, 'MM/YYYY') = par.PERIODO
),
JN_REGRA_AMBULATORIO
    AS (
        SELECT
            ia.CD_ATENDIMENTO,
            ia.CD_REG_AMB,
            ra.CD_REMESSA,
            pf.CD_GRU_PRO,
            ia.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            ia.CD_CONVENIO,
            ia.SN_PERTENCE_PACOTE,
            ia.QT_LANCAMENTO,
            ia.VL_TOTAL_CONTA,
            ia.TP_PAGAMENTO,
            p.NM_PRESTADOR,
            'AMBULATORIO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_AMB ia
        LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
        LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
        -- CROSS JOIN JN_PARAMETRO par
        -- WHERE ia.CD_ATENDIMENTO = par.CD_ATENDIMENTO
),
JN_REGRA_HOSPITALAR
    AS (
        SELECT
            rf.CD_ATENDIMENTO,
            ift.CD_REG_FAT,
            rf.CD_REMESSA,
            pf.CD_GRU_PRO,
            ift.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            rf.CD_CONVENIO,
            ift.SN_PERTENCE_PACOTE,
            ift.QT_LANCAMENTO,
            ift.VL_TOTAL_CONTA,
            ift.TP_PAGAMENTO,
            p.NM_PRESTADOR,
            'FATURAMENTO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_FAT ift
        LEFT JOIN DBAMV.PRO_FAT pf 	   ON ift.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_FAT rf 	   ON ift.CD_REG_FAT = rf.CD_REG_FAT
        LEFT JOIN DBAMV.PRESTADOR p    ON ift.CD_PRESTADOR = p.CD_PRESTADOR
        -- CROSS JOIN JN_PARAMETRO par
        -- WHERE rf.CD_ATENDIMENTO = par.CD_ATENDIMENTO
),
JN_UNION_REGRAS
    AS (
        SELECT
            ra.CD_ATENDIMENTO,
            ra.CD_REMESSA,
            ra.CD_GRU_FAT,

            ra.SN_PERTENCE_PACOTE,

            ra.DS_PRO_FAT AS PROCEDIMENTO,
            ra.CD_PRO_FAT AS CODIGO,

            ra.CD_CONVENIO,
            ra.TP_PAGAMENTO,

            ra.RG_FATURAMENTO,
            ra.VL_TOTAL_CONTA,
            ra.NM_PRESTADOR,

            SUM(ra.QT_LANCAMENTO) AS QTD


        FROM JN_REGRA_AMBULATORIO ra
        WHERE
            ra.SN_PERTENCE_PACOTE = 'N' AND
            ra.CD_REMESSA IS NOT NULL
        GROUP BY
            ra.CD_ATENDIMENTO,
            ra.CD_REMESSA,
            ra.CD_GRU_FAT,

            ra.SN_PERTENCE_PACOTE,

            ra.DS_PRO_FAT,
            ra.CD_PRO_FAT,

            ra.CD_CONVENIO,
            ra.TP_PAGAMENTO,

            ra.RG_FATURAMENTO,
            ra.VL_TOTAL_CONTA,
            ra.NM_PRESTADOR

        UNION ALL

        SELECT
            rh.CD_ATENDIMENTO,
            rh.CD_REMESSA,
            rh.CD_GRU_FAT,

            rh.SN_PERTENCE_PACOTE,

            rh.DS_PRO_FAT AS PROCEDIMENTO,
            rh.CD_PRO_FAT AS CODIGO,

            rh.CD_CONVENIO,
            rh.TP_PAGAMENTO,

            rh.RG_FATURAMENTO,
            rh.VL_TOTAL_CONTA,
            rh.NM_PRESTADOR,

            SUM(rh.QT_LANCAMENTO) AS QTD

        FROM JN_REGRA_HOSPITALAR rh
        WHERE
            rh.SN_PERTENCE_PACOTE = 'N' AND
            rh.CD_REMESSA IS NOT NULL
        GROUP BY
            rh.CD_ATENDIMENTO,
            rh.CD_REMESSA,
            rh.CD_GRU_FAT,

            rh.SN_PERTENCE_PACOTE,

            rh.DS_PRO_FAT,
            rh.CD_PRO_FAT,

            rh.CD_CONVENIO,
            rh.TP_PAGAMENTO,

            rh.RG_FATURAMENTO,
            rh.VL_TOTAL_CONTA,
            rh.NM_PRESTADOR
),
JN_TUSS
    AS (
        SELECT
            CD_PRO_FAT,
            CD_TUSS,
            CD_CONVENIO
        FROM DBAMV.TUSS
),
TREATS
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            a.MES,
            a.ANO,

            CASE a.TP_ATENDIMENTO
                WHEN 'A' THEN 'AMBULATORIAL'
                WHEN 'E' THEN 'EXTERNO'
                WHEN 'U' THEN 'URGENCIA/EMERGENCIA'
                WHEN 'I' THEN 'INTERNACAO'
                ELSE 'Sem Correspondência'
            END AS TIPO_ATENDIMENTO,

            a.CLINICAS,

            a.NM_CONVENIO,

            CASE
                WHEN ur.CODIGO = 'X0000000' THEN
                    'SUS'
                WHEN ur.TP_PAGAMENTO = 'P' OR ur.TP_PAGAMENTO IS NULL THEN
                    'PRODUCAO'
                WHEN ur.TP_PAGAMENTO = 'C' THEN
                    'COOPERATIVA'
                ELSE 'OUTROS'
            END AS TP_FATURAMENTO,

            a.NM_PACIENTE,
            CASE WHEN a.SN_OBITO = 'S' THEN 'OBITO' END AS OBITO,

            ur.NM_PRESTADOR AS PRESTADOR,

            CASE
                WHEN ur.CD_GRU_FAT IN(3,5,10) THEN
                    'MEDICAMENTOS'
                WHEN ur.CD_GRU_FAT = 1 THEN
                    'DIARIAS'
                WHEN ur.CD_GRU_FAT = 2 THEN
                    'TAXAS'
                WHEN ur.CD_GRU_FAT = 4 THEN
                    'MATERIAIS'
                WHEN ur.CD_GRU_FAT = 8 THEN
                    'PACOTE'
                WHEN ur.CD_GRU_FAT = 7 AND a.TP_ATENDIMENTO = 'I' THEN
                    'PROCEDIMENTO_MED'
                WHEN ur.CD_GRU_FAT = 7 AND a.TP_ATENDIMENTO IN('A', 'U') THEN
                    'CONSULTA'
                WHEN ur.CD_GRU_FAT = 6 AND a.TP_ATENDIMENTO = 'A'  THEN
                    'EXAMES'
                WHEN ur.CD_GRU_FAT IN(6, 7) AND a.TP_ATENDIMENTO IN('I', 'E', 'U') THEN
                    'EXAMES'
                ELSE 'OUTROS'
            END AS PROCEDIMENTO_FATURADO,

            COALESCE(t.CD_TUSS, ur.CODIGO) AS CODIGO,
            ur.PROCEDIMENTO,
            ur.QTD,
            ur.VL_TOTAL_CONTA

        FROM JN_ATENDIMENTO a
        LEFT JOIN JN_UNION_REGRAS ur  ON a.CD_ATENDIMENTO = ur.CD_ATENDIMENTO
        LEFT JOIN JN_TUSS t ON ur.CODIGO = t.CD_PRO_FAT AND ur.CD_CONVENIO = t.CD_CONVENIO

        WHERE
            ur.SN_PERTENCE_PACOTE = 'N'
        ORDER BY a.CD_ATENDIMENTO DESC
)
SELECT
    *
FROM TREATS
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
-- ################################################################################################