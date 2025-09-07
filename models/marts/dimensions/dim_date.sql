{{ config(tags=['dim']) }}
with calendar as (
  select
    d as date_day,
    extract(year from d) as year,
    extract(quarter from d) as quarter,
    extract(month from d) as month,
    format_date('%Y-%m', d) as yyyymm
  from unnest(generate_date_array(date('2008-01-01'), current_date(), interval 1 day)) as d
)
select
  {{ sk(["cast(date_day as string)"]) }} as date_sk,
  *
from calendar
