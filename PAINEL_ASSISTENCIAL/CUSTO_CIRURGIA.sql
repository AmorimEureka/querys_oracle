
/* ********************************************************************************************************************************************** */

/* ********************************************************************************************************************************************** */

-- QUERY ORIGINAL DO PAINEL HPC-DIRETORIA-Custos por Cirurgia

WITH CUSTO_CIRURGIA AS (
        -- QUERY ORIGINAL
        SELECT DISTINCT
            main_query.cd_concatenated_columns,
            main_query.cd_aviso_cirurgia, 
            main_query.cd_atendimento,
            main_query.cd_paciente,
            --main_query.cd_cirurgia, 
            main_query.nm_paciente,
            main_query.cd_convenio,
            main_query.cd_sal_cir,
            main_query.nm_convenio,
            main_query.dt_aviso_cirurgia,
            main_query.dt_realizacao,
            main_query.dt_fim_cirurgia,
            main_query.minutos,
            main_query.nm_prestador,
            LISTAGG(main_query.concatenated_procedure, CHR(10)) WITHIN GROUP (ORDER BY main_query.cd_pro_fat) AS LISTA_PROCEDIMENTOS,
            COUNT(main_query.cd_pro_fat) AS QNT_PROCEDIMENTO
        FROM (
            SELECT DISTINCT
                ac.cd_aviso_cirurgia || ac.cd_atendimento || ac.cd_paciente AS cd_concatenated_columns,
                ac.cd_aviso_cirurgia,
                ac.cd_atendimento,
                ac.nm_paciente,
                ac.cd_paciente,
                ca.cd_convenio,
                ac.cd_sal_cir,
                c.nm_convenio,
                ac.dt_aviso_cirurgia,
                ac.dt_realizacao,
                ac.dt_fim_cirurgia,
                TRUNC((ac.dt_fim_cirurgia - ac.dt_realizacao)* 24 * 60)  MINUTOS,
                --ROUND(EXTRACT(MINUTE FROM NUMTODSINTERVAL(ac.dt_fim_cirurgia - ac.dt_realizacao, 'DAY')), 2) AS minutos,
                pa.cd_prestador,
                pa.nm_prestador,
                ci.cd_pro_fat,
                ci.ds_cirurgia AS proc_desc,
                ci.cd_cirurgia,
                ci.cd_pro_fat || ' - ' || ci.ds_cirurgia AS concatenated_procedure
            FROM
                AVISO_CIRURGIA ac
                LEFT JOIN CIRURGIA_AVISO ca ON AC.CD_AVISO_CIRURGIA = CA.CD_AVISO_CIRURGIA
                LEFT JOIN CIRURGIA ci ON CI.CD_CIRURGIA = CA.CD_CIRURGIA
                LEFT JOIN PRESTADOR_AVISO pa ON AC.CD_AVISO_CIRURGIA = PA.CD_AVISO_CIRURGIA
                LEFT JOIN convenio c ON C.CD_CONVENIO = CA.CD_CONVENIO
            WHERE
                pa.sn_principal = 'S'
            GROUP BY
                ac.cd_aviso_cirurgia,
                ci.cd_cirurgia,
                ac.cd_atendimento,
                ac.cd_paciente,
                ac.nm_paciente,
                ca.cd_convenio,
                c.nm_convenio,
                ac.cd_sal_cir,
                ac.dt_aviso_cirurgia,
                ac.dt_realizacao,
                ac.dt_fim_cirurgia,
                pa.cd_prestador,
                pa.nm_prestador,
                ci.cd_pro_fat,
                ci.ds_cirurgia
        ) main_query
        WHERE main_query.nm_prestador IS NOT NULL
        AND main_query.dt_realizacao IS NOT NULL
        GROUP BY
            main_query.cd_aviso_cirurgia, 
            main_query.cd_atendimento,
            main_query.cd_paciente,
            --main_query.cd_cirurgia, 
            main_query.cd_concatenated_columns,
            main_query.nm_paciente,
            main_query.cd_convenio,
            main_query.cd_sal_cir,
            main_query.nm_convenio,
            main_query.dt_aviso_cirurgia,
            main_query.dt_realizacao,
            main_query.dt_fim_cirurgia,
            main_query.minutos,
            main_query.cd_prestador,
            main_query.nm_prestador
),
GASTO_SALA AS (
        -- QUERY ORIGINAL
        SELECT DISTINCT
            me.cd_mvto_estoque,
            --ci.cd_cirurgia,
            a.cd_paciente,
            me.cd_atendimento,
            me.cd_aviso_cirurgia,
            ie.cd_produto,
            p.ds_produto,
            DECODE(
                me.tp_mvto_estoque,
                'D', ie.qt_movimentacao,
                'C' , ie.qt_movimentacao,
                ie.qt_movimentacao * -1) qt_movimentacao,
            p.VL_ULTIMA_ENTRADA AS vl_initario
            -- vip.vl_unitario AS vl_initario
        FROM mvto_estoque me
        JOIN itmvto_estoque ie ON me.cd_mvto_estoque = ie.cd_mvto_estoque
        JOIN atendime a ON a.cd_atendimento = me.cd_atendimento
        JOIN (
            SELECT ip.cd_produto, ip.vl_unitario, ip.dt_gravacao
            FROM itent_pro ip
            JOIN (
                SELECT cd_produto, MAX(dt_gravacao) AS max_dt_gravacao
                FROM itent_pro
                GROUP BY cd_produto
            ) latest ON ip.cd_produto = latest.cd_produto AND ip.dt_gravacao = latest.max_dt_gravacao
        ) vip ON vip.cd_produto = ie.cd_produto
        JOIN cirurgia_aviso ca ON ca.cd_aviso_cirurgia = me.cd_aviso_cirurgia
        JOIN cirurgia ci ON ci.cd_cirurgia = ca.cd_cirurgia
        JOIN produto p ON p.cd_produto = vip.cd_produto
        WHERE me.cd_aviso_cirurgia IS NOT NULL
)
SELECT 
    gs.CD_PRODUTO
     , gs.DS_PRODUTO
     , gs.vl_initario
     , gs.qt_movimentacao
