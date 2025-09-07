{{ config(tags=['intermediate']) }}
with base as (
  select
    q.question_id,
    lower(tag) as tag_name
  from {{ ref('stg_stackoverflow__posts_questions') }} q,
  unnest(regexp_extract_all(q.tags, r'<([^>]+)>')) as tag
)
select * from base
