{{ config(materialized='table') }}

select
    p.payment_id,
    p.invoice_id,

    p.payment_date,
    p.amount as payment_amount,
    p.payment_method,
    p.status as payment_status,

    i.subscription_id,
    i.company_id,
    i.plan_id,
    i.plan_name,
    i.invoice_date,
    i.invoice_status

from {{ ref('stg_payments') }} p

left join {{ ref('int_invoices') }} i
    on p.invoice_id = i.invoice_id