FROM GASTO_SALA gs
WHERE gs.CD_PRODUTO = 9032281
;

/* ********************************************************************************************************************************************** */

WITH CUSTO_CIRURGIA AS (
        SELECT DISTINCT
            main_query.CHAVE,
            main_query.cd_aviso_cirurgia, 
            main_query.cd_atendimento,
            main_query.cd_paciente,
            --main_query.cd_cirurgia, 
            main_query.nm_paciente,
            main_query.cd_convenio,
            main_query.cd_sal_cir,
            main_query.nm_convenio,
            main_query.dt_aviso_cirurgia,
            main_query.dt_realizacao,
            main_query.dt_fim_cirurgia,
            main_query.minutos,
            main_query.nm_prestador,
            LISTAGG(main_query.concatenated_procedure, CHR(10)) WITHIN GROUP (ORDER BY main_query.cd_pro_fat) AS LISTA_PROCEDIMENTOS,
            COUNT(main_query.cd_pro_fat) AS QNT_PROCEDIMENTO
        FROM (
            SELECT DISTINCT
                ac.cd_aviso_cirurgia || ac.cd_atendimento || ac.cd_paciente AS CHAVE,
                ac.cd_aviso_cirurgia,
                ac.cd_atendimento,
                ac.nm_paciente,
                ac.cd_paciente,
                ca.cd_convenio,
                ac.cd_sal_cir,
                c.nm_convenio,
                ac.dt_aviso_cirurgia,
                ac.dt_realizacao,
                ac.dt_fim_cirurgia,
                TRUNC((ac.dt_fim_cirurgia - ac.dt_realizacao)* 24 * 60)  MINUTOS,
                --ROUND(EXTRACT(MINUTE FROM NUMTODSINTERVAL(ac.dt_fim_cirurgia - ac.dt_realizacao, 'DAY')), 2) AS minutos,
                pa.cd_prestador,
                pa.nm_prestador,
                ci.cd_pro_fat,
                ci.ds_cirurgia AS proc_desc,
                ci.cd_cirurgia,
                ci.cd_pro_fat || ' - ' || ci.ds_cirurgia AS concatenated_procedure
            FROM
                AVISO_CIRURGIA ac
                LEFT JOIN CIRURGIA_AVISO ca ON AC.CD_AVISO_CIRURGIA = CA.CD_AVISO_CIRURGIA
                LEFT JOIN CIRURGIA ci ON CI.CD_CIRURGIA = CA.CD_CIRURGIA
                LEFT JOIN PRESTADOR_AVISO pa ON AC.CD_AVISO_CIRURGIA = PA.CD_AVISO_CIRURGIA
                LEFT JOIN convenio c ON C.CD_CONVENIO = CA.CD_CONVENIO
            WHERE
                pa.sn_principal = 'S'
            GROUP BY
                ac.cd_aviso_cirurgia,
                ci.cd_cirurgia,
                ac.cd_atendimento,
                ac.cd_paciente,
                ac.nm_paciente,
                ca.cd_convenio,
                c.nm_convenio,
                ac.cd_sal_cir,
                ac.dt_aviso_cirurgia,
                ac.dt_realizacao,
                ac.dt_fim_cirurgia,
                pa.cd_prestador,
                pa.nm_prestador,
                ci.cd_pro_fat,
                ci.ds_cirurgia
        ) main_query
        WHERE main_query.nm_prestador IS NOT NULL
        AND main_query.dt_realizacao IS NOT NULL
        GROUP BY
            main_query.cd_aviso_cirurgia, 
            main_query.cd_atendimento,
            main_query.cd_paciente,
            --main_query.cd_cirurgia, 
            main_query.CHAVE,
            main_query.nm_paciente,
            main_query.cd_convenio,
            main_query.cd_sal_cir,
            main_query.nm_convenio,
            main_query.dt_aviso_cirurgia,
            main_query.dt_realizacao,
            main_query.dt_fim_cirurgia,
            main_query.minutos,
            main_query.cd_prestador,
            main_query.nm_prestador
),
GASTO_SALA AS (
        SELECT DISTINCT
            me.cd_atendimento || me.cd_aviso_cirurgia || a.cd_paciente AS CHAVE , 
            me.cd_mvto_estoque,
            --ci.cd_cirurgia,
            a.cd_paciente,
            me.cd_atendimento,
            me.cd_aviso_cirurgia,
            ie.cd_produto,
            p.ds_produto,
            DECODE(
                me.tp_mvto_estoque,
                'D', ie.qt_movimentacao,
                'C' , ie.qt_movimentacao,
                ie.qt_movimentacao * -1) qt_movimentacao,
            -- vip.vl_unitario AS vl_initario,
            p.VL_ULTIMA_ENTRADA AS vl_initario,
            p.VL_CUSTO_MEDIO
        FROM mvto_estoque me
        JOIN itmvto_estoque ie ON me.cd_mvto_estoque = ie.cd_mvto_estoque
        JOIN atendime a ON a.cd_atendimento = me.cd_atendimento
        JOIN (
            SELECT ip.cd_produto, ip.vl_unitario, ip.dt_gravacao , ip.NR_ITEM_NF
            FROM itent_pro ip
            JOIN (
                SELECT cd_produto, MAX(dt_gravacao) AS max_dt_gravacao
                FROM itent_pro
                GROUP BY cd_produto
            ) latest ON ip.cd_produto = latest.cd_produto AND ip.dt_gravacao = latest.max_dt_gravacao
        ) vip ON vip.cd_produto = ie.cd_produto
        JOIN cirurgia_aviso ca ON ca.cd_aviso_cirurgia = me.cd_aviso_cirurgia
        JOIN cirurgia ci ON ci.cd_cirurgia = ca.cd_cirurgia
        JOIN produto p ON p.cd_produto = vip.cd_produto
        WHERE me.cd_aviso_cirurgia IS NOT NULL AND p.cd_produto = 9032281
)
SELECT 
    gs.CD_PRODUTO
     , gs.DS_PRODUTO
     , gs.vl_initario
     , gs.qt_movimentacao
