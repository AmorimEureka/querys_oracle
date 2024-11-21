
-- RELACAO CONTATO DE PACIENTES QUE REALIZARAM ANGIOPLASTIA e NAO VOLTARAM MAIS AO HOSPITAL
WITH BASE 
    AS (
        SELECT
            pr.nm_prestador
            , a.CD_ATENDIMENTO
            , a.DT_ATENDIMENTO
            , am.ds_ati_med
            , TRUNC(AC.DT_AVISO_CIRURGIA) AS DT_AVISO_CIRURGIA
            , EXTRACT(YEAR FROM a.DT_ATENDIMENTO) AS ANO
            , EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES
            , AC.CD_PACIENTE
            , AC.NM_PACIENTE
            , CA.CD_CIRURGIA
            , c.DS_CIRURGIA
            , CA.CD_CONVENIO
            , CO.NM_CONVENIO
            , COUNT(pa.cd_aviso_cirurgia) qtd
            , s.cd_sub_plano
            , s.DS_SUB_PLANO
            , ROW_NUMBER() OVER (PARTITION BY AC.CD_PACIENTE ORDER BY a.DT_ATENDIMENTO DESC) AS rn
        FROM
            dbamv.prestador_aviso pa
            LEFT JOIN dbamv.aviso_cirurgia ac ON ac.cd_aviso_cirurgia = pa.cd_aviso_cirurgia
            LEFT JOIN dbamv.cirurgia_aviso ca ON ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
            LEFT JOIN dbamv.ati_med am ON pa.cd_ati_med = am.cd_ati_med
            LEFT JOIN DBAMV.CIRURGIA c ON c.CD_CIRURGIA = CA.CD_CIRURGIA
            LEFT JOIN DBAMV.CONVENIO co ON CO.CD_CONVENIO = CA.CD_CONVENIO
            LEFT JOIN dbamv.prestador pr ON pa.cd_prestador = pr.cd_prestador
            LEFT JOIN dbamv.atendime a ON a.CD_PACIENTE = ac.CD_PACIENTE
            LEFT JOIN dbamv.sub_plano s ON s.cd_convenio = co.cd_convenio AND s.cd_sub_plano = a.cd_sub_plano
        WHERE
            pa.sn_principal = 'S'
            AND ac.tp_situacao = 'R'
            AND ac.cd_cen_cir IN ('1', '2')
            AND c.DS_CIRURGIA LIKE '%ANGIOPLASTIA%'
        GROUP BY
            pr.nm_prestador,
            a.CD_ATENDIMENTO,
            a.DT_ATENDIMENTO,
            am.ds_ati_med,
            AC.DT_AVISO_CIRURGIA,
            AC.CD_PACIENTE,
            AC.NM_PACIENTE,
            CA.CD_CIRURGIA,
            c.DS_CIRURGIA,
            CA.CD_CONVENIO,
            CO.NM_CONVENIO,
            s.cd_sub_plano,
            s.ds_sub_plano
        ORDER BY
            AC.CD_PACIENTE,
            AC.NM_PACIENTE,
            rn DESC
),
ANGIOPLASTIA 
    AS (
        SELECT b.CD_PACIENTE, b.DT_ATENDIMENTO, b.CD_ATENDIMENTO FROM BASE b 
),
CONSULTA
    AS (
        SELECT a.CD_PACIENTE, a.DT_ATENDIMENTO, a.CD_ATENDIMENTO FROM DBAMV.ATENDIME a WHERE a.CD_ATENDIMENTO NOT IN(SELECT DISTINCT h.CD_ATENDIMENTO FROM BASE h )
),
EXCESAO 
    AS (
        SELECT DISTINCT CD_PACIENTE FROM ANGIOPLASTIA
        MINUS
        SELECT DISTINCT CD_PACIENTE FROM CONSULTA
)
SELECT DISTINCT
    p.CD_PACIENTE
    -- , a.DT_ATENDIMENTO
    , EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES
    , EXTRACT(YEAR FROM a.DT_ATENDIMENTO) AS ANO
    , p.TP_SEXO
    , p.NM_PACIENTE
    , p.NR_DDD_FONE
    , p.NR_FONE
    , p.NR_FONE_COMERCIAL
    , p.NR_DDD_CELULAR
    , p.NR_CELULAR
