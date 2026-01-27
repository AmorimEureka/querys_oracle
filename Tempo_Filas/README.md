Revisão dos Indicadores do HPC-CLINICA-Tempo Médio de Atendimento
=============================================================

<br>
<br>

### STACKS:

[![Oracle Thick Mode](https://img.shields.io/badge/Oracle-Thick%20Mode-red?logo=oracle&logoColor=white)](https://cx.oracletutorial.com/oracle-net/thick-vs-thin-driver/)
[![DBeaver](https://img.shields.io/badge/DBeaver-Tool-372923?logo=dbeaver&logoColor=white)](https://dbeaver.io/)
![Power Bi](https://img.shields.io/badge/power_bi-F2C811?&logo=powerbi&logoColor=black)
![ProntoCardio](https://img.shields.io/badge/ProntoCardio-004578?logo=heart&logoColor=white)

---


<br>
<br>

# O painel apresenta KPI e Indicadores relacionados ao acompanhamento do tempo de atendimento no hospital.

<br>
<br>

- ## **As metricas acompanhadas são:**

    <details open>
    <summary><strong>TE Consulta:</strong></summary>
    <p></p>

    - É o tempo médio de ESPERA para CHAMADA de Exames de Imagem, Laboratório ou Atedimento Médico;
    - No painel foi calculado com a formula DAX abaixo e o cálculo da média de forma implícita:
        ```sql
            IF(
                'Tempo de Processo'[IMG_FINAL],
                DATEDIFF('Tempo de Processo'[ADM_FINAL],'Tempo de Processo'[IMG_CHAMADA],MINUTE),
                IF(
                    'Tempo de Processo'[LAB_FINAL],
                    DATEDIFF('Tempo de Processo'[ADM_FINAL],'Tempo de Processo'[LAB_CHAMADA],MINUTE),
                    DATEDIFF('Tempo de Processo'[ADM_FINAL],'Tempo de Processo'[MÉD_CHAMADA],MINUTE)
            ))
        ```

        > Sobre o cálculo:

        - A formula verifica se existe TEMPO FINAL do **Exame de Imagem**,  então calcula a diferença entre o TEMPO FINAL
        DO ATENDIMENTO ADMNISTRATIVO DA RECEPÇÃO e o TEMPO CHAMADA DO EXAME DE IMAGEM em minutos.
        - Caso a condição NÃO seja satisfeita, é feita nova verificação sobre o TEMPO FINAL do **Exame de Labotório** para
        calcular a diferença entre o TEMPO FINAL DO ATENDIMENTO ADMINISTRATIVO DA RECEPÇÃO e o TEMPO DE CHAMADADA DO EXAME DE
        LABORATÓRIO em minutos.
        - Quando nenhuma das condições é satisfeita, é calculado a diferença entre o TEMPO FINAL DO ATENDIMENTO ADMINISTRATIVO DA
        RECEPÇÃO e o TEMPO DE CHAMADA DO ATENDIMENTO MEDICO em minutos.
    </details>

    <br>
    <br>

    <details open>
    <summary><strong>TA Consulta:</strong></summary>
    <p></p>

    - Tempo Médio de ATENDIMENTO para realização de Exames de Imagem, Laboratório ou Atedimento Médico;
    - No painel foi calculado com a formula DAX abaixo e o cálculo da média de forma implícita:
        ```sql
            IF(
                'Tempo de Processo'[IMG_FINAL],
                DATEDIFF('Tempo de Processo'[IMG_INÍCIO],'Tempo de Processo'[IMG_FINAL],MINUTE),
                IF(
                    'Tempo de Processo'[LAB_FINAL],
                    DATEDIFF('Tempo de Processo'[LAB_INÍCIO],'Tempo de Processo'[LAB_FINAL],MINUTE),
                    DATEDIFF('Tempo de Processo'[MÉD_CHAMADA],'Tempo de Processo'[MÉD_FINAL],MINUTE)
            ))
        ```

        > Sobre o cálculo:

        - A formula verifica se existe TEMPO FINAL do **Exame de Imagem** e então calcula a diferença entre o TEMPO INICIAL e
        FINAL DO EXAME DE IMAGEM em minutos;
        - Caso a condição NÃO seja satisfeita, é feita nova verificação sobre o TEMPO FINAL do **Exame de Labotório** para então
        calcular a diferença entre o TEMPO INICIAL e o TEMPO FINAL DO EXAME em minutos.
        - Quando nenhuma das condições é satisfeita, é calculada a diferença entre o TEMPO CHAMADA DO MEDICO e o TEMPO FINAL DO MEDICO
        em minutos.

    </details>

    <br>
    <br>

    <details open>
    <summary><strong>TE Guichê:</strong></summary>
    <p></p>

    - É o tempo médio de ESPERA para o Guichê realizar a CHAMADA para o atendimento administrativo da recepção;
    - No painel foi calculado com a formula DAX abaixo e o cálculo da média de forma implícita:
        ```sql
            DATEDIFF('Tempo de Processo'[CAD_TOTEM],'Tempo de Processo'[ADM_CHAMADA],MINUTE)
        ```

        > Sobre o cálculo:

        - A formula calcula a diferença entre o TEMPO CADASTRO NO TOTEM e o TEMPO DE CHAMADA DO ATENDIMENTO ADMINISTRATIVO DA RECEPÇÃO

    </details>

    <br>
    <br>

    <details open>
    <summary><strong>TA Guichê:</strong></summary>
    <p></p>

    - É o tempo médio de ATENDIMENTO para o guichê realizar o ATENDIMENTO administrativo da recepção;
    - No painel foi calculado com a formula DAX abaixo e o cálculo da média de forma implícita:
        ```sql
            DATEDIFF('Tempo de Processo'[ADM_INÍCIO],'Tempo de Processo'[ADM_FINAL],MINUTE)
        ```

        > Sobre o cálculo:

        - A formula calcula a diferença entre o TEMPO INICIO DO ATENDIMENTO ADMINISTRATIVO DA RECEPÇÃO e o
        TEMPO CHAMADA DO ATENDIMENTO ADMINISTRATIVO DA RECEPÇÃO

    </details>

    <br>
    <br>

> [!IMPORTANT]
> No painel os calculos podem ser agrupados por:

- Granularidade de Tempo (Mês, Trimestre e Ano);
- Por Atendente;
- Por Médico;
- Por Clinica;
- Por Prioridade do Paciente;
- Também é fornecida visões mais análiticas,

    <br>
    <br>


> [!CAUTION]
> CONSIDERAÇÕES:

- A forma como os cálculos foram criados apresenta falha lógica, pois retorna apenas um dos valores que serão manipulados por CROSS FILTER
nos visuais, e isso não evidência os tempos entre as etapas exatas de cada tipo de atendimento, pois espera-se o tempo entre os processos que
compõem o fluxo de atendimento, independentemente do tipo de fila.


<br>
<br>

<br>
<br>

# Querys do painel


- ## **Modelo ER:**

    ![Diagrama ER](TEMPOS.png)

    <br>
    <br>

- ## **Querys:**

    <details open>
        <summary><strong>Query 'Tempo de Processo:'</strong></summary>
        <p></p>

    - A tabela `sacr_tempo_processo` contém os tempos iniciais e finais de cada processo.
    - A tabela `sacr_tipo_tempo_processo` contém a descrição de cada processo.
    - A query retorna os MAIORES tempos de cada processo por atendimento
    - Aparente o objetivo é retornar os maiores tempos de cada processo  com atendimento efetivado, isto é, `CD_ATENDIMENTO IS NOT NULL` para permitir realizar o calculo de tempo entre as etapas no painel.


    ```sql
        SELECT
        stp.cd_triagem_atendimento,
        stp.cd_atendimento,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'CADASTRO NO TOTEM' THEN stp.dh_processo END) AS cad_totem,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO ADMINISTRATIVO CHAMADA' THEN stp.dh_processo END) AS adm_chamada,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO ADMINISTRATIVO INÍCIO' THEN stp.dh_processo END) AS adm_início,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO ADMINISTRATIVO FINAL' THEN stp.dh_processo END) AS adm_final,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO MÉDICO CHAMADA' THEN stp.dh_processo END) AS méd_chamada,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO MÉDICO INÍCIO' THEN stp.dh_processo END) AS méd_início,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO MÉDICO ALTA' THEN stp.dh_processo END) AS méd_alta,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'ATENDIMENTO MÉDICO FINAL' THEN stp.dh_processo END) AS méd_final,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME IMAGEM CHAMADA' THEN stp.dh_processo END) AS img_chamada,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME DE IMAGEM INÍCIO' THEN stp.dh_processo END) AS img_início,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME DE IMAGEM FINAL' THEN stp.dh_processo END) AS img_final,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME LABORATORIAL INÍCIO' THEN stp.dh_processo END) AS lab_início,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME LABORATORIAL CHAMADA' THEN stp.dh_processo END) AS lab_chamada,
        MAX(CASE WHEN sttp.ds_tipo_tempo_processo = 'EXAME LABORATORIAL FINAL' THEN stp.dh_processo END) AS lab_final
        FROM sacr_tempo_processo stp
        LEFT JOIN sacr_tipo_tempo_processo sttp ON stp.cd_tipo_tempo_processo = sttp.cd_tipo_tempo_processo
        WHERE stp.cd_atendimento IS NOT NULL
        AND stp.cd_triagem_atendimento IS NOT NULL
        GROUP BY stp.cd_triagem_atendimento, stp.cd_atendimento ;

    ```

    <br>
    <br>


    > CONSIDERAÇÕES:

    - Query não permite calcular com precisão os KPI relacionados ao tempo de cada processos de forma real, pois não retorna todos os atendimentos e omite linhas das senhas dos processos de filas que não gerou abertura atendimento.

    <br>
    <br>

    **RESULTADO:**
    <table style="width:100%; border-collapse: collapse; text-align: left;">
        <thead>
            <tr style="background-color: #4CAF50; color: white;">
                <th style="padding: 8px; border: 1px solid #ddd;">Name</th>
                <th style="padding: 8px; border: 1px solid #ddd;">Value</th>
            </tr>
        </thead>
        <tbody>
            <tr style="background-color: #f2f2f2;">
                <td style="padding: 8px; border: 1px solid #ddd;">CD_TRIAGEM_ATENDIMENTO</td>
                <td style="padding: 8px; border: 1px solid #ddd;">263140</td>
            </tr>
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">CD_ATENDIMENTO</td>
                <td style="padding: 8px; border: 1px solid #ddd;">203689</td>
            </tr>
            <tr style="background-color: #f2f2f2;">
                <td style="padding: 8px; border: 1px solid #ddd;">CAD_TOTEM</td>
                <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 16:46:26.000</td>
            </tr>
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">ADM_CHAMADA</td>
                <td style="padding: 8px; border: 1px solid #ddd;"></td>
            </tr>
            <tr style="background-color: #f2f2f2;">
                <td style="padding: 8px; border: 1px solid #ddd;">ADM_INÍCIO</td>
                <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 16:46:49.000</td>
            </tr>
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">ADM_FINAL</td>
                <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 16:51:51.000</td>
            </tr>
            <tr style="background-color: #f2f2f2;">
                <td style="padding: 8px; border: 1px solid #ddd;">MÉD_CHAMADA</td>
                <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 19:12:10.000</td>
            </tr>
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">MÉD_INÍCIO</td>
                <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 17:15:00.000</td>
            </tr>
            <tr style="background-color: #f2f2f2;">
                <td style="padding: 8px; border: 1px solid #ddd;">MÉD_ALTA</td>
                <td style="padding: 8px; border: 1px solid #ddd;"></td>
            </tr>
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">MÉD_FINAL</td>
                <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 17:17:20.000</td>
            </tr>
            <tr style="background-color: #f2f2f2;">
                <td style="padding: 8px; border: 1px solid #ddd;">IMG_CHAMADA</td>
                <td style="padding: 8px; border: 1px solid #ddd;"></td>
            </tr>
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">IMG_INÍCIO</td>
                <td style="padding: 8px; border: 1px solid #ddd;"></td>
            </tr>
            <tr style="background-color: #f2f2f2;">
                <td style="padding: 8px; border: 1px solid #ddd;">IMG_FINAL</td>
                <td style="padding: 8px; border: 1px solid #ddd;"></td>
            </tr>
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">LAB_INÍCIO</td>
                <td style="padding: 8px; border: 1px solid #ddd;"></td>
            </tr>
            <tr style="background-color: #f2f2f2;">
                <td style="padding: 8px; border: 1px solid #ddd;">LAB_CHAMADA</td>
                <td style="padding: 8px; border: 1px solid #ddd;"></td>
            </tr>
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">LAB_FINAL</td>
                <td style="padding: 8px; border: 1px solid #ddd;"></td>
            </tr>
        </tbody>
    </table>


    <br>
    <br>

    <br>
    <br>


</details>



Refatoração:
=============================================================

<details open>
    <summary><strong>Refatoração</strong></summary>
    <p></p>

```sql
WITH TEMPO_TOTEM_CLASS_ADM_MED
    AS (
        -- Armazena os tempos do processo de atendimento do paciente
        SELECT
            stp.CD_TEMPO_PROCESSO,
            stp.CD_TRIAGEM_ATENDIMENTO,
            stp.CD_ATENDIMENTO,
            a.NM_USUARIO,
            a.CD_PRESTADOR,
            a.CD_CONVENIO,
            a.TP_ATENDIMENTO,
            stp.CD_TIPO_TEMPO_PROCESSO,
            stp.DH_PROCESSO
        FROM DBAMV.SACR_TEMPO_PROCESSO stp
        LEFT JOIN DBAMV.ATENDIME a ON stp.CD_ATENDIMENTO = a.CD_ATENDIMENTO

),
TIPO_PROCESSO
    AS (
        -- Armazena os tipos de tempos do processo de atendimento do paciente
        SELECT
            sttp.CD_TIPO_TEMPO_PROCESSO,
            sttp.DS_TIPO_TEMPO_PROCESSO
        FROM DBAMV.SACR_TIPO_TEMPO_PROCESSO sttp
),
TRIAGEM
    AS (
        -- Cadastramento de pre-atendimento para classificacao de risco
        SELECT
            ta.CD_TRIAGEM_ATENDIMENTO,
            ta.CD_ATENDIMENTO,
            ta.CD_FILA_SENHA,
            ta.CD_FILA_PRINCIPAL,
            ta.CD_SETOR,
            -- ta.CD_USUARIO,
            a.NM_USUARIO,
            a.CD_PRESTADOR,
            a.CD_CONVENIO,
            a.TP_ATENDIMENTO,
            ta.DS_SENHA,
            ta.DH_PRE_ATENDIMENTO,
            ta.DH_PRE_ATENDIMENTO_FIM,
            ta.DH_CHAMADA_CLASSIFICACAO,
            ta.DH_REMOVIDO
        FROM DBAMV.TRIAGEM_ATENDIMENTO ta
        LEFT JOIN DBAMV.ATENDIME a ON ta.CD_ATENDIMENTO = a.CD_ATENDIMENTO
),
FILA
    AS (
        SELECT
            fs.CD_FILA_SENHA,
            fs.DS_FILA
        FROM DBAMV.FILA_SENHA fs
),
CLASSIFICACAO_RISCO
    AS (
        SELECT
            scr.CD_TRIAGEM_ATENDIMENTO,
            scr.CD_CLASSIFICACAO_RISCO,
            scr.CD_CLASSIFICACAO,
            scr.CD_COR_REFERENCIA,
            scr.DH_CLASSIFICACAO_RISCO
        FROM DBAMV.SACR_CLASSIFICACAO_RISCO scr
),
CLASSIFICACAO
    AS (
        SELECT
            sc.CD_CLASSIFICACAO,
            sc.DS_TIPO_RISCO
        FROM DBAMV.SACR_CLASSIFICACAO sc
),
COR
    AS (
        SELECT
            scr.CD_COR_REFERENCIA,
            scr.NM_COR,
            scr.DS_RGB_DECIMAL,
            scr.DS_RGB_HEXADECIMAL
        FROM DBAMV.SACR_COR_REFERENCIA scr
),
USUARIO
    AS (
        SELECT
            CD_USUARIO,
            NM_USUARIO
        FROM DBASGU.USUARIOS
),
PRESTADORESS
    AS (
        SELECT
            CD_PRESTADOR,
            NM_PRESTADOR
        FROM DBAMV.PRESTADOR
),
CONVENIOS
    AS (
        SELECT
            CD_CONVENIO,
            NM_CONVENIO
        FROM DBAMV.CONVENIO
),
PROCESSO_COM_TRIAGEM
     AS (
        SELECT
            tcam.CD_TEMPO_PROCESSO,
            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO,
            tcam.CD_PRESTADOR,
            tcam.CD_CONVENIO,
            tcam.TP_ATENDIMENTO,
            tcam.NM_USUARIO,
            tcam.CD_TIPO_TEMPO_PROCESSO,
            COALESCE(tcam.DH_PROCESSO, tri.DH_PRE_ATENDIMENTO) AS DH_PROCESSO

        FROM TEMPO_TOTEM_CLASS_ADM_MED tcam
        INNER JOIN TRIAGEM tri ON tri.CD_TRIAGEM_ATENDIMENTO = tcam.CD_TRIAGEM_ATENDIMENTO
),
PROCESSO_SEM_TRIAGEM
    AS (
        SELECT
            tcam.*
        FROM TEMPO_TOTEM_CLASS_ADM_MED tcam
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TRIAGEM tri
                WHERE tri.CD_TRIAGEM_ATENDIMENTO = tcam.CD_TRIAGEM_ATENDIMENTO
        )
),
TRIAGEM_SEM_PROCESSO
    AS (
        SELECT
            tri.*
        FROM TRIAGEM tri
        WHERE
            NOT EXISTS (
                SELECT 1
                FROM TEMPO_TOTEM_CLASS_ADM_MED tcam
                WHERE tcam.CD_TRIAGEM_ATENDIMENTO = tri.CD_TRIAGEM_ATENDIMENTO
        )
),
UNION_HIPOTESES
    AS (
        SELECT
            'PROCESSO_COM_TRIAGEM' AS TIPO,
            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO,
            tcam.NM_USUARIO,
            tcam.CD_PRESTADOR,
            tcam.CD_CONVENIO,
            tcam.TP_ATENDIMENTO,
            tcam.CD_TIPO_TEMPO_PROCESSO,
            tcam.DH_PROCESSO
        FROM PROCESSO_COM_TRIAGEM tcam

        UNION ALL

        SELECT
            'PROCESSO_SEM_TRIAGEM' AS TIPO,
            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO,
            tcam.NM_USUARIO,
            tcam.CD_PRESTADOR,
            tcam.CD_CONVENIO,
            tcam.TP_ATENDIMENTO,
            tcam.CD_TIPO_TEMPO_PROCESSO,
            tcam.DH_PROCESSO
        FROM PROCESSO_SEM_TRIAGEM tcam

        UNION ALL

        SELECT
            'TRIAGEM_SEM_PROCESSO' AS TIPO,
            tri.CD_TRIAGEM_ATENDIMENTO,
            tri.CD_ATENDIMENTO,
            tri.NM_USUARIO,
            tri.CD_PRESTADOR,
            tri.CD_CONVENIO,
            tri.TP_ATENDIMENTO,
            NULL AS CD_TIPO_TEMPO_PROCESSO,
            NULL AS DH_PROCESSO
        FROM TRIAGEM_SEM_PROCESSO tri
),
TREATS
    AS (
        SELECT

            tcam.TIPO,

            tcam.CD_TRIAGEM_ATENDIMENTO,
            tcam.CD_ATENDIMENTO,

            CASE
                WHEN tcam.TP_ATENDIMENTO = 'U' THEN 'EMERGÊNCIA'
                WHEN tcam.TP_ATENDIMENTO = 'I' THEN 'INTERNAÇÃO'
                WHEN tcam.TP_ATENDIMENTO = 'A' THEN 'AMBULATÓRIO'
                WHEN tcam.TP_ATENDIMENTO = 'E' THEN 'EXTERNO'
                ELSE NULL
            END AS TP_ATENDIMENTO,

            tri.NM_USUARIO AS CD_USUARIO,
            u.NM_USUARIO,
            p.CD_PRESTADOR,
            p.NM_PRESTADOR,

            c.NM_CONVENIO,

            tcam.DH_PROCESSO,
            -- EXTRACT(MONTH FROM COALESCE(tcam.DH_PROCESSO, tri.DH_PRE_ATENDIMENTO)) AS MES,
            SUBSTR(TO_CHAR(COALESCE(tcam.DH_PROCESSO, tri.DH_PRE_ATENDIMENTO), 'FMMONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE'), 1, 3) AS MES,
            EXTRACT(YEAR  FROM COALESCE(tcam.DH_PROCESSO, tri.DH_PRE_ATENDIMENTO)) AS ANO,

            ROUND((tcam.DH_PROCESSO
                - LAG(tcam.DH_PROCESSO) OVER (
                        PARTITION BY tcam.CD_TRIAGEM_ATENDIMENTO
                        ORDER BY tcam.DH_PROCESSO
                    )) * 24 * 60, 2) AS INTERVALO_TEMPO,

            CASE
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 20 THEN
                    'TE Guiche'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(21, 22) THEN
                    'TA Guiche'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 30 THEN
                    'TE Consulta'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(31, 32, 90) THEN
                    'TA Consulta'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 50 THEN
                    'TE Exame Laboratorio'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(51, 52) THEN
                    'TA Exame Laboratorio'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 60 THEN
                    'TE Exame Imagem'
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(61, 62) THEN
                    'TA Exame Imagem'
                ELSE NULL
            END AS CLASSIFICACAO_PROCESSO,

            CASE
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 20 THEN
                    1
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(21, 22) THEN
                    2
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 30 THEN
                    3
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(31, 32, 90) THEN
                    4
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 50 THEN
                    5
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(51, 52) THEN
                    6
                WHEN tp.CD_TIPO_TEMPO_PROCESSO = 60 THEN
                    7
                WHEN tp.CD_TIPO_TEMPO_PROCESSO IN(61, 62) THEN
                    8
            END AS ORDEM_PROCESSO,

            tcam.CD_TIPO_TEMPO_PROCESSO,
            tp.DS_TIPO_TEMPO_PROCESSO,
            tri.DH_PRE_ATENDIMENTO,
            tri.DH_PRE_ATENDIMENTO_FIM,
            tri.DH_CHAMADA_CLASSIFICACAO,
            tri.DH_REMOVIDO,
            tri.DS_SENHA,
            -- fs.DS_FILA,

            COALESCE(
                CASE
                    WHEN fs.CD_FILA_SENHA IN (2, 21, 3, 20)       THEN 'CLINICA 1'
                    WHEN fs.CD_FILA_SENHA IN (12, 22, 13, 19)     THEN 'CLINICA 2'
                    WHEN fs.CD_FILA_SENHA = 1                  THEN 'URGENCIA/EMERGENCIA'
                    ELSE NULL
                END,
                CASE
                    WHEN REGEXP_LIKE(fs.DS_FILA, '2') THEN 'CLINICA 2'
                    ELSE 'CLINICA 1'
                END
            ) AS CLINICA,

            CASE
                WHEN fs.CD_FILA_SENHA IN (2, 21, 12, 22)   THEN 'CONSULTA'
                WHEN fs.CD_FILA_SENHA IN (3, 20, 13, 19)   THEN 'EXAME'
                WHEN fs.CD_FILA_SENHA IN (4, 14)           THEN 'MARCAÇÃO CONSULTA/EXAMES'
                WHEN fs.CD_FILA_SENHA IN (7, 17)           THEN 'RETIRADA MAPA e HOLTER'
                WHEN fs.CD_FILA_SENHA IN (6,16)            THEN 'SOLICITAÇÃO DE DOCUMENTOS'
                WHEN fs.CD_FILA_SENHA = 23                 THEN 'ASO'
                ELSE fs.DS_FILA
            END AS FILA,

            sc.DS_TIPO_RISCO,
            co.NM_COR

        FROM UNION_HIPOTESES tcam
        LEFT JOIN TIPO_PROCESSO tp        ON tcam.CD_TIPO_TEMPO_PROCESSO  = tp.CD_TIPO_TEMPO_PROCESSO
        LEFT JOIN TRIAGEM tri             ON tcam.CD_TRIAGEM_ATENDIMENTO  = tri.CD_TRIAGEM_ATENDIMENTO

        LEFT JOIN FILA fs                 ON tri.CD_FILA_SENHA            = fs.CD_FILA_SENHA
        LEFT JOIN CLASSIFICACAO_RISCO scr ON tri.CD_TRIAGEM_ATENDIMENTO   = scr.CD_TRIAGEM_ATENDIMENTO
        LEFT JOIN CLASSIFICACAO sc        ON scr.CD_CLASSIFICACAO         = sc.CD_CLASSIFICACAO
        LEFT JOIN COR co                  ON scr.CD_COR_REFERENCIA        = co.CD_COR_REFERENCIA

        LEFT JOIN USUARIO u               ON tcam.NM_USUARIO              = u.CD_USUARIO
        LEFT JOIN PRESTADORESS p          ON tcam.CD_PRESTADOR            = p.CD_PRESTADOR
        LEFT JOIN CONVENIOS c             ON tcam.CD_CONVENIO             = c.CD_CONVENIO
        WHERE
            -- tcam.DH_PROCESSO > TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
            tcam.DH_PROCESSO >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12) AND
            tcam.DH_PROCESSO <  ADD_MONTHS(TRUNC(SYSDATE, 'MM'),  1)
),
AGRUPAMENTOS
    AS (
        SELECT
            TIPO,
            TO_DATE(DH_PROCESSO) AS DT,
            MES,
            ANO,
            NM_CONVENIO,
            TP_ATENDIMENTO,
            NM_USUARIO,
            NM_PRESTADOR,
            CLINICA,
            FILA,
            ORDEM_PROCESSO,
            CLASSIFICACAO_PROCESSO,
            NM_COR,
            SUM(INTERVALO_TEMPO) AS TEMPO_MINUTOS,
            COUNT(DISTINCT CD_TRIAGEM_ATENDIMENTO) AS QTD
        FROM TREATS
        WHERE
            INTERVALO_TEMPO IS NOT NULL
        GROUP BY
            TIPO,
            TO_DATE(DH_PROCESSO),
            NM_USUARIO,
            NM_PRESTADOR,
            MES,
            ANO,
            NM_CONVENIO,
            TP_ATENDIMENTO,
            CLINICA,
            FILA,
            ORDEM_PROCESSO,
            CLASSIFICACAO_PROCESSO,
            NM_COR
)
SELECT
    TIPO,
    DT,
    MES,
    ANO,
    NM_CONVENIO,
    TP_ATENDIMENTO,
    NM_USUARIO,
    NM_PRESTADOR,
    CLINICA,
    FILA,
    ORDEM_PROCESSO,
    CLASSIFICACAO_PROCESSO,
    NM_COR,
    CASE
        WHEN TEMPO_MINUTOS <   5 THEN 'Até 5 min'
        WHEN TEMPO_MINUTOS <  10 THEN 'Até 10 min'
        WHEN TEMPO_MINUTOS <  15 THEN 'Até 15 min'
        WHEN TEMPO_MINUTOS <  20 THEN 'Até 20 min'
        WHEN TEMPO_MINUTOS <  30 THEN 'Até 30 min'
        WHEN TEMPO_MINUTOS <  40 THEN 'Até 40 min'
        WHEN TEMPO_MINUTOS <  60 THEN 'Até 1h'
        WHEN TEMPO_MINUTOS < 120 THEN 'Até 2h'
        WHEN TEMPO_MINUTOS < 180 THEN 'Até 3h'
        WHEN TEMPO_MINUTOS < 240 THEN 'Até 4h'
        WHEN TEMPO_MINUTOS < 300 THEN 'Até 5h'
        WHEN TEMPO_MINUTOS < 360 THEN 'Até 6h'
        ELSE '> 6h'
    END AS BUCKET_TEMP,
    TEMPO_MINUTOS,
    QTD
FROM AGRUPAMENTOS
ORDER BY
    TIPO,
    DT,
    TP_ATENDIMENTO,
    NM_CONVENIO,
    NM_USUARIO,
    NM_PRESTADOR,
    MES,
    ANO,
    ORDEM_PROCESSO
;

```
<br>
<br>

**RESULTADO CORRETO:**

<table style="width:100%; border-collapse: collapse; text-align: left;">
    <thead>
        <tr style="background-color: #4CAF50; color: white;">
            <th style="padding: 8px; border: 1px solid #ddd;">CD_TRIAGEM_ATENDIMENTO</th>
            <th style="padding: 8px; border: 1px solid #ddd;">CD_ATENDIMENTO</th>
            <th style="padding: 8px; border: 1px solid #ddd;">DS_TIPO_TEMPO_PROCESSO</th>
            <th style="padding: 8px; border: 1px solid #ddd;">DH_PROCESSO</th>
            <th style="padding: 8px; border: 1px solid #ddd;">INTERVALO_TEMPO</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">263140</td>
            <td style="padding: 8px; border: 1px solid #ddd;">203689</td>
            <td style="padding: 8px; border: 1px solid #ddd;">CADASTRO NO TOTEM</td>
            <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 16:46:26.000</td>
            <td style="padding: 8px; border: 1px solid #ddd;"></td>
        </tr>
        <tr>
            <td style="padding: 8px; border: 1px solid #ddd;">263140</td>
            <td style="padding: 8px; border: 1px solid #ddd;">203689</td>
            <td style="padding: 8px; border: 1px solid #ddd;">ATENDIMENTO ADMINISTRATIVO INÍCIO</td>
            <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 16:46:49.000</td>
            <td style="padding: 8px; border: 1px solid #ddd;">0.38</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">263140</td>
            <td style="padding: 8px; border: 1px solid #ddd;">203689</td>
            <td style="padding: 8px; border: 1px solid #ddd;">ATENDIMENTO ADMINISTRATIVO FINAL</td>
            <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 16:51:51.000</td>
            <td style="padding: 8px; border: 1px solid #ddd;">5.03</td>
        </tr>
        <tr>
            <td style="padding: 8px; border: 1px solid #ddd;">263140</td>
            <td style="padding: 8px; border: 1px solid #ddd;">203689</td>
            <td style="padding: 8px; border: 1px solid #ddd;">ATENDIMENTO MÉDICO INÍCIO</td>
            <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 17:15:00.000</td>
            <td style="padding: 8px; border: 1px solid #ddd;">23.15</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">263140</td>
            <td style="padding: 8px; border: 1px solid #ddd;">203689</td>
            <td style="padding: 8px; border: 1px solid #ddd;">ATENDIMENTO MÉDICO FINAL</td>
            <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 17:17:20.000</td>
            <td style="padding: 8px; border: 1px solid #ddd;">2.33</td>
        </tr>
        <tr>
            <td style="padding: 8px; border: 1px solid #ddd;">263140</td>
            <td style="padding: 8px; border: 1px solid #ddd;">203689</td>
            <td style="padding: 8px; border: 1px solid #ddd;">ATENDIMENTO MÉDICO CHAMADA</td>
            <td style="padding: 8px; border: 1px solid #ddd;">2025-03-22 19:12:10.000</td>
            <td style="padding: 8px; border: 1px solid #ddd;">114.83</td>
        </tr>
    </tbody>
</table>


</details>
