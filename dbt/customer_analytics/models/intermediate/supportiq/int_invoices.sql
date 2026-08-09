{{ config(materialized='table') }}

select
    i.invoice_id,
    i.subscription_id,

    i.invoice_date,
    i.due_date,
    i.amount,
    i.status as invoice_status,

    s.company_id,
    s.plan_id,
    s.plan_name,
    s.status as subscription_status,
    s.monthly_price

from {{ ref('stg_invoices') }} i

left join {{ ref('int_subscriptions') }} s
    on i.subscription_id = s.subscription_id