{{ config(
    materialized='table',
    dist='customer_id',
    sort=['customer_id']
) }}

select
    customer_id,
    company_id,

    total_subscriptions,
    active_subscriptions,
    active_monthly_recurring_revenue,

    total_invoiced_amount,
    total_paid_invoice_amount,

    case
        when total_invoiced_amount > 0
        then total_paid_invoice_amount / total_invoiced_amount
        else 0
    end as invoice_collection_rate

from {{ ref('int_customer_financials') }}
