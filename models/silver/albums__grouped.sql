{{
  config(
    materialized='table'
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

SELECT    -- the only rare instances in which an artist has two albums with the same name is in a deluxe version of it or similar,
          -- and in these cases tracks included in the "older" version are included in the new one, so we can safely assume they will be the same one
          distinct (md5(album_name || artist_name)) AS album_id
        , _row
        , album_name 
        , date_load
FROM filtered_kh
UNION 
SELECT    -- the only rare instances in which an artist has two albums with the same name is in a deluxe version of it or similar,
          -- and in these cases tracks included in the "older" version are included in the new one, so we can safely assume they will be the same one
          distinct (md5(album_name || artist_name)) AS album_id
        , _row
        , album_name 
        , date_load
FROM filtered_sah
UNION 
SELECT    -- the only rare instances in which an artist has two albums with the same name is in a deluxe version of it or similar,
          -- and in these cases tracks included in the "older" version are included in the new one, so we can safely assume they will be the same one
          distinct (md5(album_name || artist_name)) AS album_id
        , _row
        , album_name 
        , date_load
FROM filtered_sah2