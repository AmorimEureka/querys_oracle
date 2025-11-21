

RELATORIO DE GUIAS FUSMA
===

<br>
<br>

### TELAS MV PARA APOIO DE VALIDAÇÃO:
- M_REMESSA_FFCV
- M_LAN_AMB_PARTICULAR
- M_TUSS_FFCV

<br>

### OCORRENCIAS VALIDADAS:

<details open>
    <summary><strong>REGRAS:</strong></summary>

- **ATENDIMENTO C/ CONSULTAS e EXAMES NA MESMA COMPETENCIA:**
    - Agrupar ``VL_TOTAL_CONTA`` pelo procedimento principal:
        - Código procedimento da Consulta
        - Descrição da Consulta
        - Guia da Consulta
        - Carteira da Consulta

<br>

- **ATENDIMENTO C/ CONSULTAS e EXAMES EM COMPETENCIAS DIFERENTES:**
    - Código procedimento da Consulta/Exames
    - Descrição da Consulta/Exames
    - Guia da Consulta/Exames
    - Carteira da Consulta/Exames
</details>

<br>
<br>

<details open>
    <summary><strong>CASES:</strong></summary>

<br>

- ***Atendimento 238738** com remessas pertencentes a faturas/competências distintas:*

        - 14375 - TC - ANGIOTOMOGRAFIA CORONARIANA [EXAME]
        - 13657 - PS - ESPECIALIDADE CARDIOLOGIA   [CONSULTA]
        > [!NOTE] Para casos em que a segunda remessa tenha exames com guias distintas, retorna
        > ambas as linhas com suas respectivas descrições do procedimento, guia e carteira

<br>


- ***DE_PARA** das tabelas ``PRO_FAT`` e ``TUSS`` para retornar descrição do procedimento faturado*

<ul style="list-style-type: none;">
<table style="width:100%; border-collapse: collapse; text-align: left;">
    <thead>
        <tr style="background-color: #4CAF50; color: white;">
            <th style="padding: 8px; border: 1px solid #ddd;">CD_REMESSA</th>
            <th style="padding: 8px; border: 1px solid #ddd;">TIPO</th>
            <th style="padding: 8px; border: 1px solid #ddd;">CD_PRO_FAT</th>
            <th style="padding: 8px; border: 1px solid #ddd;">CD_TUSS</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">14764</td>
            <td style="padding: 8px; border: 1px solid #ddd;">CONSULTA</td>
            <td style="padding: 8px; border: 1px solid #ddd;">00040105</td>
            <td style="padding: 8px; border: 1px solid #ddd;">10101012</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">14764</td>
            <td style="padding: 8px; border: 1px solid #ddd;">CONSULTA</td>
            <td style="padding: 8px; border: 1px solid #ddd;">00040108</td>
            <td style="padding: 8px; border: 1px solid #ddd;">10101012</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">14764</td>
            <td style="padding: 8px; border: 1px solid #ddd;">CONSULTA</td>
            <td style="padding: 8px; border: 1px solid #ddd;">00040109</td>
            <td style="padding: 8px; border: 1px solid #ddd;">10101012</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 8px; border: 1px solid #ddd;">14050</td>
            <td style="padding: 8px; border: 1px solid #ddd;">EXAME</td>
            <td style="padding: 8px; border: 1px solid #ddd;">40901361</td>
            <td style="padding: 8px; border: 1px solid #ddd;">40901360</td>
        </tr>
    </tbody>
</table>
</details>
</ul>

<br>

- Casos com  Guia, Nome Paciente e Carteira sem valor (NULL):
    - É pois a guia não foi para ``ITREG_AMB`` e ``ITREG_FAT``
    - por não ter CD_GUIA o join não recupera dados do atendimento
      na query final

<br>

- Levantar relação de procedimentos com flag de pacote que não estão
  no CD_GRU_FAT = 8
    - Significa que não foram faturados/cobrados por estarem em pacote
    - Na Urgência/Emergência

<br>
<br>




<details>
    <summary><strong>DETALHAMENTO - ANALITICO</strong></summary>

<br>

