{{ config(materialized='table') }}

select
    company_id,
    company_name,
    industry,
    company_size,
    country,
    city,
    annual_revenue,
    created_at
from {{ source('supportiq', 'companies') }}