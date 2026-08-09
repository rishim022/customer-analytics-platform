{{ config(materialized='table') }}

select
    c.customer_id,
    c.company_id,

    c.first_name,
    c.last_name,
    c.email,
    c.job_title,
    c.country as customer_country,
    c.created_at as customer_created_at,
    c.status as customer_status,

    co.company_name,
    co.industry,
    co.company_size,
    co.country as company_country,
    co.city as company_city,
    co.annual_revenue as company_annual_revenue,
    co.created_at as company_created_at

from {{ ref('stg_customers') }} c

left join {{ ref('stg_companies') }} co
    on c.company_id = co.company_id