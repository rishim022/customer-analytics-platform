{{ config(materialized='table') }}

select
    c.customer_id,
    c.company_id,

    c.first_name,
    c.last_name,
    c.email,
    c.job_title,
    c.customer_country,
    c.customer_created_at,
    c.customer_status,

    c.company_name,
    c.industry,
    c.company_size,
    c.company_country,
    c.company_city,
    c.company_annual_revenue,

    -- Support
    coalesce(s.total_tickets, 0) as total_tickets,
    coalesce(s.open_tickets, 0) as open_tickets,
    coalesce(s.resolved_tickets, 0) as resolved_tickets,
    coalesce(s.high_priority_tickets, 0) as high_priority_tickets,
    s.avg_first_response_minutes,
    s.avg_resolution_minutes,
    s.first_ticket_at,
    s.latest_ticket_at,

    -- Product usage
    coalesce(u.total_feature_usage, 0) as total_feature_usage,
    coalesce(u.distinct_features_used, 0) as distinct_features_used,
    coalesce(u.total_product_events, 0) as total_product_events,
    coalesce(u.distinct_product_events, 0) as distinct_product_events,
    coalesce(u.total_sessions, 0) as total_sessions,

    u.first_feature_usage_date,
    u.latest_feature_usage_date,
    u.first_product_event_at,
    u.latest_product_event_at,
    u.first_session_at,
    u.latest_session_at,

    -- Financial
    coalesce(f.total_subscriptions, 0) as total_subscriptions,
    coalesce(f.active_subscriptions, 0) as active_subscriptions,
    coalesce(
        f.active_monthly_recurring_revenue,
        0
    ) as active_monthly_recurring_revenue,
    coalesce(f.total_invoiced_amount, 0) as total_invoiced_amount,
    coalesce(f.total_paid_invoice_amount, 0) as total_paid_invoice_amount

from {{ ref('int_customers') }} c

left join {{ ref('int_customer_support') }} s
    on c.customer_id = s.customer_id

left join {{ ref('int_customer_usage') }} u
    on c.customer_id = u.customer_id

left join {{ ref('int_customer_financials') }} f
    on c.customer_id = f.customer_id