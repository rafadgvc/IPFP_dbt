{{
  config(
    materialized='view'
  )
}}

WITH src_kaggle_history AS (
    SELECT * 
    FROM {{ ref("bronze_kaggle__history") }}
    ),

src_spotify_api_users AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__users") }}
    ),

filtered_kh AS (
    SELECT
          kh.uri
        , kh.ts
        , CASE 
            WHEN kh.platform IS NULL            THEN 'unknown'
            WHEN kh.platform = 'iOS'            THEN 'mobile'
            WHEN kh.platform = 'mac'            THEN 'desktop'
            WHEN kh.platform = 'Google_Home'   THEN 'cast to device'
            ELSE kh.platform
            END AS platform
        , kh.ms_played
        , kh.track_name
        , kh.artist_name
        , kh.album_name
        , kh.reason_start
        , kh.reason_end
        , kh.shuffle
        , CASE 
            WHEN kh.skipped IS NOT NULL                      THEN kh.skipped
            WHEN kh.skipped IS NULL AND kh.ms_played < 30000 THEN True
            ELSE False
            END  AS skipped
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '95buwo3thj5dg5s12r9trop9c') AS hashed_user_id
    FROM src_kaggle_history AS kh
    WHERE 
        kh.ms_played > 5000    AND
        kh.uri IS NOT NULL
    ),

src_spotify_api_history AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__history") }}
    ),

filtered_sah AS (
    SELECT
          sah.uri
        , TO_TIMESTAMP(sah.ts, 'YYYY-MM-DD HH24:MI:SS') AS TS
        , CASE 
            WHEN sah.platform IS NULL            THEN 'unknown'
            WHEN sah.platform = 'iOS'            THEN 'mobile'
            WHEN sah.platform = 'mac'            THEN 'desktop'
            WHEN sah.platform = 'Google_Home'    THEN 'cast to device'
            ELSE sah.platform
            END AS platform
        , sah.ms_played
        , sah.track_name
        , sah.artist_name
        , sah.album_name
        , sah.reason_start
        , sah.reason_end
        , sah.shuffle
        , CASE 
            WHEN sah.skipped IS NOT NULL                      THEN sah.skipped
            WHEN sah.skipped IS NULL AND sah.ms_played < 30000 THEN True
            ELSE False
            END AS skipped
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '62wauy6fpg5dg5s86y9bpof1r') AS hashed_user_id
    FROM src_spotify_api_history AS sah
    WHERE 
        sah.ms_played > 5000    AND
        sah.uri IS NOT NULL
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__history2") }}
    ),

filtered_sah2 AS (
    SELECT
          sah.uri
        , TO_TIMESTAMP(sah.ts, 'YYYY-MM-DD HH24:MI:SS') AS TS
        , CASE 
            WHEN sah.platform IS NULL            THEN 'unknown'
            WHEN sah.platform = 'iOS'            THEN 'mobile'
            WHEN sah.platform = 'mac'            THEN 'desktop'
            WHEN sah.platform = 'Google_Home'    THEN 'cast to device'
            ELSE sah.platform
            END AS platform
        , sah.ms_played
        , sah.track_name
        , sah.artist_name
        , sah.album_name
        , sah.reason_start
        , sah.reason_end
        , sah.shuffle
        , CASE 
            WHEN sah.skipped IS NOT NULL                      THEN sah.skipped
            WHEN sah.skipped IS NULL AND sah.ms_played < 30000 THEN True
            ELSE False
            END AS skipped
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '14ysrj7atn9yn9s57h8cuie3w') AS hashed_user_id
    FROM src_spotify_api_history2 AS sah
    WHERE 
        sah.ms_played > 5000    AND
        sah.uri IS NOT NULL

    )

SELECT * FROM filtered_kh
UNION
SELECT * FROM filtered_sah
UNION
SELECT * FROM filtered_sah2