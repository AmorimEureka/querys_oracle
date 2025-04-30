-- Query da Consulta 'Internacao'
SELECT
    a.cd_atendimento,
    a.cd_paciente,
    INITCAP(p.nm_paciente) AS nm_paciente,
    p.nr_cpf,
    INITCAP(p.ds_endereco) ||
    ', ' || DECODE(p.nr_endereco, NULL, '', ' ', '', p.nr_endereco || ', ') ||
    INITCAP(p.nm_bairro) || ', ' || DECODE(p.ds_complemento, NULL, '', ' ', '', p.ds_complemento || ', ') ||
    INITCAP(ci.nm_cidade) || '-' || ci.cd_uf ||
    ', CEP ' || p.nr_cep AS endereco,
    INITCAP(p.ds_endereco) AS lougadouro,
    INITCAP(p.nr_endereco) AS numero,
    INITCAP(p.nm_bairro) AS bairro,
    INITCAP(p.ds_complemento) AS complemento,
    INITCAP(ci.nm_cidade) AS cidade,
    ci.cd_uf AS UF,
    INITCAP(p.nm_mae) AS nm_mae,
    p.dt_nascimento,
    p.tp_sexo,
    a.cd_convenio,
    INITCAP(co.nm_convenio) AS nm_convenio,
    a.cd_leito,
    a.cd_pro_int,
    a.dt_atendimento,
    a.dt_alta_medica,
    (TO_DATE(SYSDATE) - TO_DATE(a.dt_atendimento)) AS temp_hosp,
    a.hr_atendimento,
    a.tp_atendimento,
    a.cd_prestador,
    INITCAP(pr.nm_prestador) AS nm_prestador,
    a.cd_cid || '-' || c.ds_cid AS cid,
    l.cd_leito,
    l.cd_unid_int,
    u.ds_unid_int,
    l.ds_enfermaria,
    INITCAP(l.ds_leito) AS ds_leito,
    l.tp_ocupacao,
    l.ds_resumo
FROM
    dbamv.atendime a
    JOIN dbamv.paciente p ON a.cd_paciente = p.cd_paciente
    JOIN dbamv.leito l ON a.cd_leito = l.cd_leito
    JOIN dbamv.cid c ON a.cd_cid = c.cd_cid
    JOIN dbamv.convenio co ON a.cd_convenio = co.cd_convenio
    JOIN dbamv.prestador pr ON a.cd_prestador = pr.cd_prestador
    JOIN dbamv.unid_int u ON l.cd_unid_int = u.cd_unid_int
    JOIN dbamv.cidade ci ON ci.cd_cidade = p.cd_cidade
WHERE
    a.tp_atendimento = 'I'
    AND a.dt_alta_medica IS NULL;

-- Query da Consulta 'Exa_Lab'
SELECT DISTINCT
    il.cd_ped_lab,
    il.cd_exa_lab,
    el.nm_exa_lab,
    re.nm_campo,
    re.ds_resultado,
    pl.dt_pedido,
    il.dt_laudo,
    TO_CHAR(il.dt_laudo, 'dd/mm/yyyy') AS dt_laudo_fechada,
    pl.cd_atendimento,
    a.cd_convenio,
    c.nm_convenio,
    a.cd_paciente,
    p.nm_paciente
FROM
    ped_lab pl
    LEFT JOIN itped_lab il ON pl.cd_ped_lab = il.cd_ped_lab
    LEFT JOIN res_exa re ON il.cd_itped_lab = re.cd_itped_lab
    LEFT JOIN exa_lab el ON re.cd_exa_lab = el.cd_exa_lab
    LEFT JOIN atendime a ON pl.cd_atendimento = a.cd_atendimento
    LEFT JOIN convenio c ON c.cd_convenio = a.cd_convenio
    LEFT JOIN paciente p ON p.cd_paciente = a.cd_paciente
WHERE
    a.tp_atendimento = 'I'
    AND a.dt_alta_medica IS NULL;

