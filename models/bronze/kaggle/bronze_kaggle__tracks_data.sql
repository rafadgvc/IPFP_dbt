{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='date_load',
    begin='2024-10-25',
    batch_size='day',
    lookback=2
) }}

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
        , release_date
        , speechiness
        , tempo
    FROM src_tracks_data
    )

SELECT * FROM renamed_casted