FROM EXCESAO e 
INNER JOIN DBAMV.PACIENTE p ON p.CD_PACIENTE = e.CD_PACIENTE
INNER JOIN ANGIOPLASTIA a ON a.CD_PACIENTE = p.CD_PACIENTE
WHERE EXTRACT(YEAR FROM a.DT_ATENDIMENTO) = 2023
ORDER BY p.CD_PACIENTE DESC
;





-- RETIRAR PACIENTES COM ALTA POR MOTIVO DE OBITO - " DBAMV.MOT_ALT.TP_MOT_ALTA='O' "
WITH 
    ANGIO AS (
        SELECT
            pr.nm_prestador,
            a.CD_ATENDIMENTO,
            a.DT_ATENDIMENTO,
            am.ds_ati_med,
            TRUNC(AC.DT_AVISO_CIRURGIA) AS DT_AVISO_CIRURGIA,
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) AS ANO,
            EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES,
            AC.CD_PACIENTE,
            AC.NM_PACIENTE,
            CA.CD_CIRURGIA,
            c.DS_CIRURGIA,
            CA.CD_CONVENIO,
            CO.NM_CONVENIO,
            COUNT(pa.cd_aviso_cirurgia) AS qtd,
            s.cd_sub_plano,
            s.DS_SUB_PLANO,
            ROW_NUMBER() OVER (PARTITION BY AC.CD_PACIENTE ORDER BY a.DT_ATENDIMENTO DESC) AS rn
        FROM
            dbamv.prestador_aviso pa
            LEFT JOIN dbamv.aviso_cirurgia ac ON ac.cd_aviso_cirurgia = pa.cd_aviso_cirurgia
            LEFT JOIN dbamv.cirurgia_aviso ca ON ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
            LEFT JOIN dbamv.ati_med am ON pa.cd_ati_med = am.cd_ati_med
            LEFT JOIN DBAMV.CIRURGIA c ON c.CD_CIRURGIA = CA.CD_CIRURGIA
            LEFT JOIN DBAMV.CONVENIO co ON CO.CD_CONVENIO = CA.CD_CONVENIO
            LEFT JOIN dbamv.prestador pr ON pa.cd_prestador = pr.cd_prestador
            LEFT JOIN dbamv.atendime a ON a.CD_PACIENTE = ac.CD_PACIENTE
            LEFT JOIN dbamv.sub_plano s ON s.cd_convenio = co.cd_convenio AND s.cd_sub_plano = a.cd_sub_plano
            LEFT JOIN DBAMV.MOT_ALT ma ON a.CD_MOT_ALT = ma.CD_MOT_ALT
        WHERE
            pa.sn_principal = 'S'
            AND ac.tp_situacao = 'R'
            AND ac.cd_cen_cir IN ('1', '2')
            AND c.DS_CIRURGIA LIKE '%ANGIOPLASTIA%'
            AND ma.TP_MOT_ALTA <> 'O'
        GROUP BY
            pr.nm_prestador,
            a.CD_ATENDIMENTO,
            a.DT_ATENDIMENTO,
            am.ds_ati_med,
            AC.DT_AVISO_CIRURGIA,
            AC.CD_PACIENTE,
            AC.NM_PACIENTE,
            CA.CD_CIRURGIA,
            c.DS_CIRURGIA,
            CA.CD_CONVENIO,
            CO.NM_CONVENIO,
            s.cd_sub_plano,
            s.ds_sub_plano
),
COM_ATEND_SEGUINTE
        AS (
        SELECT 
            -- ag.CD_ATENDIMENTO
             ag.CD_PACIENTE
            -- , a.DT_ATENDIMENTO
            , EXTRACT(MONTH FROM ag.DT_ATENDIMENTO) AS MES
            , EXTRACT(YEAR FROM ag.DT_ATENDIMENTO) AS ANO
        FROM 
            ANGIO ag
        WHERE EXISTS (
            SELECT 1 
            FROM DBAMV.ATENDIME a
            WHERE ag.CD_PACIENTE = a.CD_PACIENTE 
              AND ag.DT_ATENDIMENTO < a.DT_ATENDIMENTO 
        )
        --     DBAMV.ATENDIME a
        -- WHERE EXISTS (
        --     SELECT 1 
        --     FROM ANGIO ag 
        --     WHERE a.CD_PACIENTE = ag.CD_PACIENTE 
        --       AND a.DT_ATENDIMENTO > ag.DT_ATENDIMENTO 
        -- )
        -- INNER JOIN ANGIO ag
        --     ON a.CD_PACIENTE = ag.CD_PACIENTE AND a.DT_ATENDIMENTO > ag.DT_ATENDIMENTO
),
SEM_ATEND_SEGUINTE
        AS (
        SELECT 
            -- ag.CD_ATENDIMENTO
             ag.CD_PACIENTE
            , ag.DT_ATENDIMENTO
            , EXTRACT(MONTH FROM ag.DT_ATENDIMENTO) AS MES
            , EXTRACT(YEAR FROM ag.DT_ATENDIMENTO) AS ANO
            , ag.NM_CONVENIO
            , ag.nm_prestador
            , ag.DS_CIRURGIA
            , ag.CD_CIRURGIA
            -- , ag.rn
        FROM 
            ANGIO ag
                WHERE NOT EXISTS (
            SELECT 1 
            FROM DBAMV.ATENDIME a
            WHERE ag.CD_PACIENTE = a.CD_PACIENTE 
              AND ag.DT_ATENDIMENTO < a.DT_ATENDIMENTO 
        )
        -- WHERE NOT EXISTS ( SELECT 1 FROM COM_ATEND_SEGUINTE ac WHERE ag.CD_PACIENTE = ac.CD_PACIENTE ) --AND ag.rn = 1
),
QTD_ANGIO
    AS (
        SELECT ANO, MES, COUNT(DISTINCT CD_PACIENTE) AS QTD_ANGIO FROM ANGIO GROUP BY ANO, MES ORDER BY ANO, MES ASC
),
QTD_SEM_ATEND_SEGUINTE
    AS (
        SELECT ANO, MES, COUNT(DISTINCT CD_PACIENTE) AS QTD_SEM_RETORNO FROM SEM_ATEND_SEGUINTE GROUP BY ANO, MES ORDER BY ANO, MES ASC
),
QTD_COM_ATEND_SEGUINTE
    AS (
        SELECT ANO, MES, COUNT(DISTINCT CD_PACIENTE) AS QTD_COM_RETORNO FROM COM_ATEND_SEGUINTE GROUP BY ANO, MES ORDER BY ANO, MES ASC
)
SELECT -- SEM_ATEND_SEGUINTE
    p.CD_PACIENTE
    , sas.DT_ATENDIMENTO
    , MES
    , ANO
    , sas.NM_CONVENIO
    , sas.nm_prestador
    , sas.CD_CIRURGIA
    , sas.DS_CIRURGIA
    , p.TP_SEXO
    , p.NM_PACIENTE
    , p.NR_DDD_FONE
    , p.NR_FONE
    , p.NR_FONE_COMERCIAL
    , p.NR_DDD_CELULAR
    , p.NR_CELULAR
