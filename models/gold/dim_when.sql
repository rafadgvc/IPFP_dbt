
with dates as (
    select
        dateadd(day, seq4(), '2000-01-01')::date as date
    from table(generator(rowcount => 9497))  -- 9497 días entre 2000-01-01 y 2025-12-31
)
select
     date
    ,extract(year from date) as year
    ,extract(month from date) as month
    ,monthname(date) as month_name
    ,extract(day from date) as day
    ,extract(dayofweek from date) as number_week_day
    ,dayname(date) as week_day
    ,extract(quarter from date) as quarter
from dates

