{{ config(materialized='view', tags=['dim']) }}
select
  {{ sk(["cast(question_id as string)"]) }} as question_sk,
  q.question_id,
  q.title,
  cast(q.creation_date as date) as created_date,
  q.score,
  q.view_count,
  q.answer_count,
  q.accepted_answer_id is not null as has_accepted_answer
from {{ ref('stg_stackoverflow__posts_questions') }} q
