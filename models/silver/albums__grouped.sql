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
          _row
        , album_name
        , artist_name
        , date_load
    FROM src_kaggle_history
    ),

src_spotify_api_history AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_artificial") }}
    ),

filtered_sah AS (
    SELECT
          _row
        , album_name
        , artist_name
        , date_load
    FROM src_kaggle_history
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_kaggle") }}
    ),

filtered_sah2 AS (
    SELECT
          _row
        , album_name
        , artist_name
        , date_load
    FROM src_spotify_api_history2
    )

SELECT
          distinct (md5(album_name || artist_name)) AS album_id
        , _row
        , album_name 
        , date_load
FROM filtered_kh
UNION 
SELECT
          distinct (md5(album_name || artist_name)) AS album_id
        , _row
        , album_name 
        , date_load
FROM filtered_sah
UNION 
SELECT
          distinct (md5(album_name || artist_name)) AS album_id
        , _row
        , album_name 
        , date_load
FROM filtered_sah2