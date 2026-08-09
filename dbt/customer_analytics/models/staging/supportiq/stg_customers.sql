{{ config(materialized='table') }}

select
    customer_id,
    company_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    lower(trim(email)) as email,
    job_title,
    country,
    cast(created_at as timestamp) as created_at,
    status
from {{ source('supportiq', 'customers') }}