FROM
    SEM_ATEND_SEGUINTE sas
INNER JOIN DBAMV.PACIENTE p
    ON sas.CD_PACIENTE = p.CD_PACIENTE
WHERE sas.ANO=2023
GROUP BY 
    p.CD_PACIENTE
    , sas.DT_ATENDIMENTO
    , MES
    , ANO
    , sas.NM_CONVENIO
    , sas.nm_prestador
    , sas.CD_CIRURGIA
    , sas.DS_CIRURGIA
    , p.TP_SEXO
    , p.NM_PACIENTE
    , p.NR_DDD_FONE
    , p.NR_FONE
    , p.NR_FONE_COMERCIAL
    , p.NR_DDD_CELULAR
    , p.NR_CELULAR
ORDER BY sas.ANO, sas.MES
;


SELECT -- METRICA POR PERÍODO
    a.ANO
    , a.MES
    , b.QTD_SEM_RETORNO
    , c.QTD_COM_RETORNO
    , (SUM( b.QTD_SEM_RETORNO) + SUM(c.QTD_COM_RETORNO)) AS SOMA
    , a.QTD_ANGIO
    , (SUM( b.QTD_SEM_RETORNO) + SUM(c.QTD_COM_RETORNO)) - a.QTD_ANGIO AS DIF
    , TO_CHAR((a.QTD_ANGIO - b.QTD_SEM_RETORNO) / a.QTD_ANGIO* 100, '99.99') PERC
