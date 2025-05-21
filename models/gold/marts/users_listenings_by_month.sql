{{
  config(
    materialized='view'
  )
}}

WITH facts AS (
    SELECT * 
    FROM {{ ref("fct_listenings") }}
    ),
dim_who AS (
    SELECT * 
    FROM {{ ref("dim_who") }}
    ),
dim_when_date AS (
    SELECT * 
    FROM {{ ref("dim_when_date") }}
    ),


mart_case AS (
    SELECT
          dwho.username             AS username
        , dwd.year                  AS year
        , dwd.month                 AS month
        , count(fct.listening_id)   AS total_listenings
    FROM 
        facts fct
    JOIN
        dim_when_date dwd
    ON 
        fct.date_id = dwd.date_id
    JOIN
        dim_who dwho 
    ON 
        fct.hashed_user_id = dwHo.hashed_id

    GROUP BY
          dwho.username
        , dwd.year
        , dwd.month
    ORDER BY
            dwho.username
        , dwd.year
        , dwd.month
    )


SELECT * FROM mart_case