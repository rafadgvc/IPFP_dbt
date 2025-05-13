{{
  config(
    materialized='view'
  )
}}

WITH src_listenings_grouped AS (
    SELECT * 
    FROM {{ ref("listenings__grouped") }}
    ),
listenings AS (
    SELECT
          track_name
        , album_name
        , artist_name
    FROM src_listenings_grouped
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
      DISTINCT(t.uri)       AS track_id
    , MIN(t.track_name)     AS track_name
    , MIN(al.album_name)    AS album_name
    , MIN(al.album_id)      AS album_id
    , MIN(ar.artist_name)   AS artist_name
    , MIN(ar.artist_id)     AS artist_id

FROM 
    listenings l
JOIN
    tracks t ON l.track_name = t.track_name
JOIN
    albums al ON l.album_name = al.album_name
JOIN 
    artists ar ON l.artist_name = ar.artist_name
GROUP BY track_id