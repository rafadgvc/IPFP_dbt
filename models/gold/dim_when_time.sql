{{
  config(
    materialized='view'
  )
}}
WITH sequenced_times AS (
    SELECT
        seq4() AS minutes
    FROM table(generator(rowcount => 1440))
)
SELECT
      minutes AS time_id
    , FLOOR(minutes/60) AS hour
    , minutes % 60 AS minute
    , TO_CHAR(FLOOR(minutes/60), 'FM00') || ':' || TO_CHAR(minutes % 60, 'FM00') AS formatted_time
    , CASE 
      WHEN FLOOR(minutes/60) BETWEEN 6  AND 11 THEN 'Morning'
      WHEN FLOOR(minutes/60) BETWEEN 12 AND 15 THEN 'Midday'
      WHEN FLOOR(minutes/60) BETWEEN 14 AND 20 THEN 'Evening'
      ELSE 'Night'
      END AS moment_of_day
FROM sequenced_times
