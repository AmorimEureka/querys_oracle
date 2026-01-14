

CODE REVIEW TABIA
===

<br>
<br>

### VALIDAÇÃO DAS QUERIES:
- APPOINTMENTS POR PERIODO (AGENDAMENTOS)
- SERVICE REQUEST POR PERIODO (PEDIDOS - EXAMES/CIRURGIAS)
- ENCOUNTERS POR PERIODO (ATENDIMENTOS)
- PACIENTES

<br>

### TELAS DO ERP UTILIZADAS NA VALIDAÇÃO:
- **M_CENTRAL_MARCACOES**
    - Visualizar os horários disponíveis para os itens da agendar (consultas, procedimentos e exames), assim como informações de convênio, paciente e realização dos procedimentos;
    - Essa tela, o profissional do call-center ou da recepção do consultório poderá visualizar os horários para agendamentos de múltiplos itens (exames e consultas) de forma unificada;
    - *Obs.: Para ter acesso a agendamentos realizados pelos sistemas Ambulatório, Diagnóstico de Imagem e Laboratório de Análise Clínicas, é necessário que a configuração "Utiliza o SCMA para Agendamentos Ambulatoriais, Laboratoriais e Diag. Imagem no Sistema", esteja como "Sim".

- **C_AGENDAMENTOS:**
    - Consultar os agendamentos realizados, segundo alguns critérios concernentes a eles, por meio da informação de parâmetros de pesquisa.

- **M_ALTERA_ESCALA:**

- **M_RECEPCAO_MANUT_AGENDA:**

- **FSCC/M_CADASTRO_CIRURGIA:**

- **C_REVISAO_CIRURGIA:**

- **PSDI/M_PED_RX:**
    - Tela para consultar pedidos de exames de imagem

- **M_PEDEXA:**
    - Tela para consultar pedidos de exames de laboratorio

<br>
<br>



# OCORRENCIAS:

<details>
    <summary><strong>⛧ APPOINTMENTS POR PERIODO:</strong></summary>

* OBJETIVO: Listar bukets de agenda de cada lote de agenda das escalas por período
  ---

<br>

* **CÓDIGO DE BUCKETS DA AGENDA REPETIDOS:**

    - **Existe "CD_IT_AGENDA_CENTRAL" se repetindo para atendimentos distintos do mesmo paciente que NÃO POSSUI AGENDAMENTO e para AGENDAMENTOS COM OUTRO "CD_IT_AGENDA_CENTRAL"**
        - Exemplo:
            - CD_IT_AGENDA_CENTRAL = 775793 retorna os CD_ATENDIMENTO:
                - 242685 -> CD_IT_AGENDA_CENTRAL = 775793 ✅
                - 242621 -> CD_IT_AGENDA_CENTRAL = 786669 ❌
                - 242654 -> SEM AGENDAMENTO
                > [!NOTE] O relacionamento entre as tabelas `DBAMV.AGENDA_CENTRAL` e `DBAMV.IT_AGENDA_CENTRAL` é `1:* Obirgatório`

            - **Sugestão de Solução:** Organização do contexto semântico das tabelas envolvidas no tema *'agendamento'* e do problema que queremos resolver.
    ---

<br>
<br>


- **RELACIONAMENTO ENTRE "IT_AGENDA_CENTRAL" e "ATENDIME":**
    - O join entre as tabelas ``IT_AGENDA_CENTRAL`` e ``ATENDIME`` foi estabelecido  por ``CD_PACIENTE`` e ``DT_ATENDIMENTO`` = ``HR_AGENDA``, porém existe relacionamento direto do tipo *`1:* opcional`*, opcional, pois no momento do agendamento ainda não existe o CD_ATENDIMENTO; caso tenha optado por essa relação para garantir consistência entre as tabelas, a trigger `TRG_IT_AGENDA_CENTRAL_ATENDIME` já faz esse trabalho garantindo que essas tabelas tenham o mesmo ``CD_PACIENTE`` e ``CD_CARTEIRA``.

        - **Sugestão de Solução:** Organização do contexto semântico das tabelas envolvidas no tema *'agendamento'* e do problema que queremos resolver.
    ---

<br>
<br>

- **FILTRO NO JOIN DA TABELA ``AGENDA_CENTRAL_ITEM_AGENDA``:**
    - A tabela ``AGENDA_CENTRAL_ITEM_AGENDA`` é middleman do relacionamento ``*:*`` entre as tabelas ``AGENDA_CENTRAL`` e ``ITEM_AGENDAMENTO``, o filtro em `rn=1`, aparentemente, afeta apenas as linhas cujos agendamentos não foram atendidos; sem esse filtro uma agenda seria replicada para todos os possíveis itens de agendamento. Esse é o outro fator que também gera duplicatas de ``CD_IT_AGENDA_CENTRAL``.



        ```sql
            FROM dbamv.it_agenda_central it
            LEFT JOIN AGENDA_CENTRAL agc ON agc.cd_agenda_central = it.cd_agenda_central
            LEFT JOIN (
            SELECT
                aci.*,
                ROW_NUMBER() OVER (
                    PARTITION BY aci.cd_agenda_central
                    ORDER BY aci.cd_item_agendamento ASC
                ) AS rn
            FROM agenda_central_item_agenda aci
            ) aci ON aci.cd_agenda_central = it.cd_agenda_central
            AND aci.rn = 1
        ```
        - **Sugestão de Solução:** Organização do contexto semântico das tabelas envolvidas no tema *'agendamento'* e do problema que queremos resolver.
    ---

<br>
<br>

- **CÓDIGO DO PROCEDIMENTO:**

    - Faz sentido retornar ``a.CD_PRO_FAT`` quando o agendamento é atendido ou quando a agenda é reservada por um paciênte, quando não, deve-se deixar o campo NULL, pois uma agenda só pode ter um item de agendamento, pois cada horário da agenda só referência um procedimento, isto é, só consigo determinar item quando a agenda é reservada ou quando o atendimento for efetivado.


        ```sql
            NVL(a.cd_pro_int, ia.cd_pro_fat) as "sr_type_code",
        ```
        - **Sugestão de Solução:**
            ```sql
                CASE
                    WHEN a.CD_ATENDIMENTO IS NOT NULL THEN a.CD_PRO_INT
                    WHEN a.CD_ATENDIMENTO IS NULL AND p.CD_PACIENTE IS NOT NULL THEN ia.CD_PRO_FAT
                    ELSE NULL
                END AS "sr_type_code",
            ```
    ---

<br>
<br>


