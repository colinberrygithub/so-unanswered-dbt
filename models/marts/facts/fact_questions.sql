{{ config(materialized='view', tags=['fact']) }}
with base as (
  select
    {{ sk(["cast(q.question_id as string)"]) }} as question_sk,
    {{ sk(["cast(q.owner_user_id as string)"]) }} as user_sk,
    {{ sk(["cast(cast(q.creation_date as date) as string)"]) }} as date_sk,
    q.question_id,
    q.owner_user_id as asker_user_id,
    cast(q.creation_date as date) as created_date,
    q.accepted_answer_id,
    q.score,
    q.view_count,
    q.answer_count,
    q.favorite_count
  from {{ ref('stg_stackoverflow__posts_questions') }} q
)
select * from base
