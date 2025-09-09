-- models/marts/unanswered_master.sql
{{ config(materialized='view') }}

select
  fq.question_id,
  fq.user_sk,
  fq.date_sk,
  fq.answer_count,
  fq.view_count,
  fq.score,
  fq.favorite_count,
  case when fq.answer_count = 0 then 1 else 0 end                                    as unanswered_flag,
  safe_divide(fq.answer_count, nullif(fq.view_count, 0))                              as answers_per_view,
  bqt.tag_sk,
  bqt.tag_name,
  du.reputation,
  dd.year  as date_year,
  dd.month as date_month
from {{ ref('fact_questions') }}            as fq
left join {{ ref('bridge_question_tag') }}  as bqt
  on fq.question_id = bqt.question_id
left join {{ ref('dim_user') }}             as du
  on fq.user_sk = du.user_sk
left join {{ ref('dim_date') }}             as dd
  on fq.date_sk = dd.date_sk
