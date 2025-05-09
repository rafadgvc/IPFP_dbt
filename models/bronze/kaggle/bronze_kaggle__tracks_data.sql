{{
  config(
    materialized='view'
  )
}}

WITH src_tracks_data AS (
    SELECT * 
    FROM {{ source('kaggle', 'songs_data') }}
    ),

renamed_casted AS (
    SELECT
          valence
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
        , realease_date AS release_date
        , speechiness
        , tempo
    FROM src_tracks_data
    )

SELECT * FROM renamed_casted