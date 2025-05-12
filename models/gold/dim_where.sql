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
          platform
    FROM src_listenings
    )
SELECT 
      DISTINCT md5(platform) AS id_platform
    , platform
FROM 
    listenings
WHERE platform IS NOT NULL
UNION ALL
SELECT '9999', 'UNKNOWN'
