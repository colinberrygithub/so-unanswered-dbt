{{ config(tags=['staging']) }}
with src as (
  select
    id as question_id,
    owner_user_id,
    accepted_answer_id,
    creation_date,
    last_activity_date,
    title,
    body,
    tags,
    score,
    view_count,
    answer_count,
    favorite_count
  from {{ source('stackoverflow', 'posts_questions') }}
)
select * from src
