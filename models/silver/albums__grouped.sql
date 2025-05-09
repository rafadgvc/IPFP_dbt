{{
  config(
    materialized='view'
  )
}}

WITH src_kaggle_history AS (
    SELECT * 
    FROM {{ ref("bronze_kaggle__history") }}
    ),

filtered_kh AS (
    SELECT
          album_name
        , artist_name
    FROM src_kaggle_history
    ),

src_spotify_api_history AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__history") }}
    ),

filtered_sah AS (
    SELECT
          album_name
        , artist_name
    FROM src_kaggle_history
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__history2") }}
    ),

filtered_sah2 AS (
    SELECT
          album_name
        , artist_name
    FROM src_spotify_api_history2
    )

SELECT    distinct (md5(album_name || artist_name)) AS album_id 
        , album_name 
FROM filtered_kh
UNION 
SELECT    distinct (md5(album_name || artist_name)) AS album_id 
        , album_name 
FROM filtered_sah
UNION 
SELECT    distinct (md5(album_name || artist_name)) AS album_id 
        , album_name 
FROM filtered_sah2