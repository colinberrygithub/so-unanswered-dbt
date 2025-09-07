{{ config(tags=['dim']) }}
with tags_meta as (
  select
    lower(tag_name) as tag_name,
    count as tag_usage_count_reported,
    excerpt_post_id,
    wiki_post_id
  from {{ source('stackoverflow', 'tags') }}
),
observed as (
  select distinct lower(tag_name) as tag_name
  from {{ ref('int_question_tags') }}
),
combined as (
  select
    coalesce(m.tag_name, o.tag_name) as tag_name,
    m.tag_usage_count_reported,
    m.excerpt_post_id,
    m.wiki_post_id
  from observed o
  full outer join tags_meta m
    on o.tag_name = m.tag_name
)
select
  {{ sk(["tag_name"]) }} as tag_sk,
  *
from combined
