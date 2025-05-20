{{
  config(
    materialized='table'
  )
}}

WITH src_listenings_grouped AS (
    SELECT * 
    FROM {{ ref("listenings__grouped") }}
    ),
listenings AS (
    SELECT 
          DISTINCT(uri)
        , MIN(track_name)   AS track_name
        , MIN(album_name)   AS album_name
        , MIN(artist_name)  AS artist_name
    FROM src_listenings_grouped
    GROUP BY URI
    ),

src_tracks AS (
    SELECT * 
    FROM {{ ref("tracks__grouped") }}
    ),
tracks AS (
    SELECT 
          uri
        , track_name
    FROM src_tracks
    ),
src_albums AS (
    SELECT * 
    FROM {{ ref("albums__grouped") }}
    ),
albums AS (
    SELECT
          album_id
          , album_name
    FROM src_albums
    ),

src_artists AS (
    SELECT * 
    FROM {{ ref("artists__grouped") }}
    ),
artists AS (
    SELECT
          artist_id
        , artist_name
    FROM src_artists
    )


SELECT 
      l.uri                                     AS track_id
    , l.track_name                              AS track_name
    , l.album_name                              AS album_name
    , (md5(l.album_name || l.artist_name))      AS album_id
    , l.artist_name                             AS artist_name
    , md5(l.artist_name)                        AS artist_id

FROM 
    listenings l