FROM GASTO_SALA gs
WHERE gs.CD_PRODUTO = 9032281
;



/* ********************************************************************************************************************************************** */



SELECT
     gs.CD_PRODUTO
     , gs.DS_PRODUTO
     , gs.vl_initario
     , gs.qt_movimentacao
FROM 
    CUSTO_CIRURGIA cc
LEFT JOIN 
    GASTO_SALA gs ON cc.CHAVE = gs.CHAVE
-- WHERE gs.CD_PRODUTO = 19357 
;



SELECT CD_PRODUTO, VL_FATOR, VL_ULTIMA_ENTRADA FROM DBAMV.UNI_PRO WHERE CD_PRODUTO = 9032281 ;

SELECT * FROM user_tab_columns WHERE COLUMN_NAME = 'VL_ULTIMA_ENTRADA';

/* ********************************************************************************************************************************************** */
/* ********************************************************************************************************************************************** */

-- QUERY AJUSTADA PARA O PAINEL
SELECT DISTINCT
    me.cd_mvto_estoque,
    --ci.cd_cirurgia,
    a.cd_paciente,
    me.cd_atendimento,
    me.cd_aviso_cirurgia,
    ie.cd_produto,
    p.ds_produto,
    me.tp_mvto_estoque,
    ie.qt_movimentacao,
    -- DECODE(
    --     me.tp_mvto_estoque,
    --     'D', ie.qt_movimentacao,
    --     'C' , ie.qt_movimentacao,
    --     ie.qt_movimentacao * -1) qt_movimentacao,
    p.VL_CUSTO_MEDIO ,
    p.VL_ULTIMA_ENTRADA AS vl_initario
    -- vip.vl_unitario AS vl_initario
