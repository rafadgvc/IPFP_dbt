{{
  config(
    materialized='table'
  )
}}

WITH src_kaggle_history AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_kaggle") }}
    ),

src_spotify_api_users AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__users") }}
    ),

filtered_kh AS (
    SELECT
          _row
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '95buwo3thj5dg5s12r9trop9c') AS hashed_user_id -- this allows to relate the listening to the user
        , md5(_row || hashed_user_id) AS listening_id                           -- this is NOT needed (as the uniqueness in this table could be checked with _row and hashed_used_id),
    FROM src_kaggle_history AS kh                                               -- but it can be used as a double check for non repeated listenings
    WHERE 
        kh.ms_played > 5000    AND                                              -- listenings that have lasted less than 5 seconds or that have a null uri 
        kh.uri IS NOT NULL                                                      -- are not really important because they don't give notable information
    ),

src_spotify_api_history AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_self") }}
    ),

filtered_sah AS (
    SELECT
          _row
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '62wauy6fpg5dg5s86y9bpof1r') AS hashed_user_id -- this allows to relate the listening to the user
        , md5(_row || hashed_user_id) AS listening_id                 -- this is NOT needed (as the uniqueness in this table could be checked with _row and hashed_used_id),
    FROM src_spotify_api_history AS sah                               -- but it can be used as a double check for non repeated listenings
    WHERE 
        sah.ms_played > 5000    AND                                   -- listenings that have lasted less than 5 seconds or that have a null uri 
        sah.uri IS NOT NULL                                           -- are not really important because they don't give notable information
    ),

src_spotify_api_history2 AS (
    SELECT * 
    FROM {{ ref("bronze_google_sheets__history_artificial") }}
    ),

filtered_sah2 AS (
    SELECT
          _row
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '14ysrj7atn9yn9s57h8cuie3w') AS hashed_user_id -- this allows to relate the listening to the user
        , md5(_row || hashed_user_id) AS listening_id                 -- this is NOT needed (as the uniqueness in this table could be checked with _row and hashed_used_id),
    FROM src_spotify_api_history AS sah                               -- but it can be used as a double check for non repeated listenings
    WHERE 
        sah.ms_played > 5000    AND                                   -- listenings that have lasted less than 5 seconds or that have a null uri 
        sah.uri IS NOT NULL                                           -- are not really important because they don't give notable information

    )

SELECT * FROM filtered_kh
UNION
SELECT * FROM filtered_sah
UNION
SELECT * FROM filtered_sah2