- **TRADUÇÃO DO CAMPO CD_MULTI_EMPRESA:**
    - Internamente não existe esses estabelecimentos:
        ```sql
                CASE WHEN m.CD_MULTI_EMPRESA IS NULL THEN ''
                    ELSE ',{"type":"LOCATION","actor":{"reference":"' || m.CD_MULTI_EMPRESA || '","display":"' ||
                        CASE
                        WHEN m.CD_MULTI_EMPRESA = 1 THEN 'SANTA CATARINA'
                        WHEN m.CD_MULTI_EMPRESA = 2 THEN 'GONCALVES DIAS'
                        WHEN m.CD_MULTI_EMPRESA = 3 THEN 'GOITACAZES'
                        WHEN m.CD_MULTI_EMPRESA = 4 THEN 'CARANGOLA'
                        WHEN m.CD_MULTI_EMPRESA = 5 THEN 'ROFT'
                        WHEN m.CD_MULTI_EMPRESA = 6 THEN 'REDE OFTALMO'
                        WHEN m.CD_MULTI_EMPRESA = 7 THEN 'PASSOS'
                        WHEN m.CD_MULTI_EMPRESA = 8 THEN 'AEP'
                        ELSE 'Nao Cadastrado'
                        END || '"}}'
                END ||
            ']' AS "participantList",
        ```
        - **Sugestão de Solução:** Substituir o CASE WHEN pelo campo ``m.DS_MULTI_EMPRESA``

            ```sql
                '[' ||
                    '{"type":"PATIENT","actor":{"display":"' || REPLACE(p.NM_PACIENTE, '"','\"') || '","reference":"' || a.CD_PACIENTE || '"}}' ||
                    CASE WHEN pr.CD_PRESTADOR IS NULL THEN ''
                        ELSE ',{"type":"PROFESSIONAL","actor":{"reference":"' || pr.CD_PRESTADOR || '","display":"' || REPLACE(pr.NM_PRESTADOR, '"','\"') || '"}}'
                    END ||
                    CASE WHEN m.CD_MULTI_EMPRESA IS NULL THEN ''
                        ELSE ',{"type":"LOCATION","actor":{"reference":"' || m.CD_MULTI_EMPRESA || '","display":"' || m.DS_MULTI_EMPRESA
                    END ||
                ']' AS "participantList"
            ```
    ---

<br>
<br>


- **CÓDIGO REFATORADO [APPOINTMENTS POR PERIODO]:**
    ```sql
        WITH fhir_appointments
            AS (
                SELECT DISTINCT
                    p.CD_PACIENTE AS "filter_medical_record_id",
                    LOWER(p.NM_PACIENTE) AS "filter_patient_name",
                    TO_DATE(TO_CHAR(it.hr_agenda, 'yyyy-mm-dd'),'YYYY-MM-DD') AS "filter_schedule_date",
                    TO_DATE(TO_CHAR(NVL(a.DT_ALTA, a.DT_ATENDIMENTO), 'yyyy-mm-dd'),'YYYY-MM-DD') AS "filter_updated_date",

                    it.cd_it_agenda_central AS "id",
                    it.cd_agenda_central AS "id_agc_central",
                    CASE
                        WHEN agc.tp_agenda = 'L' THEN 'Laboratorio'
                        WHEN agc.tp_agenda = 'A' THEN 'Ambulatorio'
                        WHEN agc.tp_agenda = 'I' THEN 'Diagnostico Por Imagem'
                        ELSE NULL
                    END as "type",
                    CASE
                        WHEN a.cd_atendimento IS NOT NULL THEN 'fulfilled'
                        WHEN a.cd_atendimento IS NULL THEN
                        CASE
                            WHEN it.hr_agenda > CURRENT_TIMESTAMP THEN 'booked'
                            WHEN it.hr_agenda >= CURRENT_TIMESTAMP + INTERVAL '1' DAY THEN 'pending'
                            ELSE 'noshow'
                        END
                        ELSE 'proposed'
                    END AS "status",
                    CASE
                        WHEN a.CD_ATENDIMENTO IS NOT NULL THEN a.CD_PRO_INT
                        WHEN a.CD_ATENDIMENTO IS NULL AND p.CD_PACIENTE IS NOT NULL THEN ia.CD_PRO_FAT
                        ELSE NULL
                    END AS "sr_type_code",
                    prof.ds_pro_fat as "sr_display",
                    a.tp_atendimento as "encounter_type_code",
                    CASE
                        WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                        WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                        WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                        WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                        WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                        WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                        WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                        WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                        ELSE 'Indefinido'
                    END as "encounter_display",
                    agc.tp_agenda as "appointment_type_code",
                    CASE
                        WHEN agc.tp_agenda = 'L' THEN 'Laboratorio'
                        WHEN agc.tp_agenda = 'A' THEN 'Ambulatorio'
                        WHEN agc.tp_agenda = 'I' THEN 'Diagnostico Por Imagem'
                        ELSE NULL
                    END as "appointment_display",
                    a.CD_ATENDIMENTO || ' - ' || NVL(prof.ds_pro_fat,'')  AS "description",
                    it.DS_OBSERVACAO_GERAL AS "comment",
                    TO_CHAR(it.hr_agenda, 'YYYY-MM-DD') AS "date",
                    CASE
                        WHEN a.DT_ATENDIMENTO IS NOT NULL THEN TO_CHAR(a.DT_ATENDIMENTO, 'YYYY-MM-DD') || 'T' || TO_CHAR(a.HR_ATENDIMENTO, 'HH24:MI:SS')
                        ELSE NULL
                    END AS "start",
                    CASE
                        WHEN a.DT_ALTA IS NOT NULL AND a.HR_ALTA IS NOT NULL
                        THEN COALESCE(TO_CHAR(a.DT_ALTA, 'YYYY-MM-DD') || 'T' || TO_CHAR(a.HR_ALTA, 'HH24:MI:SS'),NULL)
                        ELSE NULL
                    END AS "end",
                    '[' ||
                        '{"type":"PATIENT","actor":{"display":"' || REPLACE(p.NM_PACIENTE, '"','\"') || '","reference":"' || a.CD_PACIENTE || '"}}' ||
                        CASE WHEN pr.CD_PRESTADOR IS NULL THEN ''
                            ELSE ',{"type":"PROFESSIONAL","actor":{"reference":"' || pr.CD_PRESTADOR || '","display":"' || REPLACE(pr.NM_PRESTADOR, '"','\"') || '"}}'
                        END ||
                        CASE WHEN m.CD_MULTI_EMPRESA IS NULL THEN ''
                            ELSE ',{"type":"LOCATION","actor":{"reference":"' || m.CD_MULTI_EMPRESA || '","display":"' || m.DS_MULTI_EMPRESA
                        END ||
                    ']' AS "participantList",
                    '{"relatedEncounter":"' || a.CD_ATENDIMENTO || '","procedureCode":"' || a.cd_pro_int || '","procedure_system":"MV"}' AS "extensions"
                FROM DBAMV.AGENDA_CENTRAL agc
                INNER JOIN DBAMV.IT_AGENDA_CENTRAL          it       ON agc.CD_AGENDA_CENTRAL = it.CD_AGENDA_CENTRAL    -- TODOS BUCKETS INDEPENDENTE SE OCUPADO OU NAO
                                                                    -- AND ia.CD_ITEM_AGENDAMENTO = it.CD_ITEM_AGENDAMENTO -- SOMENTE BUKETS C/ PROCEDIMENTO AGENDADO
                INNER JOIN DBAMV.AGENDA_CENTRAL_ITEM_AGENDA aci      ON agc.CD_AGENDA_CENTRAL = aci.CD_AGENDA_CENTRAL
                INNER JOIN DBAMV.ITEM_AGENDAMENTO           ia       ON aci.CD_ITEM_AGENDAMENTO = ia.CD_ITEM_AGENDAMENTO
                LEFT JOIN DBAMV.ATENDIME                    a        ON it.CD_ATENDIMENTO = a.CD_ATENDIMENTO -- APENAS ATENDIMENTOS "AGENDADOS", NAO INCLUI "ATENDIMENTOS-NAO-AGENDADO"
                LEFT JOIN DBAMV.PRO_FAT                     prof     ON prof.cd_pro_fat = a.cd_pro_int
                LEFT JOIN DBAMV.PACIENTE                    p        ON p.CD_PACIENTE    = it.CD_PACIENTE
                LEFT JOIN DBAMV.PRESTADOR                   pr       ON pr.CD_PRESTADOR  = agc.CD_PRESTADOR
                LEFT JOIN DBAMV.MULTI_EMPRESAS              m        ON m.CD_MULTI_EMPRESA = agc.CD_MULTI_EMPRESA

                WHERE
                    it.hr_agenda BETWEEN TO_TIMESTAMP('2024-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
                                    AND TO_TIMESTAMP('2025-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
        )
        SELECT
            fa."filter_medical_record_id",
            fa."id",
            fa."type",
            fa."status",
            fa."appointment_type_code",
            fa."appointment_display",
            fa."sr_type_code",
            fa."sr_display",
            fa."encounter_type_code",
            fa."encounter_display",
            fa."description",
            fa."comment",
            fa."date",
            fa."start",
            fa."end",
            fa."participantList",
            fa."extensions"
        FROM fhir_appointments fa
        WHERE
            (NULLIF( :searchTerm1 , 'null') IS NULL OR fa."filter_patient_name"      LIKE LOWER('%'|| :searchTerm2 ||'%'))
            AND (NULLIF( :medicalRecordId1 , 'null') IS NULL OR fa."filter_medical_record_id" = :medicalRecordId2 )
            AND (NULLIF( :fromDate1 , 'null') IS NULL OR fa."filter_schedule_date"    >= TO_DATE( :fromDate2 , 'YYYY-MM-DD'))
            AND (NULLIF( :toDate1 , 'null') IS NULL OR fa."filter_schedule_date" <= TO_DATE( :toDate2 , 'YYYY-MM-DD'))
        ;
    ```
    ---

