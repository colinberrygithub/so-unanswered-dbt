-- models/marts/bridge_question_tag.sql
{{ config(materialized='view') }}

select
  question_id,
  {{ dbt_utils.generate_surrogate_key(['cast(question_id as string)']) }} as question_sk,
  lower(tag_name)                                                   as tag_name,
  {{ dbt_utils.generate_surrogate_key(['lower(tag_name)']) }}       as tag_sk
from {{ ref('int_question_tags') }}
