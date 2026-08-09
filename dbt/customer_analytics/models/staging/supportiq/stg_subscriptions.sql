{{ config(materialized='table') }}

select
    subscription_id,
    company_id,
    plan_id,
    start_date,
    status,
    monthly_price
from {{ source('supportiq', 'subscriptions') }}