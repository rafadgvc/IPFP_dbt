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
          kh.uri
        , kh.ts
        , kh.platform
        , kh.ms_played
        , kh.track_name
        , kh.artist_name
        , kh.album_name
        , kh.reason_start
        , kh.reason_end
        , kh.shuffle
        , kh.skipped
        , hashed_user_id
    FROM src_kaggle_history
    )


SELECT * FROM filtered_kh
UNION
SELECT * FROM filtered_sah
UNION
SELECT * FROM filtered_sah2