-- Query da Consulta 'Prescricao'
SELECT
    pm.cd_pre_med,
    pm.cd_atendimento,
    a.cd_paciente,
    INITCAP(p.nm_paciente) AS nm_paciente,
    a.cd_convenio,
    c.nm_convenio,
    pm.cd_prestador,
    INITCAP(pr.nm_prestador) AS nm_prestador,
    im.cd_tip_presc,
    tp.ds_tip_presc,
    pm.dt_pre_med,
    te.ds_tip_esq,
    im.qt_itpre_med,
    u.ds_unidade,
    tf.ds_tip_fre
FROM
    pre_med pm
    LEFT JOIN itpre_med im ON pm.cd_pre_med = im.cd_pre_med
    LEFT JOIN tip_presc tp ON im.cd_tip_presc = tp.cd_tip_presc
    LEFT JOIN atendime a ON a.cd_atendimento = pm.cd_atendimento
    LEFT JOIN paciente p ON p.cd_paciente = a.cd_paciente
    LEFT JOIN convenio c ON c.cd_convenio = a.cd_convenio
    LEFT JOIN prestador pr ON pr.cd_prestador = pm.cd_prestador
    LEFT JOIN tip_esq te ON te.cd_tip_esq = im.cd_tip_esq
    LEFT JOIN tip_fre tf ON im.cd_tip_fre = tf.cd_tip_fre
    LEFT JOIN uni_pro u ON u.cd_uni_pro = im.cd_uni_pro
WHERE
    tp.cd_tip_presc IS NOT NULL
    AND a.tp_atendimento = 'I'
    AND a.dt_alta_medica IS NULL;

-- Query da Consulta 'Sinais_Vitais'
SELECT
    cv.cd_atendimento,
    a.cd_paciente,
    p.nm_paciente,
    p.tp_sexo,
    iv.cd_sinal_vital,
    sv.ds_sinal_vital,
    iv.valor,
    cv.data_coleta,
    a.tp_atendimento
FROM
    itcoleta_sinal_vital iv
    JOIN sinal_vital sv ON iv.cd_sinal_vital = sv.cd_sinal_vital
    JOIN coleta_sinal_vital cv ON iv.cd_coleta_sinal_vital = cv.cd_coleta_sinal_vital
    JOIN atendime a ON cv.cd_atendimento = a.cd_atendimento
    JOIN paciente p ON a.cd_paciente = p.cd_paciente
WHERE
    a.tp_atendimento = 'I'
    AND a.dt_alta_medica IS NULL;

-- Query da Consulta 'Laudos'
SELECT
    l.cd_laudo,
    l.cd_laudo_integra,
    e.cd_exa_rx,
    pe.cd_ped_rx,
    i.cd_itped_rx,
    pe.cd_pre_med,
    pe.cd_setor,
    pe.cd_atendimento,
    pe.cd_convenio,
    INITCAP(pr1.nm_prestador) AS solicitante,
    INITCAP(pr2.nm_prestador) AS laudista,
    INITCAP(p.nm_paciente) AS nm_paciente,
    c.nm_convenio,
    pe.hr_pedido,
    pe.hr_coleta,
    pe.dt_solicitacao,
    pe.dt_autorizacao,
    pe.dt_validade,
    i.dt_realizado,
    l.hr_laudo,
    INITCAP(e.ds_exa_rx) AS ds_exa_rx
FROM
    laudo_rx l
    LEFT JOIN ped_rx pe ON pe.cd_ped_rx = l.cd_ped_rx
    LEFT JOIN itped_rx i ON i.cd_ped_rx = pe.cd_ped_rx
    LEFT JOIN exa_rx e ON e.cd_exa_rx = i.cd_exa_rx
    LEFT JOIN prestador pr1 ON pr1.cd_prestador = pe.cd_prestador
    LEFT JOIN prestador pr2 ON pr2.cd_prestador = l.cd_prestador
    LEFT JOIN convenio c ON c.cd_convenio = pe.cd_convenio
    LEFT JOIN atendime a ON a.cd_atendimento = pe.cd_atendimento
    LEFT JOIN paciente p ON p.cd_paciente = a.cd_paciente;