<br>
<br>

- **Modelo Entidade Relacionamento:**
    - ![Diagrama ER](AGENDAMENTOS.png)


</details>


<br>
<br>

<details>
    <summary><strong>⛧ ENCOUNTERS POR PERIODO:</strong></summary>

* OBJETIVO: Listar atendimentos e procedimentos por período (Consultas, Exames e Cirurgias)
  ---

<br>

* **MUITOS REGISTROS COM TRADUÇÃO DO ``"TP_ATENDIMENTO"`` NO CAMPO ``"type"``:**

    - **Muitos registros retornam a tradução do campo "TP_ATENDIMENTO" ao envés do procedimento real que pode ser obtido das tabelas de faturamento**

        ```sql
            # TRECHO DO CODIGO ORIGINAL

            REPLACE(
            NVL(
                CASE
                WHEN PS.CD_PROCEDIMENTO IS NULL THEN C.DS_CIRURGIA
                WHEN A.CD_PRO_INT     IS NULL THEN PS.DS_PROCEDIMENTO
                ELSE C.DS_CIRURGIA
                END,
                NVL(PF.DS_PRO_FAT,
                    CASE
                    WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                    WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                    WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                    WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                    WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                    WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                    WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                    WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                    ELSE 'Indefinido'
                    END
                )
            ),
            '"','\"')                                                       AS "type",
        ```

        - **Sugestão de Solução:**
            - Validar se o ``CD_ATENDIMENTO`` possuí procedimento cirurgico vinculado, caso contrário retorna o procedimento faturado conforme tipo do atendimento; em última opção retona a tradução pelo tipo de atendimento.

                ```sql
                    REPLACE(
                        NVL(
                            CASE
                                WHEN AC.CD_ATENDIMENTO  IS NOT NULL THEN C.DS_CIRURGIA
                                WHEN AC.CD_ATENDIMENTO IS NULL THEN COALESCE( ra.DS_PRO_FAT, rh.DS_PRO_FAT)
                                ELSE COALESCE( PF.DS_PRO_FAT, PS.DS_PROCEDIMENTO)
                            END,
                            CASE
                                WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                                WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                                WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                                WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                                WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                                WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                                WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                                WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                                ELSE 'Indefinido'
                            END
                        ),
                    '"','\"')                                                       AS "type",
                ```

            - *Mesma lógica aplicada p/ o campo ``"encounterClass"``:*

                ```sql
                    '{' ||
                        '"code":"",' ||
                        '"display":"' ||
                        REPLACE(
                            NVL(
                                CASE
                                    WHEN AC.CD_ATENDIMENTO  IS NOT NULL THEN C.DS_CIRURGIA
                                    WHEN AC.CD_ATENDIMENTO IS NULL THEN COALESCE( ra.DS_PRO_FAT, rh.DS_PRO_FAT)
                                    ELSE COALESCE( PF.DS_PRO_FAT, PS.DS_PROCEDIMENTO)
                                END,
                                CASE
                                    WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                                    WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                                    WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                                    WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                                    WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                                    WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                                    WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                                    WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                                    ELSE 'Indefinido'
                                END
                            ),
                        '"','\"'
                        )
                        || '"' ||
                    '}'                                                             AS "encounterClass",
                ```


            - Tabelas de faturamento com ``DS_PRO_FAT``:
                ```sql
                    WITH JN_REGRA_AMBULATORIO
                        AS (
                            SELECT
                                ia.CD_ATENDIMENTO,
                                pf.CD_PRO_FAT,
                                pf.DS_PRO_FAT,
                                p.CD_PRESTADOR,
                                p.NM_PRESTADOR
                            FROM DBAMV.ITREG_AMB ia
                            LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
                            LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
                            LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
                    ),
                    JN_REGRA_HOSPITALAR
                        AS (
                                SELECT
                                    rf.CD_ATENDIMENTO,
                                    pf.CD_PRO_FAT,
                                    pf.DS_PRO_FAT,
                                    p.CD_PRESTADOR,
                                    p.NM_PRESTADOR
                                FROM DBAMV.ITREG_FAT itf
                                LEFT JOIN DBAMV.PRO_FAT pf ON itf.CD_PRO_FAT = pf.CD_PRO_FAT
                                LEFT JOIN DBAMV.REG_FAT rf ON itf.CD_REG_FAT = rf.CD_REG_FAT
                                LEFT JOIN DBAMV.PRESTADOR p    ON itf.CD_PRESTADOR = p.CD_PRESTADOR
                    ),
                ```

    ---

