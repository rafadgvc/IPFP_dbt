{{
  config(
    materialized='table'
  )
}}
WITH sequenced_dates AS (
    SELECT
        dateadd(day, seq4(), '2008-01-01')::DATE AS date
    FROM table(generator(rowcount => 7300))
)
SELECT
      date AS date_id
    , EXTRACT(year FROM date) AS year
    , EXTRACT(month FROM date) AS month
    , monthname(date) AS month_name
    , EXTRACT(day FROM date) AS day
    , EXTRACT(dayofweek FROM date) AS number_week_day
    , dayname(date) AS week_day
    , EXTRACT(quarter FROM date) AS quarter
FROM sequenced_dates