-- Query da Consulta 'Imagens_Laudos'
SELECT
    a.cd_atendimento,
    a.cd_paciente,
    INITCAP(e.ds_exa_rx),
    rs_lau_exame_pedido_pdf.id_exame_pedido,
    rs_lau_exame_pedido_pdf.ds_laudo_pdf,
    rs_lau_exame_pedido_pdf.ds_laudo_pdf_marcadagua,
    rs_lau_exame_pedido_pdf.layout_novo_editor,
    l.cd_laudo_integra
FROM
    idce.rs_lau_exame_pedido_pdf
    LEFT JOIN laudo_rx l ON l.cd_laudo_integra = rs_lau_exame_pedido_pdf.id_exame_pedido
    LEFT JOIN ped_rx p ON p.cd_ped_rx = l.cd_ped_rx
    LEFT JOIN itped_rx i ON i.cd_ped_rx = p.cd_ped_rx
    LEFT JOIN atendime a ON a.cd_atendimento = p.cd_atendimento
    LEFT JOIN paciente p ON a.cd_paciente = p.cd_paciente
    LEFT JOIN exa_rx e ON e.cd_exa_rx = i.cd_exa_rx
    LEFT JOIN (
        SELECT
            a.cd_paciente
        FROM
            dbamv.atendime a
            JOIN dbamv.paciente p ON a.cd_paciente = p.cd_paciente
            JOIN dbamv.leito l ON a.cd_leito = l.cd_leito
            JOIN dbamv.cid c ON a.cd_cid = c.cd_cid
            JOIN dbamv.convenio co ON a.cd_convenio = co.cd_convenio
            JOIN dbamv.prestador pr ON a.cd_prestador = pr.cd_prestador
            JOIN dbamv.unid_int u ON l.cd_unid_int = u.cd_unid_int
            JOIN dbamv.cidade ci ON ci.cd_cidade = p.cd_cidade
        WHERE
            a.tp_atendimento = 'I'
            AND a.dt_alta_medica IS NULL
    ) int ON int.cd_paciente = a.cd_paciente
WHERE
    int.cd_paciente = a.cd_paciente
    AND rs_lau_exame_pedido_pdf.ds_laudo_pdf_marcadagua IS NOT NULL
    AND rs_lau_exame_pedido_pdf.layout_novo_editor IS NOT NULL;

-- Query da Consulta 'Evolucao'
SELECT
    pm.cd_pre_med,
    pm.cd_atendimento,
    pm.cd_prestador,
    pm.cd_unid_int,
    pm.dt_pre_med,
    pm.hr_pre_med,
    pm.cd_id_usuario,
    pm.nm_usuario,
    pm.ds_evolucao
FROM
    pre_med pm
WHERE
    pm.ds_evolucao IS NOT NULL
    AND pm.dt_pre_med >= CURRENT_TIMESTAMP - 5
    AND pm.tp_pre_med = 'M';

-- Query da Consulta 'Balanco Hidrico'
SELECT
    bh.cd_balanco_hidrico,
    ibh.cd_itbalanco_hidrico,
    ibh.cd_usuario,
    INITCAP(u.nm_usuario) AS nm_usuario,
    bh.cd_atendimento,
    bh.cd_setor,
    s.nm_setor,
    bh.cd_paciente,
    ibh.cd_grupo_balanco_hidrico,
    gbh.nm_grupo_balanco_hidrico,
    DECODE(tp_calculo, 'G', 'Ganho', 'P', 'Perda') AS tp_calculo,
    INITCAP(ibh.ds_tip_presc) AS ds_tip_presc,
    DECODE(tp_calculo, 'G', ibh.vl_coleta, 'P', -1 * ibh.vl_coleta) AS vl_coleta,
    ibh.dh_coleta,
    ibh.sn_soma_total_balanco
FROM
    pw_itbalanco_hidrico ibh
    LEFT JOIN pw_grupo_balanco_hidrico gbh ON gbh.cd_grupo_balanco_hidrico = ibh.cd_grupo_balanco_hidrico
    LEFT JOIN pw_balanco_hidrico bh ON bh.cd_balanco_hidrico = gbh.cd_balanco_hidrico
    LEFT JOIN dbasgu.usuarios u ON u.cd_usuario = ibh.cd_usuario
    LEFT JOIN setor s ON s.cd_setor = bh.cd_setor;