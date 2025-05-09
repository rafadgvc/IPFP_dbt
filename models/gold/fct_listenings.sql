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
        , ts
        , md5(paltform) AS id_paltform
        , ms_played
        , md5(reason_start) AS id_reason_start
        , md5(reason_end) AS id_reason_end
        , shuffle
        , skipped
        , hashed_user_id
    FROM src_listenings_grouped
    )


SELECT * FROM filtered_lg