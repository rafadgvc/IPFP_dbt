{{
  config(
    materialized='view'
  )
}}
WITH src_spotify_users AS (
    SELECT * 
    FROM {{ ref("bronze_spotify_api__users") }}
    ),

grouped_users AS (
    SELECT
          original_id
        , hashed_id
        , username
        , name
        , email
    FROM src_spotify_users
    )

SELECT * FROM grouped_users
