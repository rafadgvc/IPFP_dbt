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
          _row
        , spotify_track_uri AS uri
        , ts
        , platform
        , ms_played::INT AS ms_played
        , track_name
        , artist_name
        , album_name
        , reason_start
        , reason_end
        , shuffle
        , skipped
        , _fivetran_synced AS date_load
        
    FROM src_history
    )

SELECT * FROM renamed_casted