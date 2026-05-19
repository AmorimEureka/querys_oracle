
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
                                it.cd_guia,
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
                            LEFT JOIN dbamv.reg_fat rf      ON it.cd_reg_fat     = rf.cd_reg_fat
                            LEFT JOIN dbamv.pro_fat pf      ON it.cd_pro_fat     = pf.cd_pro_fat
                            LEFT JOIN dbamv.gru_fat gf      ON it.cd_gru_fat     = gf.cd_gru_fat
                            LEFT JOIN dbamv.prestador pr    ON it.cd_prestador   = pr.cd_prestador
                            LEFT JOIN dbamv.ati_med am      ON it.cd_ati_med     = am.cd_ati_med
                            LEFT JOIN dbasgu.usuarios u     ON it.cd_usuario     =  u.cd_usuario
                            LEFT JOIN dbamv.atendime a      ON rf.cd_atendimento = a.cd_atendimento
                            LEFT JOIN dbamv.convenio c      ON rf.cd_convenio    =  c.cd_convenio
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
                                ia.cd_guia,
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
                            LEFT JOIN dbamv.reg_amb ra      ON ia.cd_reg_amb     = ra.cd_reg_amb
                            LEFT JOIN dbamv.pro_fat pf      ON ia.cd_pro_fat     = pf.cd_pro_fat
                            LEFT JOIN dbamv.gru_fat gf      ON ia.cd_gru_fat     = gf.cd_gru_fat
                            LEFT JOIN dbamv.prestador pr    ON ia.cd_prestador   = pr.cd_prestador
                            LEFT JOIN dbamv.ati_med am      ON ia.cd_ati_med     = am.cd_ati_med
                            LEFT JOIN dbasgu.usuarios u     ON ia.cd_usuario     =  u.cd_usuario
                            LEFT JOIN dbamv.atendime a      ON ia.cd_atendimento = a.cd_atendimento
                            LEFT JOIN dbamv.convenio c      ON ra.cd_convenio    =  c.cd_convenio
                            LEFT JOIN dbamv.regra r         ON ra.cd_regra       =  r.cd_regra
                            LEFT JOIN dbamv.paciente p      ON a.cd_paciente     = p.cd_paciente
                            CROSS JOIN FILTRO f
                            WHERE
                                ia.cd_atendimento = f.param_atendimento
                    )
                    ORDER BY sn_pertence_pacote ASC, dt_ordenacao
                ) t
                WHERE
                    ROWNUM <= :param_Max
        )
        WHERE
            recnum >= :param_Min
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
            c.nm_convenio,
            it.cd_gru_fat,
            gf.ds_gru_fat,
            it.cd_pro_fat,
            pf.ds_pro_fat AS descricao,
            it.cd_guia,
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
        LEFT JOIN dbamv.reg_fat rf      ON it.cd_reg_fat     = rf.cd_reg_fat
        LEFT JOIN dbamv.pro_fat pf      ON it.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf      ON it.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr    ON it.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am      ON it.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u     ON it.cd_usuario     =  u.cd_usuario
        LEFT JOIN dbamv.atendime a      ON rf.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c      ON rf.cd_convenio    =  c.cd_convenio
        LEFT JOIN dbamv.regra r         ON rf.cd_regra       =  r.cd_regra
        LEFT JOIN dbamv.paciente p      ON a.cd_paciente     = p.cd_paciente

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
            ia.cd_guia,
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
        LEFT JOIN dbamv.reg_amb ra      ON ia.cd_reg_amb     = ra.cd_reg_amb
        LEFT JOIN dbamv.pro_fat pf      ON ia.cd_pro_fat     = pf.cd_pro_fat
        LEFT JOIN dbamv.gru_fat gf      ON ia.cd_gru_fat     = gf.cd_gru_fat
        LEFT JOIN dbamv.prestador pr    ON ia.cd_prestador   = pr.cd_prestador
        LEFT JOIN dbamv.ati_med am      ON ia.cd_ati_med     = am.cd_ati_med
        LEFT JOIN dbasgu.usuarios u     ON ia.cd_usuario     =  u.cd_usuario
        LEFT JOIN dbamv.atendime a      ON ia.cd_atendimento = a.cd_atendimento
        LEFT JOIN dbamv.convenio c      ON ra.cd_convenio    =  c.cd_convenio
        LEFT JOIN dbamv.regra r         ON ra.cd_regra       =  r.cd_regra
        LEFT JOIN dbamv.paciente p      ON a.cd_paciente     = p.cd_paciente
)
ORDER BY dt_ordenacao DESC, sn_pertence_pacote ASC
;


SELECT * FROM dbamv.HPC_V_CONTA_ATENDIMENTO;

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
        c.nm_convenio,
        it.cd_gru_fat,
        gf.ds_gru_fat,
        it.cd_pro_fat,
        pf.ds_pro_fat AS descricao,
        it.cd_guia,
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
    LEFT JOIN dbamv.reg_fat rf      ON it.cd_reg_fat     = rf.cd_reg_fat
    LEFT JOIN dbamv.pro_fat pf      ON it.cd_pro_fat     = pf.cd_pro_fat
    LEFT JOIN dbamv.gru_fat gf      ON it.cd_gru_fat     = gf.cd_gru_fat
    LEFT JOIN dbamv.prestador pr    ON it.cd_prestador   = pr.cd_prestador
    LEFT JOIN dbamv.ati_med am      ON it.cd_ati_med     = am.cd_ati_med
    LEFT JOIN dbasgu.usuarios u     ON it.cd_usuario     = u.cd_usuario
    LEFT JOIN dbamv.atendime a      ON rf.cd_atendimento = a.cd_atendimento
    LEFT JOIN dbamv.convenio c      ON rf.cd_convenio    = c.cd_convenio
    LEFT JOIN dbamv.regra r         ON rf.cd_regra       = r.cd_regra
    LEFT JOIN dbamv.paciente p      ON a.cd_paciente     = p.cd_paciente

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
        ia.cd_guia,
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
    LEFT JOIN dbamv.reg_amb ra      ON ia.cd_reg_amb     = ra.cd_reg_amb
    LEFT JOIN dbamv.pro_fat pf      ON ia.cd_pro_fat     = pf.cd_pro_fat
    LEFT JOIN dbamv.gru_fat gf      ON ia.cd_gru_fat     = gf.cd_gru_fat
    LEFT JOIN dbamv.prestador pr    ON ia.cd_prestador   = pr.cd_prestador
    LEFT JOIN dbamv.ati_med am      ON ia.cd_ati_med     = am.cd_ati_med
    LEFT JOIN dbasgu.usuarios u     ON ia.cd_usuario     = u.cd_usuario
    LEFT JOIN dbamv.atendime a      ON ia.cd_atendimento = a.cd_atendimento
    LEFT JOIN dbamv.convenio c      ON ra.cd_convenio    = c.cd_convenio
    LEFT JOIN dbamv.regra r         ON ra.cd_regra       = r.cd_regra
    LEFT JOIN dbamv.paciente p      ON a.cd_paciente     = p.cd_paciente;
