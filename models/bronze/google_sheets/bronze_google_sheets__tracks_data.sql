{{
  config(
    materialized='view'
  )
}}

WITH src_tracks_data AS (
    SELECT * 
    FROM {{ source('google_sheets', 'songs_data') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , valence
        , year
        , acousticness
        , artists
        , danceability
        , duration_ms
        , energy
        , explicit
        , id
        , instrumentalness
        , key
        , liveness
        , loudness
        , mode
        , name
        , popularity
        , release_date
        , speechiness
        , tempo
        , _fivetran_synced AS date_load
    FROM src_tracks_data
    )

SELECT * FROM renamed_casted