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
        , artist_name
        , date_load
    FROM src_spotify_api_history
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_kaggle") }}
    ),

filtered_sah2 AS (
    SELECT
          _row
        , artist_name
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
        -- this allows to transform artist names from "['artist1', 'artist2'...]"" to "artist1", so that only the first artist name is kept
        , regexp_substr(artists, '''([^'']+)''', 1, 1, 'e', 1)   AS artist_name  
        , date_load
    FROM src_kaggle_tracks
    )

SELECT
          distinct md5(artist_name) AS artist_id  -- We can assume that artist names are not repeated (it rarely does happen)
        , _row
        , date_load    
        , artist_name 
FROM filtered_kh
UNION 
SELECT
          distinct md5(artist_name) AS artist_id  -- We can assume that artist names are not repeated (it rarely does happen)
        , _row
        , date_load    
        , artist_name 
FROM filtered_sah
UNION 
SELECT
          distinct md5(artist_name) AS artist_id  -- We can assume that artist names are not repeated (it rarely does happen)
        , _row
        , date_load    
        , artist_name  
FROM filtered_sah2
UNION 
SELECT
          distinct md5(artist_name) AS artist_id  -- We can assume that artist names are not repeated (it rarely does happen)
        , _row
        , date_load    
        , artist_name 
FROM filtered_kt