<br>
<br>


- **REGISTRO DE ATENDIMENTO CIRURGICO C/ PRESTADOR DE ATENDIMENTO AMBULATÓRIAL**
    - **Atendimento c/ procedimentos cirurgicos retornando o mesmo prestador com origem na tabela de atendimento**
        ```sql
            CASE
            WHEN NVL(PP.CD_PRESTADOR,0) = 0 THEN NULL
            ELSE
                '[' ||
                '{' ||
                    '"type":"PROFESSIONAL",' ||
                    '"actor":{' ||
                    '"reference":"' || TO_CHAR(PP.CD_PRESTADOR) || '",' ||
                    '"display":"'   || REPLACE(NVL(PP.NM_PRESTADOR,''),'"','\"') || '"' ||
                    '}' ||
                '}' ||
                ']'
            END                                                             AS "participants",
        ```


        - **Sugestão de Solução:**
            - Atendimentos com procedimentos cirurgicos devem exibir o prestador do procedimento cirurgico
                ```sql
                    CASE
                        WHEN (
                            CASE
                                WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pa.CD_PRESTADOR
                                ELSE PP.CD_PRESTADOR
                            END
                        ) IS NULL THEN NULL
                        ELSE
                        '[' ||
                            '{' ||
                            '"type":"PROFESSIONAL",' ||
                            '"actor":{' ||
                                '"reference":"' || TO_CHAR(
                                    CASE
                                        WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pa.CD_PRESTADOR
                                        ELSE PP.CD_PRESTADOR
                                    END
                                ) || '",' ||
                                '"display":"'   || REPLACE(
                                                        NVL(
                                                            CASE
                                                                WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pp2.NM_PRESTADOR
                                                                ELSE PP.NM_PRESTADOR
                                                            END,
                                                            ''
                                                        ),
                                                        '"','\"'
                                                    ) || '"' ||
                            '}' ||
                            '}' ||
                        ']'
                    END                                                             AS "participants",
                ```

            - Para permitir isso é necessário ajustar o ``JOIN`` entre as tabelas no núcleo cirurgias e filtrar pelo *'prestador principal'* e *'procedimento principal'*:

                ```sql
                    LEFT JOIN DBAMV.AVISO_CIRURGIA AC    ON A.CD_ATENDIMENTO       = AC.CD_ATENDIMENTO
                    LEFT JOIN DBAMV.CIRURGIA_AVISO CA    ON AC.CD_AVISO_CIRURGIA   = CA.CD_AVISO_CIRURGIA AND CA.SN_PRINCIPAL = 'S'
                    LEFT JOIN DBAMV.PRESTADOR_AVISO pa   ON AC.CD_AVISO_CIRURGIA   = pa.CD_AVISO_CIRURGIA AND pa.SN_PRINCIPAL = 'S'
                    LEFT JOIN DBAMV.CIRURGIA C           ON pa.CD_CIRURGIA         = C.CD_CIRURGIA
                    LEFT JOIN JN_PRESTADOR pp2           ON PP2.CD_PRESTADOR       = pa.CD_PRESTADOR
                ```
    ---

<br>
<br>


