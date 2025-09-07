{{ config(tags=['staging']) }}
select
  id as user_id,
  display_name,
  creation_date,
  last_access_date,
  reputation,
  views as profile_views,
  up_votes,
  down_votes,
  location,
  website_url
from {{ source('stackoverflow', 'users') }}
