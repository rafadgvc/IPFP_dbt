{{
  config(
    materialized='table'
  )
}}

WITH src_listenings_grouped AS (
    SELECT * 
    FROM {{ ref("listenings__grouped") }}
    ),
src_listenings_grouped_id AS (
    SELECT * 
    FROM {{ ref("listenings__grouped_id") }}
    ),


filtered_lg AS (
    SELECT
          slg.listening_id
        , slgi._row
        , slg.uri
        , slg.ts::DATE AS date_id
        , EXTRACT(HOUR FROM slg.ts)::INT*60 + EXTRACT(MINUTE FROM slg.ts)::INT AS time_id
        , md5(slg.platform) AS id_platform
        , slg.ms_played
        , CASE 
            WHEN slg.reason_start IS NOT NULL THEN md5(slg.reason_start)
            ELSE md5('unknown')
            END  AS id_reason_start
        , CASE 
            WHEN slg.reason_end IS NOT NULL THEN md5(slg.reason_end)
            ELSE md5('unknown')
            END  AS id_reason_end
        , slg.shuffle
        , slg.skipped
        , slg.hashed_user_id
        , slg.date_load
    FROM 
        src_listenings_grouped slg
    JOIN
        src_listenings_grouped_id slgi
    ON 
        slg.listening_id = slgi.listening_id
    )


SELECT * FROM filtered_lg