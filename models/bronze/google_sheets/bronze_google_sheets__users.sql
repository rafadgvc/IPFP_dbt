{{
  config(
    materialized='table'
  )
}}
WITH raw_user_ids AS (
    SELECT  
        '62wauy6fpg5dg5s86y9bpof1r'    AS original_value,
        'ambystoma3'                   AS username,
        'Ambystoma Mexicanum'          AS name,
        'ambystomamexicanum@gmail.com' AS email

    UNION ALL
    SELECT  
        '95buwo3thj5dg5s12r9trop9c'    AS original_value,
        'cebus888'                     AS username,
        'Cebus Capucinus'              AS name,
        'cebuscapucinus2020@gmail.com' AS email
    UNION ALL
    SELECT  
        '14ysrj7atn9yn9s57h8cuie3w'    AS original_value,
        'sus_scrofa'                   AS username,
        'Sus Scrofa Domesticus'        AS name,
        'susscrofadom@gmail.com'       AS email
),

hashed_user_ids AS (
    SELECT
          original_value         AS original_id
        , md5(original_value) AS hashed_id
        , username
        , name
        , email
    FROM raw_user_ids
)

SELECT * FROM hashed_user_ids
