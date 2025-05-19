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
        , kh.uri
        , kh.ts
        , CASE                                                        -- iOS, mac and Google_Home could have been kept, but these values are very similar to 
            WHEN kh.platform IS NULL            THEN 'unknown'        -- (and very much less frequent values than) the ones they are converted to 
            WHEN kh.platform = 'iOS'            THEN 'mobile'         -- null values have been kept, because it's the same as the "unknown" value already present
            WHEN kh.platform = 'mac'            THEN 'desktop'        -- in the data
            WHEN kh.platform = 'Google_Home'    THEN 'cast to device'
            ELSE kh.platform
            END AS platform
        , kh.ms_played
        , kh.track_name
        , kh.artist_name
        , kh.album_name
        , kh.reason_start
        , kh.reason_end
        , kh.shuffle
        , CASE                                                                  -- skipped is null in many cases, even though is not a very important attribute
            WHEN kh.skipped IS NOT NULL                      THEN kh.skipped    -- it's easier for the dataflow for it to not be null
            WHEN kh.skipped IS NULL AND kh.ms_played < 30000 THEN True          -- it's very likely that if less than 30 seconds have been played,
            ELSE False                                                          -- the track was skipped (very few tracks are less than 30 seconds long)
            END  AS skipped
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '95buwo3thj5dg5s12r9trop9c') AS hashed_user_id -- this allows to relate the listening to the user
        , date_load
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
        , sah.uri
        , TS
        , CASE                                                         -- iOS, mac and Google_Home could have been kept, but these values are very similar to 
            WHEN sah.platform IS NULL            THEN 'unknown'        -- (and very much less frequent values than) the ones they are converted to 
            WHEN sah.platform = 'iOS'            THEN 'mobile'         -- null values have been kept, because it's the same as the "unknown" value already present
            WHEN sah.platform = 'mac'            THEN 'desktop'        -- in the data
            WHEN sah.platform = 'Google_Home'    THEN 'cast to device'
            ELSE sah.platform
            END AS platform
        , sah.ms_played
        , sah.track_name
        , sah.artist_name
        , sah.album_name
        , sah.reason_start
        , sah.reason_end
        , sah.shuffle
        , CASE 
            WHEN sah.skipped IS NOT NULL                      THEN sah.skipped
            WHEN sah.skipped IS NULL AND sah.ms_played < 30000 THEN True
            ELSE False
            END AS skipped
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '62wauy6fpg5dg5s86y9bpof1r') AS hashed_user_id -- this allows to relate the listening to the user
        , date_load
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
        , sah.uri
        , TS
        , CASE                                                         -- iOS, mac and Google_Home could have been kept, but these values are very similar to 
            WHEN sah.platform IS NULL            THEN 'unknown'        -- (and very much less frequent values than) the ones they are converted to 
            WHEN sah.platform = 'iOS'            THEN 'mobile'         -- null values have been kept, because it's the same as the "unknown" value already present
            WHEN sah.platform = 'mac'            THEN 'desktop'        -- in the data
            WHEN sah.platform = 'Google_Home'    THEN 'cast to device'
            ELSE sah.platform
            END AS platform
        , sah.ms_played
        , sah.track_name
        , sah.artist_name
        , sah.album_name
        , sah.reason_start
        , sah.reason_end
        , sah.shuffle
        , CASE 
            WHEN sah.skipped IS NOT NULL                      THEN sah.skipped
            WHEN sah.skipped IS NULL AND sah.ms_played < 30000 THEN True
            ELSE False
            END AS skipped
        , (SELECT hashed_id FROM src_spotify_api_users WHERE original_id = '14ysrj7atn9yn9s57h8cuie3w') AS hashed_user_id -- this allows to relate the listening to the user
        , date_load
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