
-- "Serviços da Conta" + "Dados da Conta" da tela "M_LAN_HOS" e "M_LAN_AMB_PARTICULAR"

WITH FILTRO AS (
    SELECT
        :param_atend  AS param_atendimento

    FROM DUAL
),
CENTRAL
    AS (
        SELECT
            *
        FROM (
                SELECT
                    ROWNUM AS recnum,
                    t.*
                FROM (
                    SELECT
                        *
                    FROM (
                            SELECT
                                it.cd_reg_fat AS cd_reg,
                                it.cd_lancamento,
                                rf.cd_atendimento,
                                a.cd_paciente,
                                p.nm_paciente,
                                rf.cd_remessa,
                                rf.cd_regra,
                                r.ds_regra,
                                rf.cd_convenio,
                                c.nm_convenio,
                                it.cd_gru_fat,
                                gf.ds_gru_fat,
                                it.cd_pro_fat,
                                pf.ds_pro_fat AS descricao,
                                g.nr_guia,
                                g.cd_senha,
                                a.dt_atendimento,
                                a.dt_alta,
                                rf.dt_remessa,
                                rf.dt_fechamento,
                                it.dt_lancamento,
                                it.hr_lancamento,
                                it.cd_prestador,
                                pr.nm_prestador,
                                rf.sn_fechada,
                                it.sn_pertence_pacote,
                                it.qt_lancamento,
                                it.vl_unitario,
                                it.vl_total_conta,
                                it.vl_honorario_unitario,
                                it.vl_acrescimo,
                                it.vl_desconto,
                                it.cd_ati_med,
                                am.ds_ati_med,
                                it.cd_usuario,
                                u.nm_usuario,
CASE
    WHEN a.tp_atendimento = 'A' THEN 'Ambulatório'
    WHEN a.tp_atendimento = 'E' THEN 'Externo'
    WHEN a.tp_atendimento = 'U' THEN 'Urgência'
    WHEN a.tp_atendimento = 'I' THEN 'Internação'
    ELSE NULL
END AS tp_atendimento,
                                TO_DATE(
                                    TO_CHAR(it.dt_lancamento, 'DD/MM/YYYY') ||
                                    TO_CHAR(it.hr_lancamento, 'HH24:MI:SS'),
                                    'DD/MM/YYYYHH24:MI:SS'
                                ) AS dt_ordenacao
                            FROM dbamv.itreg_fat it
                            LEFT JOIN dbamv.reg_fat rf      ON it.cd_reg_fat     = rf.cd_reg_fat
                            LEFT JOIN dbamv.pro_fat pf      ON it.cd_pro_fat     = pf.cd_pro_fat
                            LEFT JOIN dbamv.gru_fat gf      ON it.cd_gru_fat     = gf.cd_gru_fat
                            LEFT JOIN dbamv.prestador pr    ON it.cd_prestador   = pr.cd_prestador
                            LEFT JOIN dbamv.ati_med am      ON it.cd_ati_med     = am.cd_ati_med
                            LEFT JOIN dbasgu.usuarios u     ON it.cd_usuario     =  u.cd_usuario
                            LEFT JOIN dbamv.atendime a      ON rf.cd_atendimento = a.cd_atendimento
                            LEFT JOIN dbamv.convenio c      ON rf.cd_convenio    =  c.cd_convenio
                            LEFT JOIN dbamv.guia g          ON it.cd_guia         = g.cd_guia
                            LEFT JOIN dbamv.regra r         ON rf.cd_regra       =  r.cd_regra
                            LEFT JOIN dbamv.paciente p      ON a.cd_paciente     = p.cd_paciente
                            CROSS JOIN FILTRO f
                            WHERE
                                rf.cd_atendimento = f.param_atendimento

                            UNION ALL

                            SELECT
                                ia.cd_reg_amb AS cd_reg,
                                ia.cd_lancamento,
                                ia.cd_atendimento,
                                a.cd_paciente,
                                p.nm_paciente,
                                ra.cd_remessa,
                                ra.cd_regra,
                                r.ds_regra,
                                ra.cd_convenio,
                                c.nm_convenio,
                                ia.cd_gru_fat,
                                gf.ds_gru_fat,
                                ia.cd_pro_fat,
                                pf.ds_pro_fat AS descricao,
                                g.nr_guia,
                                g.cd_senha,
                                a.dt_atendimento,
                                a.dt_alta,
                                ra.dt_remessa,
                                ia.dt_fechamento,
                                ra.dt_lancamento_final AS dt_lancamento,
                                ia.hr_lancamento,
                                ia.cd_prestador,
                                pr.nm_prestador,
                                ia.sn_fechada,
                                ia.sn_pertence_pacote,
                                ia.qt_lancamento,
                                ia.vl_unitario,
                                ia.vl_total_conta,
                                ia.vl_honorario_unitario,
                                ia.vl_acrescimo,
                                ia.vl_desconto,
                                ia.cd_ati_med,
                                am.ds_ati_med,
                                ia.cd_usuario,
                                ia.nm_usuario,
CASE
    WHEN a.tp_atendimento = 'A' THEN 'Ambulatório'
    WHEN a.tp_atendimento = 'E' THEN 'Externo'
    WHEN a.tp_atendimento = 'U' THEN 'Urgência'
    WHEN a.tp_atendimento = 'I' THEN 'Internação'
    ELSE NULL
END AS tp_atendimento,
                                TO_DATE(
                                    TO_CHAR(ra.dt_lancamento_final, 'DD/MM/YYYY') ||
                                    TO_CHAR(ia.hr_lancamento, 'HH24:MI:SS'),
                                    'DD/MM/YYYYHH24:MI:SS'
                                ) AS dt_ordenacao
                            FROM dbamv.itreg_amb ia
                            LEFT JOIN dbamv.reg_amb ra      ON ia.cd_reg_amb     = ra.cd_reg_amb
                            LEFT JOIN dbamv.pro_fat pf      ON ia.cd_pro_fat     = pf.cd_pro_fat
                            LEFT JOIN dbamv.gru_fat gf      ON ia.cd_gru_fat     = gf.cd_gru_fat
                            LEFT JOIN dbamv.prestador pr    ON ia.cd_prestador   = pr.cd_prestador
                            LEFT JOIN dbamv.ati_med am      ON ia.cd_ati_med     = am.cd_ati_med
                            LEFT JOIN dbasgu.usuarios u     ON ia.cd_usuario     =  u.cd_usuario
                            LEFT JOIN dbamv.atendime a      ON ia.cd_atendimento = a.cd_atendimento
                            LEFT JOIN dbamv.convenio c      ON ra.cd_convenio    =  c.cd_convenio
                            LEFT JOIN dbamv.guia g          ON ia.cd_guia         = g.cd_guia
                            LEFT JOIN dbamv.regra r         ON ra.cd_regra       =  r.cd_regra
                            LEFT JOIN dbamv.paciente p      ON a.cd_paciente     = p.cd_paciente
                            CROSS JOIN FILTRO f
                            WHERE
                                ia.cd_atendimento = f.param_atendimento
                    )
                    ORDER BY sn_pertence_pacote ASC, dt_ordenacao
                ) t
                -- WHERE
                --     ROWNUM <= :param_Max
        )
        -- WHERE
        --     recnum >= :param_Min
)
SELECT
    *
