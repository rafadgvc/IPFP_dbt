{{
  config(
    materialized='table'
  )
}}
WITH src_spotify_users AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__users") }}
    ),

grouped_users AS (
    SELECT
          hashed_id
        , username
        , name
        , email
    FROM src_spotify_users
    )

SELECT * FROM grouped_users
