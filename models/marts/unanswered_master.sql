{{ config(materialized='view') }}

SELECT
  fq.question_id,
  fq.user_sk,
  fq.date_sk,
  fq.answer_count,
  fq.view_count,
  fq.score,
  fq.favorite_count,

  CASE WHEN fq.answer_count = 0 THEN 1 ELSE 0 END AS unanswered_flag,
  SAFE_DIVIDE(fq.answer_count, NULLIF(fq.view_count, 0)) AS answers_per_view,

  bqt.tag_sk,
  dt.tag_name,
  du.reputation,
  dd.year  AS date_year,
  dd.month AS date_month
FROM {{ ref('fact_questions') }}            AS fq
LEFT JOIN {{ ref('bridge_question_tag') }}  AS bqt
  ON fq.question_id = bqt.question_id
LEFT JOIN {{ ref('dim_tag') }}              AS dt
  ON bqt.tag_sk = dt.tag_sk
LEFT JOIN {{ ref('dim_user') }}             AS du
  ON fq.user_sk = du.user_sk
LEFT JOIN {{ ref('dim_date') }}             AS dd
  ON fq.date_sk = dd.date_sk
