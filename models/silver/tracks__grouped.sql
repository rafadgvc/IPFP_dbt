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
          uri
        , track_name
    FROM src_kaggle_history
    ),

src_spotify_api_history AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__history") }}
    ),

filtered_sah AS (
    SELECT
          uri
        , track_name
    FROM src_kaggle_history
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__history2") }}
    ),

filtered_sah2 AS (
    SELECT
          uri
        , track_name
    FROM src_kaggle_history2
    ),

src_kaggle_tracks AS (
    SELECT * 
    FROM {{ ref("bronze_kaggle__tracks_data") }}
    ),

filtered_kt AS (
    SELECT
          id AS uri
        , name AS track_name
    FROM src_kaggle_history
    )

SELECT * FROM filtered_kh
UNION
SELECT * FROM filtered_sah
UNION
SELECT * FROM filtered_sah2
UNION
SELECT * FROM filtered_kt