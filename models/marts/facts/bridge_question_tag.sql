{{ config(tags=['bridge']) }}
select
  {{ sk(["cast(qt.question_id as string)"]) }} as question_sk,
  {{ sk(["qt.tag_name"]) }} as tag_sk,
  qt.question_id,
  qt.tag_name
from {{ ref('int_question_tags') }} qt
