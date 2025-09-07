{{ config(materialized='view', tags=['fact']) }}
with base as (
  select
    {{ sk(["cast(a.answer_id as string)"]) }} as answer_sk,
    {{ sk(["cast(a.question_id as string)"]) }} as question_sk,
    {{ sk(["cast(a.owner_user_id as string)"]) }} as user_sk,
    {{ sk(["cast(cast(a.creation_date as date) as string)"]) }} as date_sk,
    a.answer_id,
    a.question_id,
    a.owner_user_id as answerer_user_id,
    cast(a.creation_date as date) as created_date,
    a.is_accepted,
    a.score
  from {{ ref('stg_stackoverflow__posts_answers') }} a
)
select * from base
