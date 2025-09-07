{{ config(tags=['staging']) }}
with a as (
  select
    id as answer_id,
    parent_id as question_id,
    owner_user_id,
    creation_date,
    last_activity_date,
    score
  from {{ source('stackoverflow', 'posts_answers') }}
),
q as (
  select
    id as question_id,
    accepted_answer_id
  from {{ source('stackoverflow', 'posts_questions') }}
)
select
  a.answer_id,
  a.question_id,
  a.owner_user_id,
  a.creation_date,
  a.last_activity_date,
  -- compute is_accepted via join to parent question
  (a.answer_id = q.accepted_answer_id) as is_accepted,
  a.score
from a
left join q using (question_id)
