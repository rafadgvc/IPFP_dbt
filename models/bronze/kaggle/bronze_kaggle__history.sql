{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='date_load',
    begin='2024-10-25',
    batch_size='day',
    lookback=2
) }}

WITH src_history AS (
    SELECT * 
    FROM {{ source('kaggle', 'history') }}
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