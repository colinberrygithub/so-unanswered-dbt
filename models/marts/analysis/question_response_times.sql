{{ config(tags=['analysis']) }}
with first_answer as (
  select
    a.question_id,
    min(a.creation_date) as first_answer_ts
  from {{ ref('stg_stackoverflow__posts_answers') }} a
  group by 1
)
select
  q.question_id,
  q.title,
  q.creation_date as question_ts,
  fa.first_answer_ts,
  timestamp_diff(fa.first_answer_ts, q.creation_date, hour) as hours_to_first_answer,
  q.accepted_answer_id is not null as has_accepted_answer
from {{ ref('stg_stackoverflow__posts_questions') }} q
left join first_answer fa using (question_id)
