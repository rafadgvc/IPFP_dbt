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
          reason_start
    FROM src_listenings
    )
SELECT 
      DISTINCT md5(reason_start) AS id_reason_start
    , reason_start
FROM 
    listenings
WHERE reason_start IS NOT NULL
UNION ALL
SELECT '9999', 'UNKNOWN';