FROM mvto_estoque me
JOIN itmvto_estoque ie ON me.cd_mvto_estoque = ie.cd_mvto_estoque
JOIN atendime a ON a.cd_atendimento = me.cd_atendimento
JOIN (
    SELECT ip.cd_produto, ip.vl_unitario, ip.dt_gravacao
    FROM itent_pro ip
    JOIN (
        SELECT cd_produto, MAX(dt_gravacao) AS max_dt_gravacao
        FROM itent_pro
        GROUP BY cd_produto
    ) latest ON ip.cd_produto = latest.cd_produto AND ip.dt_gravacao = latest.max_dt_gravacao
) vip ON vip.cd_produto = ie.cd_produto
JOIN cirurgia_aviso ca ON ca.cd_aviso_cirurgia = me.cd_aviso_cirurgia
JOIN cirurgia ci ON ci.cd_cirurgia = ca.cd_cirurgia
JOIN produto p ON p.cd_produto = vip.cd_produto
WHERE me.cd_aviso_cirurgia IS NOT NULL AND ie.cd_produto = 18768 AND me.cd_atendimento = 144941 
ORDER BY
    me.cd_mvto_estoque,
    a.cd_paciente,
    me.cd_atendimento,
    me.cd_aviso_cirurgia,
    ie.cd_produto,
    p.ds_produto,
    me.tp_mvto_estoque;