- **CÓDIGO REFATORADO [ENCOUNTERS POR PERIODO]:**
    ```sql
        WITH JN_REGRA_AMBULATORIO
            AS (
                SELECT
                    ia.CD_ATENDIMENTO,
                    pf.CD_PRO_FAT,
                    pf.DS_PRO_FAT,
                    p.CD_PRESTADOR,
                    p.NM_PRESTADOR
                FROM DBAMV.ITREG_AMB ia
                LEFT JOIN DBAMV.PRO_FAT pf     ON ia.CD_PRO_FAT = pf.CD_PRO_FAT
                LEFT JOIN DBAMV.REG_AMB ra     ON ia.CD_REG_AMB = ra.CD_REG_AMB
                LEFT JOIN DBAMV.PRESTADOR p    ON ia.CD_PRESTADOR = p.CD_PRESTADOR
        ),
        JN_REGRA_HOSPITALAR
            AS (
                    SELECT
                        rf.CD_ATENDIMENTO,
                        pf.CD_PRO_FAT,
                        pf.DS_PRO_FAT,
                        p.CD_PRESTADOR,
                        p.NM_PRESTADOR
                    FROM DBAMV.ITREG_FAT itf
                    LEFT JOIN DBAMV.PRO_FAT pf ON itf.CD_PRO_FAT = pf.CD_PRO_FAT
                    LEFT JOIN DBAMV.REG_FAT rf ON itf.CD_REG_FAT = rf.CD_REG_FAT
                    LEFT JOIN DBAMV.PRESTADOR p    ON itf.CD_PRESTADOR = p.CD_PRESTADOR
        ),
        JN_PRESTADOR
            AS (
                SELECT
                    CD_PRESTADOR,
                    NM_PRESTADOR
                FROM DBAMV.PRESTADOR
        ),
        fhir_encounters
            AS (
                SELECT DISTINCT
                    A.CD_PACIENTE                                                                           AS "filter_medical_record_id",
                    LOWER(P.NM_PACIENTE)                                                                    AS "filter_patient_name",
                    TO_DATE(TO_CHAR(NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO),'YYYY-MM-DD'),'YYYY-MM-DD') AS "filter_encounter_date",
                    TO_DATE(TO_CHAR(NVL(A.DT_ALTA, A.DT_ATENDIMENTO),'YYYY-MM-DD'),'YYYY-MM-DD')            AS "filter_updated_date",


                    A.CD_ATENDIMENTO                                                                        AS "id",

                    CASE
                        WHEN A.DT_ATENDIMENTO >= CURRENT_TIMESTAMP THEN 'planned'
                        WHEN A.DT_ATENDIMENTO IS NULL THEN 'cancelled'
                        WHEN A.DH_ALTA_LANCADA IS NOT NULL THEN 'completed'
                        WHEN A.DH_ALTA_LANCADA IS NULL THEN
                            CASE
                                WHEN A.TP_ATENDIMENTO IN ('E','A') THEN 'completed'
                                WHEN A.TP_ATENDIMENTO IN ('I','U') THEN 'in-progress'
                                ELSE 'completed'
                            END
                        ELSE 'on-hold'
                    END                                                             AS "status",

                    REPLACE(
                        NVL(
                            CASE
                                WHEN AC.CD_ATENDIMENTO  IS NOT NULL THEN C.DS_CIRURGIA
                                WHEN AC.CD_ATENDIMENTO IS NULL THEN COALESCE( ra.DS_PRO_FAT, rh.DS_PRO_FAT)
                                ELSE COALESCE( PF.DS_PRO_FAT, PS.DS_PROCEDIMENTO)
                            END,
                            CASE
                                WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                                WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                                WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                                WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                                WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                                WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                                WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                                WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                                ELSE 'Indefinido'
                            END
                        ),
                    '"','\"')                                                       AS "type",

                    '{' ||
                        '"reference":"' || TO_CHAR(A.CD_PACIENTE) || '",' ||
                        '"display":"'   || REPLACE(NVL(P.NM_PACIENTE,''),'"','\"') || '"' ||
                    '}'                                                             AS "subject",

                    CASE
                        WHEN (
                            CASE
                                WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pa.CD_PRESTADOR
                                ELSE PP.CD_PRESTADOR
                            END
                        ) IS NULL THEN NULL
                        ELSE
                        '[' ||
                            '{' ||
                            '"type":"PROFESSIONAL",' ||
                            '"actor":{' ||
                                '"reference":"' || TO_CHAR(
                                    CASE
                                        WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pa.CD_PRESTADOR
                                        ELSE PP.CD_PRESTADOR
                                    END
                                ) || '",' ||
                                '"display":"'   || REPLACE(
                                                        NVL(
                                                            CASE
                                                                WHEN AC.CD_ATENDIMENTO IS NOT NULL THEN pp2.NM_PRESTADOR
                                                                ELSE PP.NM_PRESTADOR
                                                            END,
                                                            ''
                                                        ),
                                                        '"','\"'
                                                    ) || '"' ||
                            '}' ||
                            '}' ||
                        ']'
                    END                                                             AS "participants",

                    CASE
                        WHEN NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO) IS NULL THEN NULL
                        ELSE TO_CHAR(NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO),'YYYY-MM-DD"T"HH24:MI:SS')
                    END                                                             AS "start",

                    CASE
                        WHEN A.DT_ALTA IS NULL THEN NULL
                        ELSE TO_CHAR(A.DT_ALTA,'YYYY-MM-DD"T"HH24:MI:SS')
                    END                                                             AS "end",

                    '{' ||
                        '"code":"",' ||
                        '"display":"' ||
                        REPLACE(
                            NVL(
                                CASE
                                    WHEN AC.CD_ATENDIMENTO  IS NOT NULL THEN C.DS_CIRURGIA
                                    WHEN AC.CD_ATENDIMENTO IS NULL THEN COALESCE( ra.DS_PRO_FAT, rh.DS_PRO_FAT)
                                    ELSE COALESCE( PF.DS_PRO_FAT, PS.DS_PROCEDIMENTO)
                                END,
                                CASE
                                    WHEN A.TP_ATENDIMENTO = 'E' THEN 'Externo'
                                    WHEN A.TP_ATENDIMENTO = 'A' THEN 'Ambulatorial'
                                    WHEN A.TP_ATENDIMENTO = 'I' THEN 'Internacao'
                                    WHEN A.TP_ATENDIMENTO = 'U' THEN 'Urgencia'
                                    WHEN A.TP_ATENDIMENTO = 'H' THEN 'Home Care'
                                    WHEN A.TP_ATENDIMENTO = 'B' THEN 'Busca Ativa'
                                    WHEN A.TP_ATENDIMENTO = 'S' THEN 'SUS - AIH'
                                    WHEN A.TP_ATENDIMENTO = 'O' THEN 'Obito (nao utilizado)'
                                    ELSE 'Indefinido'
                                END
                            ),
                        '"','\"'
                        )
                        || '"' ||
                    '}'                                                             AS "encounterClass",

                    NULL                                                            AS "serviceProvider",

                    CASE
                        WHEN M.CD_MULTI_EMPRESA IS NULL THEN '[]'
                        ELSE
                        '[' ||
                            '{"reference":"' || TO_CHAR(M.CD_MULTI_EMPRESA) || '","display":"' ||
                            CASE
                                WHEN M.CD_MULTI_EMPRESA = 1 THEN 'HOSPITAL PRONTOCARDIO'

                                ELSE 'Nao Cadastrado'
                            END
                            || '"}]'
                    END                                                             AS "locations",

                    (
                        SELECT
                        CASE
                            WHEN COUNT(*) = 0 THEN '[]'
                            ELSE
                            '[' || LISTAGG(
                                    '{"reference":"' || TO_CHAR(AC2.CD_AVISO_CIRURGIA) ||
                                    '","display":"Aviso Cirurgia ' || TO_CHAR(AC2.CD_AVISO_CIRURGIA) || '"}'
                                    , ','
                                    ) WITHIN GROUP (ORDER BY AC2.CD_AVISO_CIRURGIA)
                            || ']'
                        END
                        FROM dbamv.AVISO_CIRURGIA AC2
                        WHERE AC2.CD_ATENDIMENTO = A.CD_ATENDIMENTO
                    )                                                              AS "appointments"

                FROM DBAMV.ATENDIME A
                LEFT JOIN DBAMV.PACIENTE P           ON P.CD_PACIENTE         = A.CD_PACIENTE
                LEFT JOIN JN_PRESTADOR PP            ON PP.CD_PRESTADOR       = A.CD_PRESTADOR

                LEFT JOIN DBAMV.AVISO_CIRURGIA AC    ON A.CD_ATENDIMENTO      = AC.CD_ATENDIMENTO
                LEFT JOIN DBAMV.CIRURGIA_AVISO CA    ON AC.CD_AVISO_CIRURGIA  = CA.CD_AVISO_CIRURGIA AND CA.SN_PRINCIPAL = 'S'
                LEFT JOIN DBAMV.PRESTADOR_AVISO pa   ON AC.CD_AVISO_CIRURGIA  = pa.CD_AVISO_CIRURGIA AND pa.SN_PRINCIPAL = 'S'
                LEFT JOIN DBAMV.CIRURGIA C           ON pa.CD_CIRURGIA        = C.CD_CIRURGIA
                LEFT JOIN JN_PRESTADOR pp2           ON PP2.CD_PRESTADOR      = pa.CD_PRESTADOR

                LEFT JOIN  DBAMV.PROCEDIMENTO_SUS PS ON PS.CD_PROCEDIMENTO    = A.CD_PROCEDIMENTO
                LEFT JOIN  DBAMV.PRO_FAT PF          ON A.CD_PRO_INT          = PF.CD_PRO_FAT

                LEFT JOIN JN_REGRA_AMBULATORIO   ra  ON a.CD_ATENDIMENTO      = ra.CD_ATENDIMENTO
                LEFT JOIN JN_REGRA_HOSPITALAR    rh  ON a.CD_ATENDIMENTO      = rh.CD_ATENDIMENTO
                LEFT JOIN  DBAMV.MULTI_EMPRESAS M    ON M.CD_MULTI_EMPRESA    = A.CD_MULTI_EMPRESA
                WHERE
                    NVL(AC.DT_AVISO_CIRURGIA, A.DT_ATENDIMENTO) >= TO_DATE('2025-01-01','YYYY-MM-DD')
        )
        SELECT
            fe."id",
            fe."status",
            fe."type",
            fe."subject",
            fe."participants",
            fe."start",
            fe."end",
            fe."encounterClass",
            fe."serviceProvider",
            fe."locations",
            fe."appointments"
        FROM fhir_encounters fe
        ;
    ```
<br>

</details>

<br>
<br>


<details>

