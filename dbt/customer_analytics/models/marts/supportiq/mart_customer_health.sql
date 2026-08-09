{{ config(
    materialized='table',
    dist='customer_id',
    sort=['customer_id']
) }}

select
    c.customer_id,
    c.company_id,

    c.customer_status,
    c.industry,
    c.company_size,

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

    coalesce(s.total_tickets, 0) as total_tickets,
    coalesce(s.open_tickets, 0) as open_tickets,
    coalesce(s.resolved_tickets, 0) as resolved_tickets,
    coalesce(s.high_priority_tickets, 0) as high_priority_tickets,

    s.avg_first_response_minutes,
    s.avg_resolution_minutes,

    case
        when coalesce(s.open_tickets, 0) >= 3
          or coalesce(s.high_priority_tickets, 0) >= 2
            then 'at_risk'

        when coalesce(u.total_sessions, 0) = 0
            then 'low_engagement'

        when coalesce(u.total_product_events, 0) > 0
          and coalesce(s.open_tickets, 0) = 0
            then 'healthy'

        else 'monitor'
    end as customer_health_status

from {{ ref('int_customers') }} c

left join {{ ref('int_customer_usage') }} u
    on c.customer_id = u.customer_id

left join {{ ref('int_customer_support') }} s
    on c.customer_id = s.customer_id
