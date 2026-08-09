{{ config(materialized='table') }}

with customer_companies as (

    select
        customer_id,
        company_id

    from {{ ref('stg_customers') }}

),

company_financials as (

    select
        s.company_id,

        count(distinct s.subscription_id) as total_subscriptions,

        count(
            distinct case
                when s.status = 'active'
                then s.subscription_id
            end
        ) as active_subscriptions,

        sum(
            case
                when s.status = 'active'
                then s.monthly_price
                else 0
            end
        ) as active_monthly_recurring_revenue

    from {{ ref('stg_subscriptions') }} s

    group by s.company_id

),

company_invoices as (

    select
        s.company_id,

        sum(i.amount) as total_invoiced_amount,

        sum(
            case
                when i.status = 'paid'
                then i.amount
                else 0
            end
        ) as total_paid_invoice_amount

    from {{ ref('stg_invoices') }} i

    left join {{ ref('stg_subscriptions') }} s
        on i.subscription_id = s.subscription_id

    group by s.company_id

)

select
    c.customer_id,
    c.company_id,

    coalesce(f.total_subscriptions, 0) as total_subscriptions,
    coalesce(f.active_subscriptions, 0) as active_subscriptions,
    coalesce(f.active_monthly_recurring_revenue, 0) as active_monthly_recurring_revenue,

    coalesce(i.total_invoiced_amount, 0) as total_invoiced_amount,
    coalesce(i.total_paid_invoice_amount, 0) as total_paid_invoice_amount

from customer_companies c

left join company_financials f
    on c.company_id = f.company_id

left join company_invoices i
    on c.company_id = i.company_id