FROM CENTRAL
;



SELECT
    *
FROM (
        SELECT
            it.cd_reg_fat AS cd_reg,
            it.cd_lancamento,
            rf.cd_atendimento,
            a.cd_paciente,
            p.nm_paciente,
            rf.cd_remessa,
            rf.cd_regra,
            r.ds_regra,
            rf.cd_convenio,
            -- c.nm_convenio,
            CASE
                WHEN rf.cd_convenio = 3 THEN 'PARTICULAR'
                WHEN s.cd_sub_plano IN ('200', '300') THEN 'SUS - INTERNACAO (' || s.ds_sub_plano || ')'
                WHEN rf.cd_convenio = 1 AND ot.cd_ori_ate = 3 THEN 'SUS - INTERNACAO (MUNICIPIO)'
                WHEN rf.cd_convenio = 1 AND ot.cd_ori_ate = 18 THEN 'SUS - INTERNACAO (ESTADO)'
                ELSE c.nm_convenio
            END nm_convenio,
            it.cd_gru_fat,
            gf.ds_gru_fat,
            it.cd_pro_fat,
            pf.ds_pro_fat AS descricao,
            it.cd_guia,
            f.dt_competencia,
            it.dt_lancamento,
            it.hr_lancamento,
            it.cd_prestador,
            pr.nm_prestador,
            it.sn_pertence_pacote,
            it.vl_unitario,
            it.vl_total_conta,
            it.vl_honorario_unitario,
            it.vl_acrescimo,
            it.vl_desconto,
            it.cd_ati_med,
            am.ds_ati_med,
            it.cd_usuario,
            u.nm_usuario,
            a.tp_atendimento,
            TO_DATE(
                TO_CHAR(it.dt_lancamento, 'DD/MM/YYYY') ||
                TO_CHAR(it.hr_lancamento, 'HH24:MI:SS'),
                'DD/MM/YYYYHH24:MI:SS'
            ) AS dt_ordenacao
        FROM dbamv.itreg_fat it
        LEFT JOIN dbamv.reg_fat rf        ON it.cd_reg_fat     = rf.cd_reg_fat
        LEFT JOIN dbamv.pro_fat pf        ON it.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf        ON it.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr      ON it.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am        ON it.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u       ON it.cd_usuario     = u.cd_usuario
        LEFT JOIN dbamv.atendime a        ON rf.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c        ON rf.cd_convenio    = c.cd_convenio
        LEFT JOIN dbamv.regra r           ON rf.cd_regra       = r.cd_regra
        LEFT JOIN dbamv.remessa_fatura re ON rf.cd_remessa     = re.cd_remessa
        LEFT JOIN dbamv.fatura f          ON re.cd_fatura      = f.cd_fatura
        LEFT JOIN dbamv.paciente p        ON a.cd_paciente     = p.cd_paciente
        LEFT JOIN dbamv.ori_ate ot        ON a.cd_ori_ate      = ot.cd_ori_ate
        LEFT JOIN dbamv.sub_plano s       ON s.cd_convenio     = a.cd_convenio
                                         AND s.cd_con_pla      = rf.cd_con_pla
                                         AND s.cd_sub_plano    = a.cd_sub_plano

        UNION ALL

        SELECT
            ia.cd_reg_amb AS cd_reg,
            ia.cd_lancamento,
            ia.cd_atendimento,
            a.cd_paciente,
            p.nm_paciente,
            ra.cd_remessa,
            ra.cd_regra,
            r.ds_regra,
            ra.cd_convenio,
            -- c.nm_convenio,
            CASE
                WHEN ra.cd_convenio = 3 THEN 'PARTICULAR'
                WHEN s.cd_sub_plano IN ('200', '300') THEN 'SUS - INTERNACAO (' || s.ds_sub_plano || ')'
                WHEN ra.cd_convenio = 1 AND ot.cd_ori_ate = 3 THEN 'SUS - INTERNACAO (MUNICIPIO)'
                WHEN ra.cd_convenio = 1 AND ot.cd_ori_ate = 18 THEN 'SUS - INTERNACAO (ESTADO)'
                ELSE c.nm_convenio
            END nm_convenio,
            ia.cd_gru_fat,
            gf.ds_gru_fat,
            ia.cd_pro_fat,
            pf.ds_pro_fat AS descricao,
            ia.cd_guia,
            f.dt_competencia,
            ra.dt_lancamento_final AS dt_lancamento,
            ia.hr_lancamento,
            ia.cd_prestador,
            pr.nm_prestador,
            ia.sn_pertence_pacote,
            ia.vl_unitario,
            ia.vl_total_conta,
            ia.vl_honorario_unitario,
            ia.vl_acrescimo,
            ia.vl_desconto,
            ia.cd_ati_med,
            am.ds_ati_med,
            ia.cd_usuario,
            ia.nm_usuario,
            a.tp_atendimento,
            TO_DATE(
                TO_CHAR(ra.dt_lancamento_final, 'DD/MM/YYYY') ||
                TO_CHAR(ia.hr_lancamento, 'HH24:MI:SS'),
                'DD/MM/YYYYHH24:MI:SS'
            ) AS dt_ordenacao
        FROM dbamv.itreg_amb ia
        LEFT JOIN dbamv.reg_amb ra        ON ia.cd_reg_amb     = ra.cd_reg_amb
        LEFT JOIN dbamv.pro_fat pf        ON ia.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf        ON ia.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr      ON ia.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am        ON ia.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u       ON ia.cd_usuario     = u.cd_usuario
        LEFT JOIN dbamv.atendime a        ON ia.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c        ON ra.cd_convenio    = c.cd_convenio
        LEFT JOIN dbamv.regra r           ON ra.cd_regra       = r.cd_regra
        LEFT JOIN dbamv.remessa_fatura re ON ra.cd_remessa     = re.cd_remessa
        LEFT JOIN dbamv.fatura f          ON re.cd_fatura      = f.cd_fatura
        LEFT JOIN dbamv.paciente p        ON a.cd_paciente     = p.cd_paciente
        LEFT JOIN dbamv.ori_ate ot        ON a.cd_ori_ate      = ot.cd_ori_ate
        LEFT JOIN dbamv.sub_plano s       ON s.cd_convenio     = a.cd_convenio
                                         AND s.cd_con_pla      = ia.cd_con_pla
                                         AND s.cd_sub_plano    = a.cd_sub_plano
)
ORDER BY dt_ordenacao DESC, sn_pertence_pacote ASC
;