<summary><strong>⛧ SERVICE REQUEST POR PERIODO [PEDIDOS - EXAMES/CIRURGIAS]:</strong></summary>

<br>

OBJETIVO: Listar Prescrições e Pedidos de exames de Imagem e Laboratórial
---

<br>

- **Hipóteses:**
    - PRESCRICAO COM PEDIDO
    - PRESCRICAO COM PEDIDO
    - PEDIDO SEM PRESCRICAO

<br>

- **Regras:**
    - Atendimentos de Internação, Urgência e Emergência `[TP_ATENDIMENTO IN('I', 'U')]` geram Pedidos de forma automática a partir da prescrição.
        - *Obs.: Há Alguns casos de atendimentos do tipo internação cujo pedido não será gerado automáticamente, tampouco proveniente de prescrição; geralmente são casos de exames realizados na Hemodinamica.*

    - Atendimento Ambulatórial `[TP_ATENDIMENTO = 'A']`, os exames são prescritos em um atendimento e os pedidos são gerados e vinculados a outro código de atendimento que pode ser aberto no mesmo dia ou em dias posteriores conforme disponibilidade da agenda.

    - Atendimento Externo `[TP_ATENDIMENTO = 'E']` refere-se a Pedidos de exames gerados sem vinculação à prescrição que pode ter sido emitida pelo próprio hospital ou por terceiro; esse tipo de atendimento pode ser originário de agendamentos ou marcação imediata na reecpção, conforme disponibilidade de agenda.

        - *Obs.: Convênios IPM e ISSEC não utilizam a prescrição padrão; nestes casos a prescição é realizada por meio de Documento Eletrônico personalizado*
  ---

<br>

* **CAMPO `"id"` COMO ORIGEM DA REQUISIÇÃO DE EXAMES:**

    - **Na query original o campo `"id"`, tradução dos campos originais `CD_PED_RX` e `CD_PED_LAB`, são interpretados como requisição de exame feita no MV, porém essa interpretação deve ser associada à prescrição `CD_PRE_MED`; os campos anteriores representam os pedidos já a serem efetivados (nesse momento pode haver desistências, mas entende-se que há mais 95% de chances da realização do exame, enquanto que na prescrição essa margem de conversão não é observada)**

        - **Nova implementação do campo `"id"`: Um ou mais pedidos de exames são associados a uma prescrição, e uma ou mais prescrições são associadas a um atendimento, por tanto altera-se a formação do campo id para:**

            ```sql
                COALESCE(r.CD_PRESCRICAO, 0) || '-' ||
                COALESCE(r.CD_PEDIDO, 0)  || '-' ||
                COALESCE(r.CD_EXA, 0) AS "id",
            ```

<br>
<br>

* **DESCRIÇÃO DOS PROCEDIMENTOS DO CAMPO `"code"`:**

    - **Nem todos os procedimentos de `PRO_FAT.CD_PRO_FAT` possuem equivalente em `TUSS.CD_TUSS`**

        - **O campo `CD_PRO_FAT` pode ser originário da prescrição ou do pedido, vai depender das hipóteses citadas no objetivo**

            ```sql
                '{'||
                    '"codes":['||
                    '{'||
                        '"system":"MV",'||
                        '"code":"'    || REPLACE(COALESCE(t.CODIGO_PRO_FAT, r.CD_PRO_FAT),'"','\"') || '",'||
                        '"display":"' || REPLACE(COALESCE(t.DESCRICAO_PRO_FAT, r.DS_EXA),'"','\"') || '"'||
                    '}' ||
                            ',{'||
                            '"system":"TUSS",'||
                            '"code":"'    || REPLACE(t.CODIGO_TUSS,'"','\"') || '",'||
                            '"display":"' || REPLACE(t.DESCRICAO_TUSS,'"','\"') || '"'||
                            '}'
                    || '],'||
                    '"text":"' || REPLACE(t.DESCRICAO_PRO_FAT,'"','\"') || '"'||
                '}'                                        AS "code",
            ```
---

<br>
<br>


