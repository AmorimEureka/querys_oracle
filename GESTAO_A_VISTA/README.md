

METRICA, INDICADORES e KPI - GESTÃO À VISTA
===

<br>
<br>

### STACKS:

[![Oracle Thick Mode](https://img.shields.io/badge/Oracle-Thick%20Mode-red?logo=oracle&logoColor=white)](https://cx.oracletutorial.com/oracle-net/thick-vs-thin-driver/)
[![DBeaver](https://img.shields.io/badge/DBeaver-Tool-372923?logo=dbeaver&logoColor=white)](https://dbeaver.io/)
![HTML](https://img.shields.io/badge/HTML-E34F26?logo=html5&logoColor=white)
![CSS](https://img.shields.io/badge/CSS-1572B6?logo=css3&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-F2C811?logo=powerbi&logoColor=black)
![Power Bi](https://img.shields.io/badge/power_bi-F2C811?&logo=powerbi&logoColor=black)
![ProntoCardio](https://img.shields.io/badge/ProntoCardio-004578?logo=heart&logoColor=white)

---


<br>
<br>

# OS indicadores abaixo serão exibidos em painel interativo apresentado em carrossel em cada uma das UTI's.

<br>
<br>

<table style="width:100%; border-collapse: collapse; text-align: left;">
    <thead>
        <tr style="background-color: #4CAF50; color: white;">
            <th style="padding: 8px; border: 1px solid #ddd;">INDICADOR</th>
            <th style="padding: 8px; border: 1px solid #ddd;">DESCRIÇÃO</th>
            <th style="padding: 8px; border: 1px solid #ddd;">CÁLCULO</th>
            <th style="padding: 8px; border: 1px solid #ddd;">META</th>
            <th style="padding: 8px; border: 1px solid #ddd;">UNIDADE MEDIDA</th>
            <th style="padding: 8px; border: 1px solid #ddd;">FONTE DE DADOS</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">TEMPO MEDIO PERMANENCIA</td>
            <td style="padding: 8px; border: 1px solid #ddd;">Avalia o tempo medio que um paciente permanece internado na UTI adulta do hospital. Esse tempo representa o giro de leitos nas UTI's.</td>
            <td style="padding: 8px; border: 1px solid #ddd;">Σ Nº Paciente-Dia / (Nº Saídas Internas + Nº Saídas Externas) </td>
            <td style="padding: 8px; border: 1px solid #ddd;"> < 4</td>
            <td style="padding: 8px; border: 1px solid #ddd;">DIAS</td>
            <td style="padding: 8px; border: 1px solid #ddd;">ORACLE MV</td>
        </tr>
        <tr>
            <td style="padding: 8px; border: 1px solid #ddd;">INCIDENCIA DE LESAO POR PRESSAO</td>
            <td style="padding: 8px; border: 1px solid #ddd;">Monitora a ocorrencia de lesao por pressao adquirida durante a internacao hospitalar, com foco na prevencao, seguranca do paciente e qualidade da assistencia de enfermagem.</td>
            <td style="padding: 8px; border: 1px solid #ddd;"> (Σ Nº Paciente com LPP na Unidade / Nº Total de Pacientes internados) * 100 </td>
            <td style="padding: 8px; border: 1px solid #ddd;"> 2% </td>
            <td style="padding: 8px; border: 1px solid #ddd;">PERCENTUAL</td>
            <td style="padding: 8px; border: 1px solid #ddd;">GoogleSheets SCIH</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">TAXA DE MORTALIDADE</td>
            <td style="padding: 8px; border: 1px solid #ddd;">Relacao percentual entre o numero de obitos que ocorreram apos decorridas pelo menos 24 horas da admissao hospitalar do paciente, em um mes, e o numero de pacientes que tiveram saídas do hospital (por alta, obitos, evasao, tranferencias entre internas e externas) no mesmo periodo.</td>
            <td style="padding: 8px; border: 1px solid #ddd;"> (Σ Nº de obitos >= 24h de interncao no periodo / Nº de saídas hospitalares no periodo) * 100 </td>
            <td style="padding: 8px; border: 1px solid #ddd;"> 3% </td>
            <td style="padding: 8px; border: 1px solid #ddd;">PERCENTUAL</td>
            <td style="padding: 8px; border: 1px solid #ddd;">ORACLE MV</td>
        </tr>
        <tr>
            <td style="padding: 8px; border: 1px solid #ddd;">TAXA DE QUEDAS</td>
            <td style="padding: 8px; border: 1px solid #ddd;">Avalia seguranca e monitoramento da ocorrencia de quedas de pacientes durante a internacao, a fim de identificar riscos, promover açoes preventivas e garantir a segurança do paciente .</td>
            <td style="padding: 8px; border: 1px solid #ddd;"> (Σ Nº Quedas + Nº Total Paciente-dia) * 1.000 </td>
            <td style="padding: 8px; border: 1px solid #ddd;"> 0.8% </td>
            <td style="padding: 8px; border: 1px solid #ddd;">PERCENTUAL</td>
            <td style="padding: 8px; border: 1px solid #ddd;">GoogleSheets SCIH</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">TAXA DE INFECÇAO HOSPITALAR (IRAS)</td>
            <td style="padding: 8px; border: 1px solid #ddd;">Mede a proporçao de pacientes intenados que desenvolveram infecçoes relacionadas a assistencia a saude (IRAS) durante sua permanencia hospitalar.</td>
            <td style="padding: 8px; border: 1px solid #ddd;"> (Σ Nº IRAS / Nº Paciente-Dia) * 1.000 </td>
            <td style="padding: 8px; border: 1px solid #ddd;"> < 3/1.000 </td>
            <td style="padding: 8px; border: 1px solid #ddd;">PERCENTUAL</td>
            <td style="padding: 8px; border: 1px solid #ddd;">GoogleSheets SCIH</td>
        </tr>
        <tr>
            <td style="padding: 8px; border: 1px solid #ddd;">TAXA INCIDENCIA DE FLEBITE</td>
            <td style="padding: 8px; border: 1px solid #ddd;">Mede o numero de episodios de flebite (inflamacçao da veia) associada ao uso de cateter venoso periferico.</td>
            <td style="padding: 8px; border: 1px solid #ddd;"> (Σ Nº Casos Flebite / Nº Total cateteres perifericos Inseridos) * 100 </td>
            <td style="padding: 8px; border: 1px solid #ddd;"> < 1 </td>
            <td style="padding: 8px; border: 1px solid #ddd;">PERCENTUAL</td>
            <td style="padding: 8px; border: 1px solid #ddd;">GoogleSheets SCIH</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">EXAMES REALIZADOS FORA DO PRAZO</td>
            <td style="padding: 8px; border: 1px solid #ddd;">Medir tempo entre exames Autorizados e Realizados.</td>
            <td style="padding: 8px; border: 1px solid #ddd;"> (Σ Nº Exames Fora do Prazo + Total de exames Solicitados no Periodo)  * 100 </td>
            <td style="padding: 8px; border: 1px solid #ddd;"> 10% </td>
            <td style="padding: 8px; border: 1px solid #ddd;">PERCENTUAL</td>
            <td style="padding: 8px; border: 1px solid #ddd;">ORACLE MV</td>
        </tr>
    </tbody>
</table>

<br>
<br>

# QUERYS



<details>
    <summary><strong>TAXA MORTALIDADE</strong></summary>
    <p></p>

```sql
/* *******************************************************************************************
 *   TAXA MORTALIDADE
 *   RAZAO ENTRE:
 *      N OBITOS CUJO TEMPO DE INTERNACAO DO PERIODO SEJA >= 24H
 *      N DE SAIDAS INTERNAS (MOVIMENTACOES INTERNAS) + N DE SAIDAS EXTERNAS (ALTAS e OBITOS)
 * *******************************************************************************************
 */
WITH OBITOS
    AS (
        SELECT
            a.CD_ATENDIMENTO ,
            a.TP_ATENDIMENTO ,
            a.SN_OBITO ,
            CASE
                WHEN s.NM_SETOR LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE s.NM_SETOR
            END AS LOCAL,
            a.DT_ALTA ,
            MAX(a.DT_ALTA) OVER( PARTITION BY CASE WHEN s.NM_SETOR LIKE '%POSTO%' THEN 'POSTO' ELSE s.NM_SETOR END, EXTRACT(YEAR FROM a.DT_ALTA) ) AS ULTIMO_OBITO,
            EXTRACT(MONTH FROM a.DT_ALTA) AS MES ,
            EXTRACT(YEAR FROM a.DT_ALTA) AS ANO ,
            ma.TP_MOT_ALTA
        FROM DBAMV.ATENDIME a
        LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
        LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
        WHERE EXTRACT(YEAR FROM a.DT_ALTA) = EXTRACT(YEAR FROM SYSDATE) AND a.SN_OBITO = 'S'
        ORDER BY
            CASE
                WHEN s.NM_SETOR LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE s.NM_SETOR
            END,
            EXTRACT(MONTH FROM a.DT_ALTA),
            EXTRACT(YEAR FROM a.DT_ALTA),
            a.DT_ALTA
),
MOVIMENTACAO_UNIDADES
    AS (
        SELECT
            EXTRACT(MONTH FROM mi.DT_MOV_INT) AS MES,
            EXTRACT(YEAR FROM mi.DT_MOV_INT) AS ANO,
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END AS LOCAL,
            COUNT(*)             AS SAI_TRANSFPARA
        FROM
        DBAMV.MOV_INT mi
        JOIN DBAMV.LEITO l ON mi.CD_LEITO_ANTERIOR = l.CD_LEITO
        JOIN DBAMV.LEITO l1 ON mi.CD_LEITO = l1.CD_LEITO
        JOIN DBAMV.UNID_INT ui ON l.CD_UNID_INT = ui.CD_UNID_INT
        JOIN DBAMV.UNID_INT ui1 ON l1.CD_UNID_INT = ui1.CD_UNID_INT
        JOIN DBAMV.ATENDIME a ON a.CD_ATENDIMENTO = mi.CD_ATENDIMENTO
        WHERE
            mi.TP_MOV = 'O'
            AND ui.CD_UNID_INT <> ui1.CD_UNID_INT
            AND a.TP_ATENDIMENTO IN ('I')
            AND EXTRACT(YEAR FROM mi.DT_MOV_INT) = EXTRACT(YEAR FROM SYSDATE)
        GROUP BY
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END,
            EXTRACT(MONTH FROM mi.DT_MOV_INT),
            EXTRACT(YEAR FROM mi.DT_MOV_INT)
)
SELECT
    o.MES,
    CASE
        WHEN o.MES = 1 THEN 'Jan'
        WHEN o.MES = 2 THEN 'Fev'
        WHEN o.MES = 3 THEN 'Mar'
        WHEN o.MES = 4 THEN 'Abr'
        WHEN o.MES = 5 THEN 'Mai'
        WHEN o.MES = 6 THEN 'Jun'
        WHEN o.MES = 7 THEN 'Jul'
        WHEN o.MES = 8 THEN 'Ago'
        WHEN o.MES = 9 THEN 'Set'
        WHEN o.MES = 10 THEN 'Out'
        WHEN o.MES = 11 THEN 'Nov'
        WHEN o.MES = 11 THEN 'Dez'
    END AS NOME_MES,
    o.ULTIMO_OBITO,
    o.ANO,
    o.LOCAL,
    COUNT(o.CD_ATENDIMENTO) AS QTD_OBITOS,
    m.SAI_TRANSFPARA AS QTD_TRANSFER
FROM OBITOS o
JOIN MOVIMENTACAO_UNIDADES m ON o.MES = m.MES AND o.ANO = m.ANO AND o.LOCAL = m.LOCAL
GROUP BY
    o.MES,
    CASE
        WHEN o.MES = 1 THEN 'Jan'
        WHEN o.MES = 2 THEN 'Fev'
        WHEN o.MES = 3 THEN 'Mar'
        WHEN o.MES = 4 THEN 'Abr'
        WHEN o.MES = 5 THEN 'Mai'
        WHEN o.MES = 6 THEN 'Jun'
        WHEN o.MES = 7 THEN 'Jul'
        WHEN o.MES = 8 THEN 'Ago'
        WHEN o.MES = 9 THEN 'Set'
        WHEN o.MES = 10 THEN 'Out'
        WHEN o.MES = 11 THEN 'Nov'
        WHEN o.MES = 11 THEN 'Dez'
    END,
    o.ULTIMO_OBITO,
    o.ANO,
    m.SAI_TRANSFPARA,
    o.LOCAL
ORDER BY
    o.MES,
    o.ANO,
    m.SAI_TRANSFPARA,
    o.LOCAL
;
```

</details>

<br>
<br>


<details>
    <summary><strong>TEMPO MEDIO DE PERMANENCIA NAS UTI's</strong></summary>
    <p></p>

```sql
WITH UNIDADE_LEITOS
    AS (
        SELECT
            l.CD_LEITO,
            l.DS_LEITO,
            ui.CD_UNID_INT,
            CASE
                WHEN ui.DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE ui.DS_UNID_INT
            END AS LOCAL
            /*+ MATERIALIZE */
        FROM DBAMV.LEITO l
        JOIN DBAMV.UNID_INT ui ON l.CD_UNID_INT = ui.CD_UNID_INT
),
ATENDIMENTO
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            p.CD_PACIENTE,
            a.CD_LEITO,

            CASE
                WHEN a.DT_ALTA IS NOT NULL AND TRUNC(a.DT_ALTA - a.DT_ATENDIMENTO ) = 0 THEN
                    'HOSPITAL-DIA'
                ELSE
                    'NORMAL'
            END AS CLASSIFICACAO,

            EXTRACT(MONTH FROM a.DT_ATENDIMENTO) AS MES ,
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) AS ANO ,
            CASE
                WHEN a.DT_ATENDIMENTO IS NOT NULL AND a.HR_ATENDIMENTO IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ATENDIMENTO, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ATENDIMENTO, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ATENDIMENTO,

            CASE
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ALTA
            /*+ MATERIALIZE */
        FROM DBAMV.ATENDIME a
        LEFT JOIN DBAMV.PACIENTE p ON a.CD_PACIENTE = p.CD_PACIENTE
        WHERE
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            a.TP_ATENDIMENTO IN( 'I', 'U') AND
            p.NM_PACIENTE NOT LIKE '%TEST%'
),
MOVIMENTACAO
    AS (
        SELECT
            mi.CD_ATENDIMENTO,
            mi.CD_LEITO,
            mi.CD_LEITO_ANTERIOR,
            EXTRACT(MONTH FROM mi.DT_MOV_INT) AS MES,
            EXTRACT(YEAR FROM mi.DT_MOV_INT) AS ANO
            /*+ MATERIALIZE */
        FROM DBAMV.MOV_INT mi
        JOIN DBAMV.ATENDIME a ON a.CD_ATENDIMENTO = mi.CD_ATENDIMENTO
        WHERE
            EXTRACT(YEAR FROM mi.DT_MOV_INT) = EXTRACT(YEAR FROM SYSDATE) AND
            a.TP_ATENDIMENTO IN ('I')
),
MEDIANA
    AS (
        SELECT
            a.MES,
            a.ANO,
            ul.LOCAL,

            MEDIAN(TO_NUMBER(DBAMV.fn_idade_paciente(a.CD_PACIENTE, NULL))) AS MEDIANA_IDADE

        FROM ATENDIMENTO a
        JOIN UNIDADE_LEITOS ul ON a.CD_LEITO = ul.CD_LEITO
        GROUP BY
            a.MES,
            a.ANO,
            ul.LOCAL
        ORDER BY
            a.MES,
            a.ANO,
            ul.LOCAL
),
PACIENTE_DIA
    AS (
        SELECT
            a.MES,
            a.ANO,
            ul.LOCAL,
            a.CLASSIFICACAO,

            SUM(
                CASE
                    WHEN COALESCE(TRUNC(a.DH_ALTA), TRUNC(SYSDATE)) - TRUNC(a.DH_ATENDIMENTO) > 0 THEN
                        COALESCE(TRUNC(a.DH_ALTA), TRUNC(SYSDATE)) - TRUNC(a.DH_ATENDIMENTO)
                    ELSE
                        1
                END
             ) AS QTD_PACIENTE_DIA

        FROM ATENDIMENTO a
        JOIN UNIDADE_LEITOS ul ON a.CD_LEITO = ul.CD_LEITO
        GROUP BY
            a.MES,
            a.ANO,
            ul.LOCAL,
            a.CLASSIFICACAO
        ORDER BY
            a.MES,
            a.ANO,
            ul.LOCAL
),
PACIENTE_ALTAS
    AS (
        SELECT
            EXTRACT(MONTH FROM a.DH_ALTA) AS MES,
            EXTRACT(YEAR FROM a.DH_ALTA) AS ANO,
            ul.LOCAL,
            COUNT(*) AS QTD_ALTAS

        FROM ATENDIMENTO a
        JOIN UNIDADE_LEITOS ul ON a.CD_LEITO = ul.CD_LEITO
        WHERE
            a.DH_ALTA IS NOT NULL AND
            EXTRACT(YEAR FROM a.DH_ALTA) = EXTRACT(YEAR FROM SYSDATE)
        GROUP BY
            EXTRACT(MONTH FROM a.DH_ALTA),
            EXTRACT(YEAR FROM a.DH_ALTA),
            ul.LOCAL
        ORDER BY
            EXTRACT(MONTH FROM a.DH_ALTA),
            EXTRACT(YEAR FROM a.DH_ALTA),
            ul.LOCAL
),
MOVI_INTERNA
    AS (
        SELECT
            m.MES,
            m.ANO,
            ul1.LOCAL,
            count(*) QTD_TRANSFPARA

        FROM MOVIMENTACAO m
        JOIN UNIDADE_LEITOS ul ON m.CD_LEITO = ul.CD_LEITO
        JOIN UNIDADE_LEITOS ul1 ON m.CD_LEITO_ANTERIOR = ul1.CD_LEITO
        WHERE ul.CD_UNID_INT <> ul1.CD_UNID_INT
        GROUP BY
            m.MES,
            m.ANO,
            ul1.LOCAL
        ORDER BY
            m.MES
)
SELECT
    pd.MES,
    CASE
        WHEN pd.MES = 1 THEN 'Jan'
        WHEN pd.MES = 2 THEN 'Fev'
        WHEN pd.MES = 3 THEN 'Mar'
        WHEN pd.MES = 4 THEN 'Abr'
        WHEN pd.MES = 5 THEN 'Mai'
        WHEN pd.MES = 6 THEN 'Jun'
        WHEN pd.MES = 7 THEN 'Jul'
        WHEN pd.MES = 8 THEN 'Ago'
        WHEN pd.MES = 9 THEN 'Set'
        WHEN pd.MES = 10 THEN 'Out'
        WHEN pd.MES = 11 THEN 'Nov'
        WHEN pd.MES = 11 THEN 'Dez'
    END AS NOME_MES,
    pd.ANO,
    pd.LOCAL,
    pd.CLASSIFICACAO,
    m.MEDIANA_IDADE,

    pd.QTD_PACIENTE_DIA,
    mi.QTD_TRANSFPARA,
    pa.QTD_ALTAS,

    CASE
        WHEN pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1)  < 1 THEN
            '< 1'
        ELSE
            TO_CHAR(TRUNC( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1) ))
    END AS CLASS_TEMPO_MED,

    CASE
        WHEN TRUNC( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1) ) < 1 THEN
            1
        ELSE
            TRUNC( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1) )
    END AS TEMPO_MEDIO,

    CASE
        WHEN TRUNC( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1) ) < 1 THEN
            ROUND( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1), 2 )
        ELSE
            ROUND( pd.QTD_PACIENTE_DIA  / COALESCE( ( mi.QTD_TRANSFPARA + pa.QTD_ALTAS ), 1), 2 )
    END AS TEMPO_MEDIO_REAL

FROM PACIENTE_DIA pd
JOIN PACIENTE_ALTAS pa ON pd.MES = pa.MES AND pd.ANO = pa.ANO AND pd.LOCAL = pa.LOCAL
JOIN MOVI_INTERNA mi ON pd.MES = mi.MES AND pd.ANO = mi.ANO AND pd.LOCAL = mi.LOCAL
JOIN MEDIANA m ON pd.MES = m.MES AND pd.ANO = m.ANO AND pd.LOCAL = m.LOCAL
ORDER BY
    pd.MES,
    pd.LOCAL
;
```

</details>

<br>
<br>

<details>
    <summary><strong>QTD e TEMPO MEDIO DE ENTUBACAO [JUSTIFICA TEMPO PERMANENCIA]</strong></summary>
    <p></p>

```sql
WITH PRESCRICAO_VM
    AS     (
            SELECT DISTINCT

                pm.CD_ATENDIMENTO,
                pm.CD_UNID_INT,

                MIN(ipm.DH_REGISTRO)
                OVER (
                      PARTITION BY
                        pm.CD_ATENDIMENTO
                    ) AS DT_START,

                MAX(ipm.DH_REGISTRO)
                OVER (
                      PARTITION BY
                        pm.CD_ATENDIMENTO
                    ) AS DT_END,

                tp.CD_TIP_PRESC,
                tp.DS_TIP_PRESC,

                te.CD_TIP_ESQ,
                te.DS_TIP_ESQ

            FROM DBAMV.ITPRE_MED ipm
            JOIN DBAMV.PRE_MED pm       ON ipm.CD_PRE_MED = pm.CD_PRE_MED
            JOIN TIP_PRESC tp           ON ipm.CD_TIP_ESQ = tp.CD_TIP_ESQ
            JOIN DBAMV.TIP_ESQ te       ON ipm.CD_TIP_ESQ = te.CD_TIP_ESQ AND ipm.CD_TIP_PRESC = tp.CD_TIP_PRESC
            WHERE
                te.CD_TIP_ESQ IN( 'PME' ) AND
                tp.CD_TIP_PRESC IN(488) AND
                EXTRACT(YEAR FROM ipm.DH_REGISTRO) = EXTRACT(YEAR FROM SYSDATE)
),
PROTOCOLO_EXTUBACAO
    AS (
        SELECT

            pdc.CD_ATENDIMENTO,
            er.CD_CAMPO,
            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1), '[0-9]+') AS REGX,
            DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1) AS SEM_REGX,
            MAX(pdc.DH_DOCUMENTO) AS HR_DOC_EXTUBACAO

        FROM DBAMV.PW_DOCUMENTO_CLINICO pdc
        INNER JOIN DBAMV.PW_EDITOR_CLINICO pec    ON pec.CD_DOCUMENTO_CLINICO = pdc.CD_DOCUMENTO_CLINICO
        LEFT JOIN DBAMV.EDITOR_REGISTRO_CAMPO er  ON er.CD_REGISTRO = pec.CD_EDITOR_REGISTRO
        LEFT JOIN DBAMV.EDITOR_DOCUMENTO doc      ON pec.CD_DOCUMENTO = doc.CD_DOCUMENTO
        WHERE
            EXTRACT(YEAR FROM pdc.DH_DOCUMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            doc.CD_DOCUMENTO IN ('935') AND
            er.CD_CAMPO IN(442178, 452571)
        GROUP BY
            pdc.CD_ATENDIMENTO,
            er.CD_CAMPO,
            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1), '[0-9]+'),
            DBMS_LOB.SUBSTR(er.LO_VALOR, 4000, 1)
),
ATENDIMENTO
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            CASE
                WHEN a.DT_ATENDIMENTO IS NOT NULL AND a.HR_ATENDIMENTO IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ATENDIMENTO, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ATENDIMENTO, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ATENDIMENTO,
            CASE
                WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL THEN
                    TO_DATE(
                        TO_CHAR(a.DT_ALTA, 'DD/MM/YYYY') || ' ' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),
                        'DD/MM/YYYY HH24:MI:SS'
                    )
                ELSE NULL
            END AS DH_ALTA

        FROM DBAMV.ATENDIME a
        JOIN DBAMV.LEITO l                          ON a.CD_LEITO = l.CD_LEITO
        LEFT JOIN DBAMV.PACIENTE p                  ON a.CD_PACIENTE = p.CD_PACIENTE
        WHERE
            EXTRACT(YEAR FROM a.DT_ATENDIMENTO) = EXTRACT(YEAR FROM SYSDATE) AND
            p.NM_PACIENTE NOT LIKE '%TEST%'
),
 UNIDADE_LEITOS
    AS (
        SELECT
            CD_UNID_INT,
            CASE
                WHEN DS_UNID_INT LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE DS_UNID_INT
            END AS LOCAL
        FROM DBAMV.UNID_INT
),
OBITOS
    AS (
        SELECT
            a.CD_ATENDIMENTO ,
            a.TP_ATENDIMENTO ,
            a.SN_OBITO ,
            CASE
                WHEN s.NM_SETOR LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE s.NM_SETOR
            END AS LOCAL,
            a.HR_ALTA AS HR_OBITO ,
            MAX(a.DT_ALTA) OVER( PARTITION BY CASE WHEN s.NM_SETOR LIKE '%POSTO%' THEN 'POSTO' ELSE s.NM_SETOR END, EXTRACT(YEAR FROM a.DT_ALTA) ) AS ULTIMO_OBITO,
            EXTRACT(MONTH FROM a.DT_ALTA) AS MES ,
            EXTRACT(YEAR FROM a.DT_ALTA) AS ANO ,
            ma.TP_MOT_ALTA
        FROM DBAMV.ATENDIME a
        LEFT JOIN SETOR s ON s.CD_SETOR = a.CD_SETOR_OBITO
        LEFT JOIN DBAMV.MOT_ALT ma ON ma.CD_MOT_ALT = a.CD_MOT_ALT
        WHERE EXTRACT(YEAR FROM a.DT_ALTA) = EXTRACT(YEAR FROM SYSDATE) AND a.SN_OBITO = 'S'
        ORDER BY
            CASE
                WHEN s.NM_SETOR LIKE '%POSTO%' THEN
                    'POSTO'
                ELSE s.NM_SETOR
            END,
            EXTRACT(MONTH FROM a.DT_ALTA),
            EXTRACT(YEAR FROM a.DT_ALTA),
            a.DT_ALTA
),
TREATS
    AS (
        SELECT
            a.CD_ATENDIMENTO,
            a.DH_ATENDIMENTO,
            a.DH_ALTA,

            EXTRACT(MONTH FROM pvm.DT_START) AS MES,
            CASE
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 1 THEN 'Jan'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 2 THEN 'Fev'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 3 THEN 'Mar'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 4 THEN 'Abr'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 5 THEN 'Mai'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 6 THEN 'Jun'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 7 THEN 'Jul'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 8 THEN 'Ago'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 9 THEN 'Set'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 10 THEN 'Out'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 11 THEN 'Nov'
                WHEN EXTRACT(MONTH FROM pvm.DT_START) = 11 THEN 'Dez'
            END AS NOME_MES,

            EXTRACT(YEAR FROM pvm.DT_START) AS ANO,

            uil.CD_UNID_INT,
            uil.LOCAL,
            pvm.DT_START,

            pe.REGX,

            pe.HR_DOC_EXTUBACAO,

            CASE
                WHEN o.TP_MOT_ALTA = 'O' AND o.HR_OBITO IS NOT NULL THEN
                    o.HR_OBITO
                WHEN pe.REGX IS NOT NULL THEN
                    pvm.DT_START + NUMTODSINTERVAL(COALESCE(TO_NUMBER(pe.REGX), 0), 'HOUR')
                WHEN pvm.DT_END IS NOT NULL  THEN
                        CASE
                            WHEN pvm.DT_END = pvm.DT_START AND pe.HR_DOC_EXTUBACAO IS NOT NULL AND pe.REGX IS NULL THEN
                                pe.HR_DOC_EXTUBACAO
                            WHEN pvm.DT_END = pvm.DT_START THEN
                                pvm.DT_START + NUMTODSINTERVAL(COALESCE(TO_NUMBER(pe.REGX), 0), 'HOUR')
                            ELSE pvm.DT_END
                        END
                ELSE
                    SYSDATE
            END AS DT_END,

            o.TP_MOT_ALTA,
            o.HR_OBITO

        FROM PRESCRICAO_VM pvm
        LEFT JOIN ATENDIMENTO a ON pvm.CD_ATENDIMENTO = a.CD_ATENDIMENTO
        LEFT JOIN PROTOCOLO_EXTUBACAO pe ON pvm.CD_ATENDIMENTO = pe.CD_ATENDIMENTO
        LEFT JOIN OBITOS o ON pvm.CD_ATENDIMENTO = o.CD_ATENDIMENTO
        LEFT JOIN UNIDADE_LEITOS uil ON pvm.CD_UNID_INT = uil.CD_UNID_INT
        ORDER BY EXTRACT(MONTH FROM pvm.DT_START)
),
HORAS
    AS (
        SELECT
            CD_ATENDIMENTO,
            DH_ATENDIMENTO,
            DH_ALTA,
            MES,
            NOME_MES,
            ANO,
            CD_UNID_INT,
            LOCAL,
            DT_START,
            REGX,
            HR_DOC_EXTUBACAO,
            DT_END,
            (DT_END - DT_START) * 24 AS DIFF,
            TP_MOT_ALTA,
            HR_OBITO
        FROM TREATS
)
SELECT
    CD_ATENDIMENTO,
    DH_ATENDIMENTO,
    DH_ALTA,
    MES,
    NOME_MES,
    ANO,
    LOCAL,
    DT_START,
    REGX,
    HR_DOC_EXTUBACAO,
    DT_END,
    TP_MOT_ALTA,
    HR_OBITO,
    DIFF,
    CASE
        WHEN DIFF >= 0  AND DIFF <= 4   THEN 1
        WHEN DIFF > 4  AND DIFF <= 10  THEN 2
        WHEN DIFF > 10 AND DIFF <= 15  THEN 3
        WHEN DIFF > 15 AND DIFF <= 24  THEN 4
        WHEN DIFF > 24 AND DIFF <= 48  THEN 5
        WHEN DIFF > 48 AND DIFF <= 96  THEN 6
        WHEN DIFF > 96 AND DIFF <= 240 THEN 7
        ELSE 8
    END AS ORDEM,
    CASE
        WHEN DIFF >= 0  AND DIFF <= 4   THEN '< 4 hora'
        WHEN DIFF > 4  AND DIFF <= 10  THEN '4-10 horas'
        WHEN DIFF > 10 AND DIFF <= 15  THEN '10-15 horas'
        WHEN DIFF > 15 AND DIFF <= 24  THEN '15-24 horas'
        WHEN DIFF > 24 AND DIFF <= 48  THEN '1-2 dias'
        WHEN DIFF > 48 AND DIFF <= 96  THEN '2-5 dias'
        WHEN DIFF > 96 AND DIFF <= 240 THEN '5-10 dias'
        ELSE '> 10 dias'
    END AS FAIXA_TEMPO
FROM HORAS
ORDER BY MES
;
```
</details>


<br>
<br>

# DASHBOARD POWERBI

<br>

[![Dashboard_gif](windows.gif)](https://app.powerbi.com/view?r=eyJrIjoiMWUxODc4NjYtZWM1ZS00YjA1LWE5ODUtNWIxZDgxZTkwZWQ5IiwidCI6ImViNTgxZmZkLTY1YTktNDg3OS1iM2JlLTUzMTc2MzJmOGQzYSJ9)

### * Click na imagem.


<br>
<br>

## PowerBI Carousel (Windows)

Este repositório contém um pequeno sistema para exibir vários painéis públicos do Power BI em tela cheia em um PC ou TV com Windows. O script gera uma página HTML com um carrossel que pré-carrega o próximo painel alguns segundos antes da transição para evitar o flash do ícone de carregamento do PowerBI.

### Arquivos principais
- `powerbi-carousel.ps1` — PowerShell que cria index.html e abre o navegador em modo tela-cheia.
- start-carousel.bat — Atalho para executar o PowerShell sem abrir uma janela.
- `links.txt` — Lista de links públicos do Power BI (um por linha). O script cria este arquivo na primeira execução.
- `index.html` — Gerado automaticamente pelo PowerShell (não precisa editar, a menos que deseje ajustes pontuais).

### Como usar
1. Coloque powerbi-carousel.ps1 e start-carousel.bat no mesmo diretório.
2. Dê um duplo-clique em start-carousel.bat para rodar (ou execute manualmente):
   powershell -ExecutionPolicy Bypass -File .\powerbi-carousel.ps1
   - Na primeira execução será criado links.txt.
3. Abra links.txt e cole seus 5 (ou mais) links públicos do Power BI, um por linha. Use links de "Publish to web" / embed público.
4. Execute start-carousel.bat novamente. O navegador suportado (Edge/Chrome/Brave/Firefox) abrirá em tela cheia e iniciará o carrossel.

### Configurações úteis
- Tempo por slide (DURATION) e tempo de pré-carregamento (PRELOAD_MS) são definidos no JavaScript dentro do index.html gerado. Para ajustar, edite o arquivo index.html ou ajuste os valores no powerbi-carousel.ps1 antes de gerar.
- Se desejar iniciar automaticamente no login do Windows, coloque um atalho para start-carousel.bat em:
  %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
  ou crie uma Tarefa Agendada.

### Observações
- Os links devem ser públicos (Publish to web). Se o iframe pedir login ou não carregar, o link não é público.
- Se ainda aparecer o ícone de loading do Power BI, aumente PRELOAD_MS (ex.: 8000–10000 ms) para pré-carregar mais tempo antes da troca.
- Se o navegador não abrir em kiosk, verifique se Edge/Chrome/Brave/Firefox estão instalados; caso contrário, edite powerbi-carousel.ps1 e aponte para o caminho do executável do seu navegador.
- Para evitar que a tela desligue, desative suspensão e protetor de tela nas Configurações do Windows.

<br>
<br>