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
          reason_end
    FROM src_listenings
    )
SELECT 
      DISTINCT md5(reason_end) AS id_reason_end
    , reason_end
FROM 
    listenings
WHERE reason_end IS NOT NULL