* **CÓDIGO REFATORADO [SERVICE REQUEST POR PERIODO]:**



    ```sql
        WITH JN_PRESCRICAO
            AS (
                SELECT
                    itm.CD_PRE_MED,
                    itm.CD_ITPRE_MED,
                    pm.CD_ATENDIMENTO,

                    COALESCE(er.CD_EXA_RX, el.CD_EXA_LAB) AS CD_EXA,
                    COALESCE(er.DS_EXA_RX, el.NM_EXA_LAB) AS DS_EXA,

                    COALESCE(pm.CD_PRESTADOR, itm.CD_PRESTADOR) AS CD_PRESTADOR_PRESCRICAO,

                    itm.CD_TIP_ESQ,

                    itm.CD_SET_EXA,
                    COALESCE(COALESCE(tp.CD_PRO_FAT, er.EXA_RX_CD_PRO_FAT),el.CD_PRO_FAT) AS CD_PRO_FAT,
                    pm.DT_PRE_MED AS DT_PRESCRICAO

                FROM DBAMV.ITPRE_MED itm
                INNER JOIN DBAMV.PRE_MED pm   ON itm.CD_PRE_MED = pm.CD_PRE_MED
                INNER JOIN DBAMV.TIP_PRESC tp ON itm.CD_TIP_PRESC = tp.CD_TIP_PRESC
                LEFT JOIN DBAMV.EXA_RX er     ON tp.CD_EXA_RX = er.CD_EXA_RX
                LEFT JOIN DBAMV.EXA_LAB el    ON tp.CD_EXA_LAB = el.CD_EXA_LAB
                WHERE itm.CD_TIP_ESQ IN('EXI', 'EXL')
        ),
        JN_PEDIDOS_IMAGEM
            AS (
                SELECT
                    itr.CD_PED_RX,
                    itr.CD_ITPED_RX,
                    pr.CD_PRE_MED,
                    itr.CD_ITPRE_MED,
                    pr.CD_ATENDIMENTO,
                    pr.CD_CONVENIO,
                    itr.CD_EXA_RX,
                    er.DS_EXA_RX,
                    pr.CD_PRESTADOR AS CD_PRESTADOR_PEDIDO,

                    pr.CD_SET_EXA,
                    er.EXA_RX_CD_PRO_FAT AS CD_PRO_FAT,
                    pr.DT_PEDIDO AS DT_PEDIDO

                FROM DBAMV.ITPED_RX itr
                INNER JOIN DBAMV.PED_RX  pr ON itr.CD_PED_RX = pr.CD_PED_RX
                INNER JOIN DBAMV.EXA_RX er ON itr.CD_EXA_RX = er.CD_EXA_RX
        ),
        JN_PEDIDOS_LABORATORIO
            AS (
                SELECT
                    itl.CD_PED_LAB,
                    itl.CD_ITPED_LAB,
                    pl.CD_PRE_MED,
                    itl.CD_ITPRE_MED,
                    pl.CD_ATENDIMENTO,
                    pl.CD_CONVENIO,
                    itl.CD_EXA_LAB,
                    el.NM_EXA_LAB,
                    pl.CD_PRESTADOR AS CD_PRESTADOR_PEDIDO,

                    itl.CD_SET_EXA,
                    el.CD_PRO_FAT,
                    pl.DT_PEDIDO AS DT_PEDIDO

                FROM DBAMV.ITPED_LAB itl
                INNER JOIN DBAMV.PED_LAB pl ON itl.CD_PED_LAB = pl.CD_PED_LAB
                INNER JOIN DBAMV.EXA_LAB el ON itl.CD_EXA_LAB = el.CD_EXA_LAB
        ),
        JN_PEDIDOS
            AS (
                SELECT
                    'I' AS TIPO_PEDIDO,
                    CD_PED_RX AS CD_PEDIDO,
                    CD_ITPED_RX AS CD_ITPEDIDO,
                    CD_PRE_MED,
                    CD_ITPRE_MED,
                    CD_ATENDIMENTO,
                    CD_CONVENIO,
                    CD_EXA_RX AS CD_EXA,
                    DS_EXA_RX AS DS_EXA,
                    CD_PRESTADOR_PEDIDO,
                    DT_PEDIDO,
                    CD_SET_EXA,
                    CD_PRO_FAT
                FROM JN_PEDIDOS_IMAGEM
                UNION ALL
                SELECT
                    'L' AS TIPO_PEDIDO,
                    CD_PED_LAB     AS CD_PEDIDO,
                    CD_ITPED_LAB   AS CD_ITPEDIDO,
                    CD_PRE_MED,
                    CD_ITPRE_MED,
                    CD_ATENDIMENTO,
                    CD_CONVENIO,
                    CD_EXA_LAB     AS CD_EXAME,
                    NM_EXA_LAB     AS DS_EXAME,
                    CD_PRESTADOR_PEDIDO,
                    DT_PEDIDO,
                    CD_SET_EXA,
                    CD_PRO_FAT
                FROM JN_PEDIDOS_LABORATORIO
        ),
        JN_ATENDIMENTO
            AS (
                SELECT
                    a.CD_ATENDIMENTO,
                    a.CD_PACIENTE,
                    a.CD_CONVENIO,
                    c.CD_CID,
                    a.CD_PRO_INT,
                    a.TP_ATENDIMENTO,
                    c.DS_CID
                FROM DBAMV.ATENDIME a
                LEFT JOIN DBAMV.CID c ON a.CD_CID = c.CD_CID
        ),
        JN_PACIENTE
            AS (
                SELECT
                    CD_PACIENTE,
                    NM_PACIENTE
                FROM DBAMV.PACIENTE
        ),
        JN_PRESTADOR
            AS (
                SELECT
                    CD_PRESTADOR,
                    NM_PRESTADOR
                FROM DBAMV.PRESTADOR
        ),
        JN_TUSS
            AS (
                SELECT
                    t.CD_TUSS AS CODIGO_TUSS,
                    p.CD_PRO_FAT AS CODIGO_PRO_FAT,
                    t.CD_CONVENIO,
                    t.DS_TUSS AS DESCRICAO_TUSS,
                    p.DS_PRO_FAT AS DESCRICAO_PRO_FAT
                FROM DBAMV.PRO_FAT p
                LEFT JOIN  DBAMV.TUSS t ON t.CD_PRO_FAT = p.CD_PRO_FAT
        ),
        JN_PRESCRICAO_COM_PEDIDO
            AS (
                SELECT
                    'PRESCRICAO_COM_PEDIDO' AS ORIGEM,

                    p.CD_ATENDIMENTO,

                    p.CD_PRO_FAT,

                    p.CD_PRE_MED AS CD_PRESCRICAO,
                    p.CD_ITPRE_MED,
                    p.CD_PRESTADOR_PRESCRICAO,
                    p.DT_PRESCRICAO,

                    d.CD_PEDIDO,
                    d.CD_ITPEDIDO,
                    d.TIPO_PEDIDO,
                    d.CD_PRESTADOR_PEDIDO,
                    d.DT_PEDIDO,

                    p.CD_EXA,
                    p.DS_EXA,

                    p.CD_TIP_ESQ,

                    COALESCE(p.CD_SET_EXA, d.CD_SET_EXA) AS CD_SET_EXA


                FROM JN_PRESCRICAO p
                INNER JOIN JN_PEDIDOS d ON p.CD_ITPRE_MED = d.CD_ITPRE_MED
        ),
        JN_PRESCRICAO_SEM_PEDIDO
            AS (
                SELECT
                    'PRESCRICAO_SEM_PEDIDO' AS ORIGEM,

                    p.CD_ATENDIMENTO,

                    p.CD_PRO_FAT,

                    p.CD_PRE_MED AS CD_PRESCRICAO,
                    p.CD_ITPRE_MED,
                    p.CD_PRESTADOR_PRESCRICAO,
                    p.DT_PRESCRICAO,

                    NULL AS CD_PEDIDO,
                    NULL AS CD_ITPEDIDO,
                    NULL AS TIPO_PEDIDO,
                    NULL AS CD_PRESTADOR_PEDIDO,
                    NULL AS DT_PEDIDO,

                    p.CD_EXA,
                    p.DS_EXA,

                    p.CD_TIP_ESQ,

                    p.CD_SET_EXA

                FROM JN_PRESCRICAO p
                WHERE
                    NOT EXISTS (
                        SELECT
                            1
                        FROM JN_PEDIDOS d
                        WHERE p.CD_ITPRE_MED = d.CD_ITPRE_MED
                    )
        ),
        JN_PEDIDO_SEM_PRESCRICAO
            AS (
                SELECT
                    'PEDIDO_SEM_PRESCRICAO' AS ORIGEM,

                    d.CD_ATENDIMENTO,

                    d.CD_PRO_FAT,

                    d.CD_PRE_MED AS CD_PRESCRICAO,
                    d.CD_ITPRE_MED,
                    NULL AS CD_PRESTADOR_PRESCRICAO,
                    NULL AS DT_PRESCRICAO,

                    d.CD_PEDIDO,
                    d.CD_ITPEDIDO,
                    d.TIPO_PEDIDO,
                    d.CD_PRESTADOR_PEDIDO,
                    d.DT_PEDIDO,

                    d.CD_EXA,
                    d.DS_EXA,

                    NULL AS CD_TIP_ESQ,

                    d.CD_SET_EXA

                FROM JN_PEDIDOS d
                WHERE
                    NOT EXISTS (
                        SELECT
                            1
                        FROM JN_PRESCRICAO p
                        WHERE p.CD_ITPRE_MED = d.CD_ITPRE_MED
                    )
        ),
        JN_REGRAS
            AS (
                SELECT * FROM JN_PRESCRICAO_COM_PEDIDO
                UNION ALL
                SELECT * FROM JN_PRESCRICAO_SEM_PEDIDO
                UNION ALL
                SELECT * FROM JN_PEDIDO_SEM_PRESCRICAO
        ),
        TREATS
            AS (
                SELECT

                    COALESCE(r.CD_PRESCRICAO, 0) || '-' ||
                    COALESCE(r.CD_PEDIDO, 0)  || '-' ||
                    COALESCE(r.CD_EXA, 0)                              AS "id",
                    ''                                                 AS "intent",
                    ''                                                 AS "priority",

                    '[' ||
                    '{"use":"official",' ||
                    '"value":"' || r.CD_PRESCRICAO || '","system":"https://hospitalprontocardio.com.br/"' || '}' ||
                    ']'                                                AS "identifiers",

                    '{'||
                        '"codes":['||
                        '{'||
                            '"system":"MV",'||
                            '"code":"'    || REPLACE(COALESCE(t.CODIGO_PRO_FAT, r.CD_PRO_FAT),'"','\"') || '",'||
                            '"display":"' || REPLACE(COALESCE(t.DESCRICAO_PRO_FAT, r.DS_EXA),'"','\"') || '"'||
                        '}' ||
                                ',{'||
                                '"system":"TUSS",'||
                                '"code":"'    || REPLACE(t.CODIGO_TUSS,'"','\"') || '",'||
                                '"display":"' || REPLACE(t.DESCRICAO_TUSS,'"','\"') || '"'||
                                '}'
                        || '],'||
                        '"text":"' || REPLACE(t.DESCRICAO_PRO_FAT,'"','\"') || '"'||
                    '}'                                        AS "code",


                    CASE
                        WHEN a.CD_CID IS NULL THEN NULL
                        ELSE '['||'{'||
                            '"codes":[{'||
                            '"system":"http://hl7.org/fhir/ValueSet/icd-10",'||
                            '"code":"'    || REPLACE(a.CD_CID,'"','\"') || '",'||
                            '"display":"' || REPLACE(a.CD_CID,'"','\"') || '"'||
                            '}],'||
                            '"text":"' || REPLACE(a.CD_CID,'"','\"') || '"'||
                        '}]'
                    END                                                AS "reasonCodes",


                    TO_CHAR(r.DT_PRESCRICAO,'YYYY-MM-DD"T"HH24:MI:SS') AS "authoredOn",


                    '{'||'"reference":"' || TO_CHAR(p.CD_PACIENTE) || '",'||
                    '"display":"'   || REPLACE(NULLIF(TRIM(p.NM_PACIENTE),''),'"','\"') || '"'||
                    '}'                                                AS "subject",


                    '{'||'"reference":"' || TO_CHAR(pr.CD_PRESTADOR) || '",'||
                    '"display":"'   || REPLACE(NVL(pr.NM_PRESTADOR,''), '"','\"') || '"'||
                    '}'                                                AS "requester",


                    '[' ||
                    '{' ||
                        '"display":"Hospital Geral Prontocardio",' ||
                        '"reference":' || '"1"' || '}' || ']'          AS "locations",


                    CASE
                        WHEN a.CD_ATENDIMENTO IS NULL THEN NULL
                        ELSE '{'||'"reference":"' || TO_CHAR(a.CD_ATENDIMENTO) || '"}'
                    END                                                AS "encounter",


                    LOWER(NULLIF(TRIM(p.NM_PACIENTE),''))              AS "filter_patient_name",
                    p.CD_PACIENTE                                      AS "filter_medical_record_id",
                    r.DT_PEDIDO                                        AS "filter_encounter_date",
                    'active'                                           AS "status"

                FROM JN_REGRAS r
                INNER JOIN JN_ATENDIMENTO a ON r.CD_ATENDIMENTO = a.CD_ATENDIMENTO
                LEFT JOIN JN_PACIENTE p     ON a.CD_PACIENTE = p.CD_PACIENTE
                LEFT JOIN JN_PRESTADOR pr   ON r.CD_PRESTADOR_PRESCRICAO = pr.CD_PRESTADOR
                LEFT JOIN JN_PRESTADOR pr1  ON r.CD_PRESTADOR_PEDIDO = pr1.CD_PRESTADOR
                LEFT JOIN JN_TUSS t         ON r.CD_PRO_FAT = COALESCE(t.CODIGO_TUSS ,t.CODIGO_PRO_FAT) AND a.CD_CONVENIO =  t.CD_CONVENIO
        )
        SELECT
        fe."id",
        fe."identifiers",
        fe."status",
        fe."intent",
        fe."priority",
        fe."code",
        fe."reasonCodes",
        fe."authoredOn",
        fe."subject",
        fe."requester",
        fe."encounter",
        fe."locations"
        FROM TREATS fe
        ;

    ```

