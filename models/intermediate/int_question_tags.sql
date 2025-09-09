-- models/intermediate/int_question_tags.sql
{{ config(materialized='view') }}

with exploded as (
  select
    q.question_id,
    lower(tag) as tag_name
  from {{ ref('stg_stackoverflow__posts_questions') }} as q,
  unnest(split(q.tags, '|')) as tag
  where q.tags is not null
    and tag <> ''
)
select * from exploded
