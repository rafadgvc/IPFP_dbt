{{
  config(
    materialized='view'
  )
}}
WITH src_spotify_users AS (
    SELECT * 
    FROM {{ ref("users__grouped") }}
    ),

src_spotify_users_id AS (
    SELECT * 
    FROM {{ ref("users__grouped_id") }}
    ),

grouped_users AS (
    SELECT DISTINCT
          ssui.original_id
        , ssu.hashed_id
        , ssu.username
        , ssu.name
        , ssu.email

    FROM 
        src_spotify_users ssu
    JOIN 
        src_spotify_users_id ssui
    ON 
        ssu.hashed_id = ssui.hashed_id

    )

SELECT * FROM grouped_users
