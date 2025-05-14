{{
  config(
    materialized='view'
  )
}}

WITH src_history AS (
    SELECT * 
    FROM {{ source('google_sheets', 'history_artificial') }}
    ),

renamed_casted AS (
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
    FROM src_history
    )

SELECT * FROM renamed_casted