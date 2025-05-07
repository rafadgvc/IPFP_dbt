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
          spotify_track_uri AS uri
        , ts
        , platform
        , ms_played
        , track_name
        , artist_name
        , album_name
        , reason_start
        , reason_end
        , shuffle
        , skipped
    FROM src_kaggle_history
    WHERE src_kaggle_history.ms_played > 5000
    ),

src_spotify_api_history AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__history") }}
    ),

filtered_sah AS (
    SELECT
          uri
        , ts
        , platform
        , ms_played
        , track_name
        , artist_name
        , album_name
        , reason_start
        , reason_end
        , shuffle
        , skipped
    FROM src_spotify_api_history
    WHERE src_spotify_api_history.ms_played > 5000
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__history2") }}
    ),

filtered_sah AS (
    SELECT
          uri
        , ts
        , platform
        , ms_played
        , track_name
        , artist_name
        , album_name
        , reason_start
        , reason_end
        , shuffle
        , skipped
    FROM src_spotify_api_history2
    WHERE src_spotify_api_history2.ms_played > 5000
    ),

SELECT * FROM renamed_casted