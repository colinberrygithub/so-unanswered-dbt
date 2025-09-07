{{ config(tags=['analysis']) }}
with date_window as (
  select date_sub(current_date(), interval 90 day) as start_date
),
recent as (
  select
    lower(t.tag_name) as tag_name,
    count(*) as questions_recent
  from {{ ref('stg_stackoverflow__posts_questions') }} q
  join {{ ref('int_question_tags') }} t using (question_id)
  join date_window w on cast(q.creation_date as date) >= w.start_date
  group by 1
),
answered as (
  select
    lower(t.tag_name) as tag_name,
    count(distinct a.question_id) as questions_answered_recent
  from {{ ref('stg_stackoverflow__posts_answers') }} a
  join {{ ref('int_question_tags') }} t using (question_id)
  join date_window w on cast(a.creation_date as date) >= w.start_date
  group by 1
),
scored as (
  select
    r.tag_name,
    r.questions_recent,
    coalesce(a.questions_answered_recent, 0) as questions_answered_recent,
    1.0 - safe_divide(coalesce(a.questions_answered_recent, 0), nullif(r.questions_recent, 0)) as unanswered_rate,
    r.questions_recent as raw_volume
  from recent r
  left join answered a using (tag_name)
),
stats as (
  select
    avg(raw_volume) as mu,
    stddev_samp(raw_volume) as sigma
  from scored
)
select
  s.tag_name,
  s.questions_recent,
  s.questions_answered_recent,
  s.unanswered_rate,
  (s.raw_volume - st.mu) / nullif(st.sigma,0) as volume_zscore,
  0.6*s.unanswered_rate + 0.4*least(greatest((s.raw_volume - st.mu) / nullif(st.sigma,0), -3), 3) / 3 as risk_score
from scored s cross join stats st
qualify row_number() over (order by risk_score desc nulls last) <= 100
