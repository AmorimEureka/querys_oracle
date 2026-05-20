flowchart TB

%% =========================
%% 1) FONTE - MV / ORACLE
%% =========================
A["1️⃣ MV / Oracle (Fonte)
Tabelas:
- DBAMV.LEITOS
- DBAMV.OCUPACAO_LEITO
- DBAMV.PACIENTES
- ESCALA_ENFERMEIRO"]

%% =========================
%% 2) INGESTAO - DLT
%% =========================
B["2️⃣ Airflow Task: dlt_run_ocupacao
Carga incremental para Postgres DW
Schema: raw_mv"]

B1["raw_mv.leitos"]
B2["raw_mv.ocupacao_leito"]
B3["raw_mv.pacientes"]
B4["raw_mv.escala_enfermeiro"]

%% =========================
%% 3) TRANSFORMACAO STAGING
%% =========================
C["3️⃣ dbt run (staging)
Schema: stg"]

C1["stg_leitos"]
C2["stg_ocupacao_leito"]
C3["stg_pacientes"]
C4["stg_escala_enfermeiro"]

%% =========================
%% 4) OCUPACAO ATUAL
%% =========================
D["4️⃣ dbt model
int_ocupacao_atual_leito
(1 linha por leito com paciente atual)"]

%% =========================
%% 5) SNAPSHOT
%% =========================
E["5️⃣ dbt snapshot
snap_ocupacao_atual_leito
(SCD - historico por leito)
Campos:
- leito_id
- paciente_id
- dbt_valid_from
- dbt_valid_to"]

%% =========================
%% 6) EVENTO DE TROCA
%% =========================
F["6️⃣ dbt model
int_evento_troca_ocupacao
Detecta:
- paciente_anterior
- paciente_novo
- dt_troca"]

%% =========================
%% 7) JANELA TURNO
%% =========================
G["7️⃣ dbt model
dim_janela_turno
(MT 07-19 / SN 19-07)
Campos:
- turno
- dt_inicio
- dt_fim
- data_referencia"]

%% =========================
%% 8) GERACAO DOCUMENTO
%% =========================
H["8️⃣ dbt model
mart_documento_por_janela_horario

Chave base:
(data_referencia, turno, unidade_id, leito_id)

Campos:
- paciente_id
- enfermeiro_matricula
- status_documento"]

%% =========================
%% 9) CHECK CONDICIONAL
%% =========================
I["9️⃣ Airflow Task: check_changes
Verifica se houve:
- evento de troca
- novo turno iniciado"]

%% =========================
%% 10) PUBLICACAO RAILWAY
%% =========================
J["🔟 Airflow Task: publish_railway
Upsert para Railway
Schema: app"]

J1["app_unidades"]
J2["app_leitos"]
J3["app_ocupacao_atual_leito"]
J4["app_janela_turno"]
J5["app_documento_por_janela_horario"]

%% =========================
%% 11) GET MOCHA
%% =========================
K["1️⃣1️⃣ Get Mocha
Tela lista:
app_documento_por_janela_horario"]

L["1️⃣2️⃣ Get Mocha
Formulario preenchido →
app_avaliacao_dispositivo_vascular"]

%% =========================
%% CONEXOES
%% =========================
A --> B
B --> B1
B --> B2
B --> B3
B --> B4

B --> C
C --> C1
C --> C2
C --> C3
C --> C4

C --> D
D --> E
E --> F
F --> H
G --> H

H --> I
I --> J

J --> J1
J --> J2
J --> J3
J --> J4
J --> J5

J5 --> K
K --> L
