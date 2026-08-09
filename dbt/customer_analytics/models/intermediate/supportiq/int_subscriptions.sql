{{ config(materialized='table') }}

select
    s.subscription_id,
    s.company_id,
    s.plan_id,

    s.start_date,
    s.status,
    s.monthly_price,

    p.plan_name,
    p.monthly_price as plan_monthly_price,
    p.max_users,

    c.company_name,
    c.industry,
    c.company_size

from {{ ref('stg_subscriptions') }} s

left join {{ ref('stg_plans') }} p
    on s.plan_id = p.plan_id

left join {{ ref('stg_companies') }} c
    on s.company_id = c.company_id