<br>


</details>

<br>
<br>

<details>

<summary><strong>⛧ PACIENTES</strong></summary>


* OBJETIVO: Listar pacientes do cadastro ndo ERP
  ---

<br>

- **Query pacientes c/ remoção de cadastrados duplicados e manutenção do cadastro mais atual:**

    ```sql
        WITH JN_BASE
            AS (
                SELECT
                    p.CD_PACIENTE AS PRONTUARIO,
                    p.NM_PACIENTE AS NOME,
                    p.DT_NASCIMENTO,
                    p.NM_MAE,
                    UPPER(
                        REGEXP_REPLACE(
                            REGEXP_REPLACE(
                            REGEXP_REPLACE(
                                REGEXP_REPLACE(
                                    REGEXP_REPLACE(
                                        TRIM(p.NM_PACIENTE),
                                        '\bDE\b', ' '
                                    ),
                                    '\bDA\b', ' '
                                ),
                                '\bDO\b', ' '
                            ),
                            '\bDAS\b', ' '
                            ),
                            '\bDOS\b', ' '
                        )
                    ) AS NOME_NORM
                FROM DBAMV.PACIENTE p
                WHERE p.DT_NASCIMENTO IS NOT NULL AND
                    p.NM_PACIENTE IS NOT NULL AND
                    p.CD_PACIENTE IS NOT NULL
        ),
        JN_GRUPO
            AS (
                SELECT
                    NOME_NORM,
                    DT_NASCIMENTO,
                    NM_MAE,
                    COUNT(*) AS QTD,
                    MAX(PRONTUARIO) AS PRONTUARIO_MAIS_RESCENTE
                FROM JN_BASE
                GROUP BY NOME_NORM, DT_NASCIMENTO, NM_MAE
                HAVING COUNT(*) > 1
        )
        SELECT
        b.PRONTUARIO,
        b.NOME,
        b.DT_NASCIMENTO,
        b.NM_MAE,
        CASE WHEN b.PRONTUARIO = g.PRONTUARIO_MAIS_RESCENTE THEN 1 END AS SN_RESCENTE
        FROM JN_BASE b
        JOIN JN_GRUPO g ON g.NOME_NORM = b.NOME_NORM AND
                        g.DT_NASCIMENTO = b.DT_NASCIMENTO AND
                        NVL(g.NM_MAE, '#') = NVL(b.NM_MAE, '#')
        ORDER BY
            b.NOME,
            b.DT_NASCIMENTO,
            b.nm_mae,
            b.PRONTUARIO
        ;
    ```
---

<br>
<br>

</details>