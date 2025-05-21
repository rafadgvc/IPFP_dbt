{{
  config(
    materialized='view'
  )
}}

WITH facts AS (
    SELECT * 
    FROM {{ ref("fct_listenings") }}
    ),
dim_what AS (
    SELECT * 
    FROM {{ ref("dim_what") }}
    ),
dim_when_date AS (
    SELECT * 
    FROM {{ ref("dim_when_date") }}
    ),


mart_case AS (
    SELECT
          dwhat.artist_name                         AS artist_name
        , dwd.year                                  AS year
        , dwd.month                                 AS month
        , count(distinct (fct.listening_id))        AS total_listenings
    FROM 
        facts fct
    JOIN
        dim_when_date dwd
    ON 
        fct.date_id = dwd.date_id
    JOIN
        dim_what dwhat 
    ON 
        fct.uri = dwhat.track_id

    GROUP BY
          dwhat.artist_name
        , dwd.year
        , dwd.month
    ORDER BY
            dwhat.artist_name
        , dwd.year
        , dwd.month
    )


SELECT * FROM mart_case