SELECT * FROM DBAMV.NOTA_FISCAL WHERE CD_NOTA_FISCAL = 25114;
SELECT * FROM DBAMV.NOTA_FISCAL WHERE NR_ID_NOTA_FISCAL = 25114;
SELECT * FROM DBAMV.NOTA_FISCAL WHERE NR_NOTA_FISCAL_NFE = 25114;
SELECT * FROM dbamv.HPC_V_CONTA_ATENDIMENTO WHERE CD_ATENDIMENTO = 301886;

CREATE OR REPLACE VIEW dbamv.HPC_V_CONTA_ATENDIMENTO AS
        SELECT
            it.cd_reg_fat AS cd_reg,
            it.cd_lancamento,
            rf.cd_atendimento,
            a.cd_paciente,
            p.nm_paciente,
            rf.cd_remessa,
            rf.cd_regra,
            r.ds_regra,
            rf.cd_convenio,
            -- c.nm_convenio,
            CASE
                WHEN rf.cd_convenio = 3 THEN 'PARTICULAR'
                WHEN s.cd_sub_plano IN ('200', '300') THEN 'SUS - INTERNACAO (' || s.ds_sub_plano || ')'
                WHEN rf.cd_convenio = 1 AND ot.cd_ori_ate = 3 THEN 'SUS - INTERNACAO (MUNICIPIO)'
                WHEN rf.cd_convenio = 1 AND ot.cd_ori_ate = 18 THEN 'SUS - INTERNACAO (ESTADO)'
                ELSE c.nm_convenio
            END nm_convenio,
            it.cd_gru_fat,
            gf.ds_gru_fat,
            it.cd_pro_fat,
            pf.ds_pro_fat AS descricao,
            it.cd_guia,
            f.dt_competencia,
            it.dt_lancamento,
            it.hr_lancamento,
            it.cd_prestador,
            pr.nm_prestador,
            it.sn_pertence_pacote,
            it.vl_unitario,
            it.vl_total_conta,
            it.vl_honorario_unitario,
            it.vl_acrescimo,
            it.vl_desconto,
            it.cd_ati_med,
            am.ds_ati_med,
            it.cd_usuario,
            u.nm_usuario,
            a.tp_atendimento,
            TO_DATE(
                TO_CHAR(it.dt_lancamento, 'DD/MM/YYYY') ||
                TO_CHAR(it.hr_lancamento, 'HH24:MI:SS'),
                'DD/MM/YYYYHH24:MI:SS'
            ) AS dt_ordenacao
        FROM dbamv.itreg_fat it
        LEFT JOIN dbamv.reg_fat rf        ON it.cd_reg_fat     = rf.cd_reg_fat
        LEFT JOIN dbamv.pro_fat pf        ON it.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf        ON it.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr      ON it.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am        ON it.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u       ON it.cd_usuario     = u.cd_usuario
        LEFT JOIN dbamv.atendime a        ON rf.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c        ON rf.cd_convenio    = c.cd_convenio
        LEFT JOIN dbamv.regra r           ON rf.cd_regra       = r.cd_regra
        LEFT JOIN dbamv.remessa_fatura re ON rf.cd_remessa     = re.cd_remessa
        LEFT JOIN dbamv.fatura f          ON re.cd_fatura      = f.cd_fatura
        LEFT JOIN dbamv.paciente p        ON a.cd_paciente     = p.cd_paciente
        LEFT JOIN dbamv.ori_ate ot        ON a.cd_ori_ate      = ot.cd_ori_ate
        LEFT JOIN dbamv.sub_plano s       ON s.cd_convenio     = a.cd_convenio
                                         AND s.cd_con_pla      = rf.cd_con_pla
                                         AND s.cd_sub_plano    = a.cd_sub_plano

        UNION ALL

        SELECT
            ia.cd_reg_amb AS cd_reg,
            ia.cd_lancamento,
            ia.cd_atendimento,
            a.cd_paciente,
            p.nm_paciente,
            ra.cd_remessa,
            ra.cd_regra,
            r.ds_regra,
            ra.cd_convenio,
            -- c.nm_convenio,
            CASE
                WHEN ra.cd_convenio = 3 THEN 'PARTICULAR'
                WHEN s.cd_sub_plano IN ('200', '300') THEN 'SUS - INTERNACAO (' || s.ds_sub_plano || ')'
                WHEN ra.cd_convenio = 1 AND ot.cd_ori_ate = 3 THEN 'SUS - INTERNACAO (MUNICIPIO)'
                WHEN ra.cd_convenio = 1 AND ot.cd_ori_ate = 18 THEN 'SUS - INTERNACAO (ESTADO)'
                ELSE c.nm_convenio
            END nm_convenio,
            ia.cd_gru_fat,
            gf.ds_gru_fat,
            ia.cd_pro_fat,
            pf.ds_pro_fat AS descricao,
            ia.cd_guia,
            f.dt_competencia,
            ra.dt_lancamento_final AS dt_lancamento,
            ia.hr_lancamento,
            ia.cd_prestador,
            pr.nm_prestador,
            ia.sn_pertence_pacote,
            ia.vl_unitario,
            ia.vl_total_conta,
            ia.vl_honorario_unitario,
            ia.vl_acrescimo,
            ia.vl_desconto,
            ia.cd_ati_med,
            am.ds_ati_med,
            ia.cd_usuario,
            ia.nm_usuario,
            a.tp_atendimento,
            TO_DATE(
                TO_CHAR(ra.dt_lancamento_final, 'DD/MM/YYYY') ||
                TO_CHAR(ia.hr_lancamento, 'HH24:MI:SS'),
                'DD/MM/YYYYHH24:MI:SS'
            ) AS dt_ordenacao
        FROM dbamv.itreg_amb ia
        LEFT JOIN dbamv.reg_amb ra        ON ia.cd_reg_amb     = ra.cd_reg_amb
        LEFT JOIN dbamv.pro_fat pf        ON ia.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf        ON ia.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr      ON ia.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am        ON ia.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u       ON ia.cd_usuario     = u.cd_usuario
        LEFT JOIN dbamv.atendime a        ON ia.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c        ON ra.cd_convenio    = c.cd_convenio
        LEFT JOIN dbamv.regra r           ON ra.cd_regra       = r.cd_regra
        LEFT JOIN dbamv.remessa_fatura re ON ra.cd_remessa     = re.cd_remessa
        LEFT JOIN dbamv.fatura f          ON re.cd_fatura      = f.cd_fatura
        LEFT JOIN dbamv.paciente p        ON a.cd_paciente     = p.cd_paciente
        LEFT JOIN dbamv.ori_ate ot        ON a.cd_ori_ate      = ot.cd_ori_ate
        LEFT JOIN dbamv.sub_plano s       ON s.cd_convenio     = a.cd_convenio
                                         AND s.cd_con_pla      = ia.cd_con_pla
                                         AND s.cd_sub_plano    = a.cd_sub_plano
;