```sql
WITH FILTRO AS (
    SELECT
        {V_CODIGO_DA_REMESSA} AS CD_REMESSA
    FROM DUAL
),
JN_ATENDIMENTO
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
            g.NR_GUIA IS NOT NULL
),
JN_REGRA_AMBULATORIO
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
        CROSS JOIN FILTRO
        WHERE
            ra.CD_REMESSA = FILTRO.CD_REMESSA
),
JN_REGRA_HOSPITALAR
    AS (
        SELECT
            rf.CD_ATENDIMENTO,
                CASE
                    WHEN ift.CD_GRU_FAT = 8 THEN
                        COALESCE(FIRST_VALUE(CASE WHEN pf.CD_GRU_PRO = 0 THEN ift.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN pf.CD_GRU_PRO = 0 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), ift.CD_GUIA)
                    WHEN ift.SN_PERTENCE_PACOTE = 'N' THEN
                        COALESCE(FIRST_VALUE(CASE WHEN ift.CD_GRU_FAT = 8 THEN ift.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN ift.CD_GRU_FAT = 8 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), ift.CD_GUIA)

                    ELSE ift.CD_GUIA
                END AS CD_GUIA,
            ift.CD_REG_FAT,
            rf.CD_REMESSA,
            pf.CD_GRU_PRO,
            ift.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            rf.CD_CONVENIO,
            ift.SN_PERTENCE_PACOTE,
            ift.VL_TOTAL_CONTA,
            ift.TP_PAGAMENTO,
            'FATURAMENTO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_FAT ift
        LEFT JOIN DBAMV.PRO_FAT pf 	   ON ift.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_FAT rf 	   ON ift.CD_REG_FAT = rf.CD_REG_FAT
        LEFT JOIN DBAMV.PRESTADOR p    ON ift.CD_PRESTADOR = p.CD_PRESTADOR
        CROSS JOIN FILTRO
        WHERE
            rf.CD_REMESSA = FILTRO.CD_REMESSA
),
JN_UNION_REGRAS
    AS (
        SELECT
            ra.CD_ATENDIMENTO,
            ra.CD_REMESSA,
            ra.CD_GRU_FAT,
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

        FROM JN_REGRA_AMBULATORIO ra
        WHERE ra.SN_PERTENCE_PACOTE = 'N'

        UNION ALL

        SELECT
            rh.CD_ATENDIMENTO,
            rh.CD_REMESSA,
            rh.CD_GRU_FAT,
            rh.CD_GUIA,

            rh.SN_PERTENCE_PACOTE,

            rh.DS_PRO_FAT AS PROCEDIMENTO,
            rh.CD_PRO_FAT AS CODIGO,

            rh.CD_CONVENIO,

            rh.RG_FATURAMENTO AS RG_FATURAMENTO,
            rh.VL_TOTAL_CONTA  AS VL_TOTAL_CONTA,

            CASE WHEN rh.CD_PRO_FAT = '10805048' THEN 1 END UNI,

            ROW_NUMBER() OVER ( PARTITION BY
                    rh.CD_ATENDIMENTO
                ORDER BY rh.CD_GUIA
            ) AS RW

        FROM JN_REGRA_HOSPITALAR rh
        WHERE rh.SN_PERTENCE_PACOTE = 'N'
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
            ur.CD_ATENDIMENTO,
            ur.CD_REMESSA,
            ur.CD_GRU_FAT,
            a.NR_GUIA AS N_GAU,
            a.NM_PACIENTE,

            a.NR_CARTEIRA  AS NIP,

            ur.PROCEDIMENTO,

            COALESCE(t.CD_TUSS, ur.CODIGO) AS CODIGO,

            ur.UNI,
            ur.RW,

            CASE WHEN ur.SN_PERTENCE_PACOTE = 'N' THEN
                SUM(ur.VL_TOTAL_CONTA) OVER ( PARTITION BY ur.CD_ATENDIMENTO )
            ELSE
                SUM(ur.VL_TOTAL_CONTA) OVER ( PARTITION BY ur.CD_ATENDIMENTO, a.NR_GUIA )
            END AS VL_TOTAL_CONTA

        FROM JN_UNION_REGRAS ur
        LEFT JOIN JN_ATENDIMENTO a  ON a.CD_ATENDIMENTO = ur.CD_ATENDIMENTO AND a.CD_GUIA = ur.CD_GUIA
        LEFT JOIN JN_TUSS t ON ur.CODIGO = t.CD_PRO_FAT AND ur.CD_CONVENIO = t.CD_CONVENIO
)
SELECT
    N_GAU,
    NM_PACIENTE,
    NIP,
    PROCEDIMENTO,
    CODIGO,
    CD_REMESSA,
    CD_GRU_FAT,
    VL_TOTAL_CONTA
FROM TREATS
WHERE RW = 1
;
```

<br>

</details>

<br>


<details>
    <summary><strong>AGRUPAMENTO - SINTETICO</strong></summary>

<br>

