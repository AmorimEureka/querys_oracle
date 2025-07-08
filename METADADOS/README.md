# 📘 Oracle SQL - Consultas para Exploração de Metadados e Sistema

Este documento contém uma coleção de queries SQL úteis para explorar estruturas de tabelas, colunas, constraints e informações de versão em um banco de dados Oracle. Ideal para profissionais de dados que precisam entender a modelagem de dados em ambientes Oracle.



## 📌 Consultas e Explicações

<br>

### 🔹 1. Listar todas as tabelas do usuário atual

```sql
SELECT * FROM USER_TABLES;
```
Retorna todas as tabelas pertencentes ao schema do usuário conectado. Útil para obter uma visão geral das tabelas disponíveis.

<br>


### 🔹 2. Verificar constraints de uma tabela

```sql
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'PRESTADOR';
```
Lista todas as constraints aplicadas à tabela `PRESTADOR`, como:
- P = Primary Key
- R = Foreign Key
- U = Unique
- C = Check

<br>


### 🔹 3. Ver estrutura de colunas de uma tabela

```sql
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'COLUNAS';
```
Mostra colunas da tabela `COLUNAS`, incluindo tipo, tamanho e se aceita NULL.

<br>


### 🔹 4. Buscar colunas por nome

```sql
SELECT * FROM USER_TAB_COLUMNS WHERE COLUMN_NAME = 'PAR';
```
Busca todas as colunas com nome exato `PAR`, retornando a(s) tabela(s) onde ela está presente.

<br>


### 🔹 5. Informações de estatísticas de uma tabela

```sql
SELECT * FROM ALL_TABLES atp WHERE atp.TABLE_NAME = 'ATENDIME';
```
Traz estatísticas da tabela `ATENDIME`, como:
- `NUM_ROWS`: total estimado de registros
- `LAST_ANALYZED`: data da última análise estatística da tabela

ℹ️ Para obter contagem real:
```sql
SELECT COUNT(*) FROM ATENDIME;
```

<br>


### 🔹 6. Mapeamento completo de colunas com constraints (com filtro)

```sql
SELECT
    cols.owner AS schema_name,
    sa.COLUMN_ID,
    cols.table_name,
    cols.column_name,
    cols.data_type,
    cols.data_length,
    cols.nullable,
    cons.constraint_type,
    cons.constraint_name
FROM
    all_tab_columns cols
LEFT JOIN
    all_cons_columns cons_cols
    ON cols.owner = cons_cols.owner
    AND cols.table_name = cons_cols.table_name
    AND cols.column_name = cons_cols.column_name
LEFT JOIN
    all_constraints cons
    ON cons.owner = cons_cols.owner
    AND cons.constraint_name = cons_cols.constraint_name
LEFT JOIN user_tab_columns sa
    ON sa.table_name = cols.table_name
    AND sa.column_name = cols.column_name
WHERE
    cols.column_name LIKE '%CD_ATENDIMENTO%'
ORDER BY
    sa.COLUMN_ID, cols.owner, cols.table_name, cols.column_name;
```

#### Explicação Detalhada

Essa query faz o mapeamento completo de colunas cujo nome contenha `'CD_ATENDIMENTO'`, e retorna informações estruturais e de restrições aplicadas.

##### Tabelas utilizadas:
- `ALL_TAB_COLUMNS cols`: metadados de todas as colunas visíveis ao usuário.
- `ALL_CONS_COLUMNS cons_cols`: associa colunas às constraints.
- `ALL_CONSTRAINTS cons`: traz os tipos de constraints (PK, FK, UNIQUE, CHECK).
- `USER_TAB_COLUMNS sa`: usado apenas para recuperar o `COLUMN_ID` (ordem da coluna).

##### 🔍 Campos retornados:
| Campo                | Descrição                                                     |
|---------------------|---------------------------------------------------------------|
| `schema_name`       | Nome do schema (dono da tabela)                               |
| `COLUMN_ID`         | Posição da coluna na tabela                                   |
| `table_name`        | Nome da tabela                                                |
| `column_name`       | Nome da coluna                                                |
| `data_type`         | Tipo de dado (ex: VARCHAR2, DATE, NUMBER)                     |
| `data_length`       | Tamanho do campo (ex: 255 para VARCHAR2(255))                 |
| `nullable`          | Se aceita NULL (`Y` ou `N`)                                   |
| `constraint_type`   | Tipo de constraint (P = PK, R = FK, U = UNIQUE, C = CHECK)    |
| `constraint_name`   | Nome da constraint associada à coluna                         |



##### 📐 Ordenação final:
```sql
ORDER BY sa.COLUMN_ID, cols.owner, cols.table_name, cols.column_name
```
Garante que o resultado respeite a ordem física das colunas dentro das tabelas.

<br>



### 🔹 7. Verificar versão do Oracle

```sql
SELECT * FROM v$version;
```
Mostra informações da versão do Oracle Database instalada e seus componentes (PL/SQL, NLS, etc.).

<br>



## 👨‍💻 Autor

**Eureka Amorim**
Analytics Engineer | Especialista em Dados Hospitalares
Stack: Oracle, PostgreSQL, Airflow, dbt-core, Power BI