SELECT 
    me.cd_mvto_estoque,
    --ci.cd_cirurgia,
    a.cd_paciente,
    me.cd_atendimento,
    me.cd_aviso_cirurgia,
    ie.cd_produto,
    p.ds_produto,
    me.tp_mvto_estoque,
    SUM(DECODE(
        me.tp_mvto_estoque,
        'D', ie.qt_movimentacao,
        'C' , ie.qt_movimentacao,
        ie.qt_movimentacao * -1)
        ) qt_movimentacao,
    p.VL_CUSTO_MEDIO ,
    p.VL_ULTIMA_ENTRADA AS vl_initario
    -- vip.vl_unitario AS vl_initario
FROM mvto_estoque me
JOIN itmvto_estoque ie ON me.cd_mvto_estoque = ie.cd_mvto_estoque
JOIN atendime a ON a.cd_atendimento = me.cd_atendimento
JOIN (
    SELECT DISTINCT ip.cd_produto, ip.vl_unitario, ip.dt_gravacao
    FROM itent_pro ip
    JOIN (
        SELECT cd_produto, MAX(dt_gravacao) AS max_dt_gravacao
        FROM itent_pro
        GROUP BY cd_produto
    ) latest ON ip.cd_produto = latest.cd_produto AND ip.dt_gravacao = latest.max_dt_gravacao
) vip ON vip.cd_produto = ie.cd_produto
JOIN cirurgia_aviso ca ON ca.cd_aviso_cirurgia = me.cd_aviso_cirurgia
JOIN cirurgia ci ON ci.cd_cirurgia = ca.cd_cirurgia
JOIN produto p ON p.cd_produto = vip.cd_produto
WHERE me.cd_aviso_cirurgia IS NOT NULL 
  AND ie.cd_produto = 18768 
  AND me.cd_atendimento = 144941
GROUP BY
    me.cd_mvto_estoque,
    a.cd_paciente,
    me.cd_atendimento,
    me.cd_aviso_cirurgia,
    ie.cd_produto,
    p.ds_produto,
    me.tp_mvto_estoque,
    p.VL_CUSTO_MEDIO,
    p.VL_ULTIMA_ENTRADA;







SELECT 
    me.cd_mvto_estoque,
    a.cd_paciente,
    me.cd_atendimento,
    me.cd_aviso_cirurgia,
    ie.cd_produto,
    p.ds_produto,
    me.tp_mvto_estoque,
    SUM(ie.qt_movimentacao) AS qt_movimentacao_total,
    p.VL_CUSTO_MEDIO AS custo_medio,
    p.VL_ULTIMA_ENTRADA AS ultima_entrada
FROM mvto_estoque me
JOIN itmvto_estoque ie ON me.cd_mvto_estoque = ie.cd_mvto_estoque
JOIN atendime a ON a.cd_atendimento = me.cd_atendimento
JOIN (
    SELECT DISTINCT ip.cd_produto, ip.vl_unitario, ip.dt_gravacao
    FROM itent_pro ip
    JOIN (
        SELECT cd_produto, MAX(dt_gravacao) AS max_dt_gravacao
        FROM itent_pro
        GROUP BY cd_produto
    ) latest ON ip.cd_produto = latest.cd_produto AND ip.dt_gravacao = latest.max_dt_gravacao
) vip ON vip.cd_produto = ie.cd_produto
JOIN cirurgia_aviso ca ON ca.cd_aviso_cirurgia = me.cd_aviso_cirurgia
JOIN cirurgia ci ON ci.cd_cirurgia = ca.cd_cirurgia
JOIN produto p ON p.cd_produto = vip.cd_produto
WHERE me.cd_aviso_cirurgia IS NOT NULL 
  AND ie.cd_produto = 18768 
  AND me.cd_atendimento = 144941
GROUP BY
    me.cd_mvto_estoque,
    a.cd_paciente,
    me.cd_atendimento,
    me.cd_aviso_cirurgia,
    ie.cd_produto,
    p.ds_produto,
    me.tp_mvto_estoque,
    p.VL_CUSTO_MEDIO,
    p.VL_ULTIMA_ENTRADA;
