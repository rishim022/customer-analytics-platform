{{ config(materialized='table') }}

select
    plan_id,
    plan_name,
    monthly_price,
    max_users
from {{ source('supportiq', 'plans') }}