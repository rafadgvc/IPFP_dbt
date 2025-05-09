{{
  config(
    materialized='view'
  )
}}
WITH src_listenings AS (
    SELECT * 
    FROM {{ ref("listenings__grouped") }}
    ),

listenings AS (
    SELECT
          paltform
    FROM src_listenings
    )
SELECT 
      DISTINCT md5(paltform) AS id_paltform
    , paltform
FROM 
    listenings
WHERE paltform IS NOT NULL
UNION ALL
SELECT '9999', 'UNKNOWN';
