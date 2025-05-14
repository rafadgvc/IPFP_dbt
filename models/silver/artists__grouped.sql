{{
  config(
    materialized='view'
  )
}}
WITH src_kaggle_history AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_self") }}
    ),

filtered_kh AS (
    SELECT
          artist_name
    FROM src_kaggle_history
    ),
src_spotify_api_history AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_artificial") }}
    ),

filtered_sah AS (
    SELECT
          artist_name
    FROM src_spotify_api_history
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_kaggle") }}
    ),

filtered_sah2 AS (
    SELECT
          artist_name
    FROM src_spotify_api_history2
    ),

src_kaggle_tracks AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__tracks_data") }}
    ),

filtered_kt AS (
    SELECT
          
           regexp_substr(artists, '''([^'']+)''', 1, 1, 'e', 1)   AS artist_name
    FROM src_kaggle_tracks
    )

SELECT    distinct md5(artist_name) AS artist_id 
        , artist_name 
FROM filtered_kh
UNION 
SELECT    distinct md5(artist_name) AS artist_id 
        , artist_name 
FROM filtered_sah
UNION 
SELECT    distinct md5(artist_name) AS artist_id 
        , artist_name 
FROM filtered_sah2
UNION 
SELECT    distinct md5(artist_name) AS artist_id 
        , artist_name  
FROM filtered_kt