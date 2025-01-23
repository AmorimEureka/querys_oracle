-- V_HPC_HEMODIN_V4

WITH V_HPC_HEMODIN_V4 AS (
    SELECT
        pr.cd_prestador,
        INITCAP(pr.nm_prestador) nm_prestador,
        am.cd_ati_med,
        INITCAP(am.ds_ati_med) nm_atividade,
        TO_CHAR(ac.dt_aviso_cirurgia, 'DD/MM/YYYY') dt_aviso_cirurgia,
        TO_CHAR(ac.dt_aviso_cirurgia, 'HH24:MI:SS') hr_aviso_cirurgia,
        TO_CHAR(ac.dt_agendamento, 'DD/MM/YYYY') dt_agendamento,
        TO_CHAR(ac.dt_agendamento, 'HH24:MI:SS') hr_agendamento,
        ac.dt_inicio_cirurgia,
        ac.dt_saida_sal_cir,
        sr.cd_sal_cir,
        INITCAP(sr.ds_sal_cir) Sala,
        ac.cd_paciente,
        INITCAP(ac.nm_paciente) nm_aciente,
        TO_CHAR(p.dt_nascimento, 'DD/MM/YYYY') dt_nascimento_paciente,
        ac.ds_idade,
        c.cd_cirurgia,
        INITCAP(c.ds_cirurgia) ds_cirurgia,
        ac.tp_situacao AS cd_tp_situacao,
        DECODE(
            ac.tp_situacao,
            'A', 'Em Aviso',
            'R', 'Realizada',
            'C', 'Cancelada',
            'G', 'Agendada',
            'T', 'Controle de Checagem',
            'P', 'Pré Atendimento',
            'Nao Identificado'
        ) nm_situacao,
        co.cd_convenio,
        INITCAP(co.nm_convenio) nm_convenio,
        ac.ds_obs_aviso observacao
    FROM
        dbamv.prestador_aviso pa,
        dbamv.aviso_cirurgia ac,
        dbamv.cirurgia_aviso ca,
        dbamv.ati_med am,
        dbamv.cirurgia c,
        dbamv.convenio co,
        dbamv.sal_cir sr,
        dbamv.prestador pr,
        dbamv.paciente p
    WHERE
        ac.cd_aviso_cirurgia = pa.cd_aviso_cirurgia
        AND ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
        AND ac.cd_aviso_cirurgia = ca.cd_aviso_cirurgia
        AND ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
        AND sr.cd_sal_cir = ac.cd_sal_cir
        AND c.cd_cirurgia = ca.cd_cirurgia
        AND co.cd_convenio = ca.cd_convenio
        AND pa.cd_ati_med = am.cd_ati_med
        AND pa.cd_prestador = pr.cd_prestador
        AND pa.sn_principal = 'S'
        AND ac.cd_cen_cir IN ('1', '2')
        AND ac.cd_paciente = p.cd_paciente
    ORDER BY
        1, 10 DESC
)
SELECT
    *
FROM
    V_HPC_HEMODIN_V4
WHERE
    dt_aviso_cirurgia BETWEEN TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY') AND TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY') 
;



WITH V_HPC_HEMODIN_V4 AS (
    SELECT
        pr.cd_prestador,
        INITCAP(pr.nm_prestador) nm_prestador,
        am.cd_ati_med,
        INITCAP(am.ds_ati_med) nm_atividade,
        TO_CHAR(ac.dt_aviso_cirurgia, 'DD/MM/YYYY') dt_aviso_cirurgia,
        TO_CHAR(ac.dt_aviso_cirurgia, 'HH24:MI:SS') hr_aviso_cirurgia,
        TO_CHAR(ac.dt_agendamento, 'DD/MM/YYYY') dt_agendamento,
        TO_CHAR(ac.dt_agendamento, 'HH24:MI:SS') hr_agendamento,
        EXTRACT(YEAR FROM dt_aviso_cirurgia) Ano,
        ac.dt_inicio_cirurgia,
        ac.dt_saida_sal_cir,
        sr.cd_sal_cir,
        INITCAP(sr.ds_sal_cir) Sala,
        ac.cd_paciente,
        INITCAP(ac.nm_paciente) nm_aciente,
        TO_CHAR(p.dt_nascimento, 'DD/MM/YYYY') dt_nascimento_paciente,
        ac.ds_idade Idade,
        c.cd_cirurgia,
        INITCAP(c.ds_cirurgia) ds_cirurgia,
        ac.tp_situacao AS cd_tp_situacao,
        DECODE(
            ac.tp_situacao,
            'A', 'Em Aviso',
            'R', 'Realizada',
            'C', 'Cancelada',
            'G', 'Agendada',
            'T', 'Controle de Checagem',
            'P', 'Pré Atendimento',
            'Nao Identificado'
        ) nm_situacao,
        co.cd_convenio,
        INITCAP(co.nm_convenio) nm_convenio,
        ac.ds_obs_aviso observacao
    FROM
        dbamv.prestador_aviso pa,
        dbamv.aviso_cirurgia ac,
        dbamv.cirurgia_aviso ca,
        dbamv.ati_med am,
        dbamv.cirurgia c,
        dbamv.convenio co,
        dbamv.sal_cir sr,
        dbamv.prestador pr,
        dbamv.paciente p
    WHERE
        ac.cd_aviso_cirurgia = pa.cd_aviso_cirurgia
        AND ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
        AND ac.cd_aviso_cirurgia = ca.cd_aviso_cirurgia
        AND ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
        AND sr.cd_sal_cir = ac.cd_sal_cir
        AND c.cd_cirurgia = ca.cd_cirurgia
        AND co.cd_convenio = ca.cd_convenio
        AND pa.cd_ati_med = am.cd_ati_med
        AND pa.cd_prestador = pr.cd_prestador
        AND pa.sn_principal = 'S'
        AND ac.cd_cen_cir IN ('1', '2')
        AND ac.cd_paciente = p.cd_paciente
    ORDER BY
        1, 10 DESC
)
SELECT
    *
FROM
    V_HPC_HEMODIN_V4
WHERE
    Ano = 2024
;