```sql
SELECT
    PROCEDIMENTO,
    COUNT(1) QTD_PROCEDIMENTOS,
    VL_TOTAL_CONTA,
    VL_TOTAL_CONTA * COUNT(1) AS TOTAL

 FROM (
        WITH FILTRO AS (
            SELECT
                {V_CODIGO_DA_REMESSA} AS CD_REMESSA
            FROM DUAL
    ),
JN_ATENDIMENTO
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
            g.NR_GUIA IS NOT NULL
),
JN_REGRA_AMBULATORIO
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
        CROSS JOIN FILTRO
        WHERE
            ra.CD_REMESSA = FILTRO.CD_REMESSA
),
JN_REGRA_HOSPITALAR
    AS (
        SELECT
            rf.CD_ATENDIMENTO,
                CASE
                    WHEN ift.CD_GRU_FAT = 8 THEN
                        COALESCE(FIRST_VALUE(CASE WHEN pf.CD_GRU_PRO = 0 THEN ift.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN pf.CD_GRU_PRO = 0 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), ift.CD_GUIA)
                    WHEN ift.SN_PERTENCE_PACOTE = 'N' THEN
                        COALESCE(FIRST_VALUE(CASE WHEN ift.CD_GRU_FAT = 8 THEN ift.CD_GUIA END) OVER (
                            PARTITION BY rf.CD_ATENDIMENTO
                            ORDER BY CASE WHEN ift.CD_GRU_FAT = 8 THEN 1 ELSE 2 END
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ), ift.CD_GUIA)

                    ELSE ift.CD_GUIA
                END AS CD_GUIA,
            ift.CD_REG_FAT,
            rf.CD_REMESSA,
            pf.CD_GRU_PRO,
            ift.CD_GRU_FAT,
            pf.CD_PRO_FAT,
            pf.DS_PRO_FAT,
            rf.CD_CONVENIO,
            ift.SN_PERTENCE_PACOTE,
            ift.VL_TOTAL_CONTA,
            ift.TP_PAGAMENTO,
            'FATURAMENTO' AS RG_FATURAMENTO
        FROM DBAMV.ITREG_FAT ift
        LEFT JOIN DBAMV.PRO_FAT pf 	   ON ift.CD_PRO_FAT = pf.CD_PRO_FAT
        LEFT JOIN DBAMV.REG_FAT rf 	   ON ift.CD_REG_FAT = rf.CD_REG_FAT
        LEFT JOIN DBAMV.PRESTADOR p    ON ift.CD_PRESTADOR = p.CD_PRESTADOR
        CROSS JOIN FILTRO
        WHERE
            rf.CD_REMESSA = FILTRO.CD_REMESSA
),
JN_UNION_REGRAS
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

        FROM JN_REGRA_AMBULATORIO ra
        WHERE ra.SN_PERTENCE_PACOTE = 'N'

        UNION ALL

        SELECT
            rh.CD_ATENDIMENTO,
            rh.CD_GUIA,

            rh.SN_PERTENCE_PACOTE,

            rh.DS_PRO_FAT AS PROCEDIMENTO,
            rh.CD_PRO_FAT AS CODIGO,

            rh.CD_CONVENIO,

            rh.RG_FATURAMENTO AS RG_FATURAMENTO,
            rh.VL_TOTAL_CONTA  AS VL_TOTAL_CONTA,

            CASE WHEN rh.CD_PRO_FAT = '10805048' THEN 1 END UNI,

            ROW_NUMBER() OVER ( PARTITION BY
                    rh.CD_ATENDIMENTO
                ORDER BY rh.CD_GUIA
            ) AS RW

        FROM JN_REGRA_HOSPITALAR rh
        WHERE rh.SN_PERTENCE_PACOTE = 'N'
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
            ur.CD_ATENDIMENTO,
            a.NR_GUIA AS N_GAU,
            a.NM_PACIENTE,

            a.NR_CARTEIRA  AS NIP,

            ur.PROCEDIMENTO,

            COALESCE(t.CD_TUSS, ur.CODIGO) AS CODIGO,

            ur.UNI,
            ur.RW,

            CASE WHEN ur.SN_PERTENCE_PACOTE = 'N' THEN
                SUM(ur.VL_TOTAL_CONTA) OVER ( PARTITION BY ur.CD_ATENDIMENTO )
            ELSE
                SUM(ur.VL_TOTAL_CONTA) OVER ( PARTITION BY ur.CD_ATENDIMENTO, a.NR_GUIA )
            END AS VL_TOTAL_CONTA

        FROM JN_UNION_REGRAS ur
        LEFT JOIN JN_ATENDIMENTO a  ON a.CD_ATENDIMENTO = ur.CD_ATENDIMENTO AND a.CD_GUIA = ur.CD_GUIA
        LEFT JOIN JN_TUSS t ON ur.CODIGO = t.CD_PRO_FAT AND ur.CD_CONVENIO = t.CD_CONVENIO
)
SELECT
    *
FROM TREATS
WHERE RW = 1
)
GROUP BY
    PROCEDIMENTO,
    VL_TOTAL_CONTA
```

<br>

</details>