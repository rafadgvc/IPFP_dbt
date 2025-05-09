{{
  config(
    materialized='view'
  )
}}
WITH src_spotify_users AS (
    SELECT * 
    FROM {{ ref("users__grouped") }}
    ),

grouped_users AS (
    SELECT DISTINCT
          original_id
        , hashed_id
        , username
        , name
        , email
    FROM src_spotify_users
    )

SELECT * FROM grouped_users
