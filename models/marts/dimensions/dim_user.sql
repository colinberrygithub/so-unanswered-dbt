{{ config(tags=['dim']) }}
select
  {{ sk(["cast(user_id as string)"]) }} as user_sk,
  user_id,
  display_name,
  cast(creation_date as date) as user_created_date,
  reputation,
  location
from {{ ref('stg_stackoverflow__posts_users') }}
