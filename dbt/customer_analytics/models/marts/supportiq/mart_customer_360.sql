{{ config(
    materialized='table',
    dist='customer_id',
    sort=['customer_id']
) }}

select
    customer_id,
    company_id,

    first_name,
    last_name,
    email,
    job_title,
    customer_country,
    customer_created_at,
    customer_status,

    company_name,
    industry,
    company_size,
    company_country,
    company_city,
    company_annual_revenue,

    -- Support
    total_tickets,
    open_tickets,
    resolved_tickets,
    high_priority_tickets,
    avg_first_response_minutes,
    avg_resolution_minutes,
    first_ticket_at,
    latest_ticket_at,

    -- Product usage
    total_feature_usage,
    distinct_features_used,
    total_product_events,
    distinct_product_events,
    total_sessions,
    first_feature_usage_date,
    latest_feature_usage_date,
    first_product_event_at,
    latest_product_event_at,
    first_session_at,
    latest_session_at,

    -- Financial
    total_subscriptions,
    active_subscriptions,
    active_monthly_recurring_revenue,
    total_invoiced_amount,
    total_paid_invoice_amount

from {{ ref('int_customer_360') }}
