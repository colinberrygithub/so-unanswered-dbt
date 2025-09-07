{{ config(tags=['analysis']) }}
with q as (
  select
    cast(date_trunc(cast(creation_date as date), month) as date) as month_start,
    lower(tag_name) as tag_name,
    count(*) as questions
  from {{ ref('stg_stackoverflow__posts_questions') }} q
  join {{ ref('int_question_tags') }} t using (question_id)
  group by 1,2
),
a as (
  select
    cast(date_trunc(cast(a.creation_date as date), month) as date) as month_start,
    lower(t.tag_name) as tag_name,
    count(distinct a.question_id) as questions_answered,
    countif(a.is_accepted) as accepted_answers
  from {{ ref('stg_stackoverflow__posts_answers') }} a
  join {{ ref('int_question_tags') }} t using (question_id)
  group by 1,2
)
select
  q.month_start,
  q.tag_name,
  q.questions,
  coalesce(a.questions_answered, 0) as questions_answered,
  coalesce(a.accepted_answers, 0) as accepted_answers,
  safe_divide(coalesce(a.questions_answered,0), q.questions) as answer_rate,
  safe_divide(coalesce(a.accepted_answers,0), q.questions) as accepted_rate
from q
left join a
  on q.month_start = a.month_start and q.tag_name = a.tag_name
