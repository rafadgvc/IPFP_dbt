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
dim_when_time AS (
    SELECT * 
    FROM {{ ref("dim_when_time") }}
    ),


mart_case AS (
    SELECT
          dwho.username             AS username
        , dwt.moment_of_day         AS moment_of_day
        , count(fct.listening_id)   AS total_listenings
    FROM 
        facts fct
    JOIN
        dim_when_time dwt
    ON 
        fct.time_id = dwt.time_id
    JOIN
        dim_who dwho 
    ON 
        fct.hashed_user_id = dwho.hashed_id

    GROUP BY
          dwho.username
        , dwt.moment_of_day
    ORDER BY
          dwho.username
        , total_listenings DESC
        , dwt.moment_of_day
    )


SELECT * FROM mart_case