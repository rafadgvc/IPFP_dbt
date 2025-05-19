{{
  config(
    materialized='table'
  )
}}

WITH src_kaggle_history AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_kaggle") }}
    ),

filtered_kh AS (
    SELECT
          _row
        , uri
        , track_name
        , date_load
    FROM src_kaggle_history
    ),

src_spotify_api_history AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_self") }}
    ),

filtered_sah AS (
    SELECT
          _row
        , uri
        , track_name
        , date_load
    FROM src_spotify_api_history
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_artificial") }}
    ),

filtered_sah2 AS (
    SELECT
          _row
        , uri
        , track_name
        , date_load
    FROM src_spotify_api_history2
    ),

src_kaggle_tracks AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__tracks_data") }}
    ),

filtered_kt AS (
    SELECT
          _row
        , id AS uri
        , name AS track_name
        , date_load
    FROM src_kaggle_tracks
    )

SELECT * FROM filtered_kh
UNION
SELECT * FROM filtered_sah
UNION
SELECT * FROM filtered_sah2
UNION
SELECT * FROM filtered_kt