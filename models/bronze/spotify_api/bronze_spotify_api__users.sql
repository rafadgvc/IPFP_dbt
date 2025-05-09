{{
  config(
    materialized='table'
  )
}}
WITH raw_user_ids AS (
    SELECT  '62wauy6fpg5dg5s86y9bpof1r' AS original_value
    UNION ALL
    SELECT  '95buwo3thj5dg5s12r9trop9c'
    UNION ALL
    SELECT  '14ysrj7atn9yn9s57h8cuie3w'
),

hashed_user_ids AS (
    SELECT
          original_value         AS original_id
        , md5(original_value) AS hashed_id
    FROM raw_user_ids
)

SELECT * FROM hashed_user_ids