FROM QTD_ANGIO a 
LEFT JOIN QTD_SEM_ATEND_SEGUINTE b ON a.ANO = b.ANO AND a.MES = b.MES
LEFT JOIN QTD_COM_ATEND_SEGUINTE c ON a.ANO = c.ANO AND a.MES = c.MES
WHERE a.ANO=2023
GROUP BY a.ANO, a.MES, a.QTD_ANGIO, b.QTD_SEM_RETORNO, c.QTD_COM_RETORNO
ORDER BY a.ANO, a.MES
;




-- QUERY VERIFICACAO DOS 'TP_ATENDIMENTO' QUE POSSUEM 'CD_ESPECIALID'
SELECT DISTINCT a.TP_ATENDIMENTO FROM DBAMV.ATENDIME a WHERE a.CD_ESPECIALID IS NOT NULL ;

-- QUERY VERIFICACAO DOS ATENDIMENTOS SEM 'CD_ESPECIALID'
SELECT * FROM DBAMV.ATENDIME a WHERE a.CD_ESPECIALID IS NULL ;


SELECT
    a.CD_ATENDIMENTO
    , a.DT_ATENDIMENTO
    , e.DS_ESPECIALID
FROM
    DBAMV.ATENDIME a
INNER JOIN DBAMV.ESPECIALID e
    ON a.CD_ESPECIALID = e.CD_ESPECIALID
WHERE e.DS_ESPECIALID IS NULL
ORDER BY 1
;


-- TABELAS QUE "ATENDIME" NA COMPOSIÇÃO DO NOME DA TABLEA
SELECT * FROM user_tab_columns WHERE TABLE_NAME LIKE '%ATENDIME%';

-- TABELAS QUE "ATENDIME" NA COMPOSIÇÃO DO NOME DA COLUNA
SELECT * FROM user_tab_columns WHERE COLUMN_NAME LIKE '%ENCAI%';


lista_tabelas_postgres = ['doc_pep', 'atendime', 'unidade', 'leito', 'setor', 'mot_alt', 'paciente', 'prestador' ]



SELECT 
    p.CD_PACIENTE
    , p.NM_PACIENTE
    , p.CD_CIDADE
    , p.CD_NATURALIDADE
    , c.CD_CIDADE
    , c.NM_CIDADE
FROM
    DBAMV.PACIENTE p
LEFT JOIN DBAMV.CIDADE c
    ON p.CD_CIDADE = c.CD_CIDADE
WHERE c.CD_CIDADE = 6468 ;

SELECT c.cd_cidade, c.NM_CIDADE FROM DBAMV.CIDADE c WHERE c.CD_CIDADE = 6468 ;

SELECT * FROM DBASGU.MENU WHERE CD_MODULO = 'M_ENTRADA_SERV' ;