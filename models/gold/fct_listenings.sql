{{
  config(
    materialized='view'
  )
}}

WITH src_listenings_grouped AS (
    SELECT * 
    FROM {{ ref("listenings__grouped") }}
    ),

filtered_lg AS (
    SELECT
          uri
        , ts::DATE AS date_id
        , EXTRACT(HOUR FROM ts)::INT*60 + EXTRACT(MINUTE FROM ts)::INT AS time_id
        , md5(platform) AS id_platform
        , ms_played
        , CASE 
            WHEN reason_start IS NOT NULL THEN md5(reason_start)
            ELSE md5('unknown')
            END  AS id_reason_start
        , CASE 
            WHEN reason_end IS NOT NULL THEN md5(reason_end)
            ELSE md5('unknown')
            END  AS id_reason_end
        , shuffle
        , skipped
        , hashed_user_id
    FROM src_listenings_grouped
    )


SELECT * FROM filtered_lg