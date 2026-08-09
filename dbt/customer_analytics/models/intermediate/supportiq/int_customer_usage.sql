{{ config(materialized='table') }}

with feature_usage as (

    select
        customer_id,
        sum(usage_count) as total_feature_usage,
        count(distinct feature_name) as distinct_features_used,
        min(usage_date) as first_feature_usage_date,
        max(usage_date) as latest_feature_usage_date

    from {{ ref('int_feature_usage') }}

    group by customer_id

),

product_events as (

    select
        customer_id,
        count(*) as total_product_events,
        count(distinct event_name) as distinct_product_events,
        min(event_timestamp) as first_product_event_at,
        max(event_timestamp) as latest_product_event_at

    from {{ ref('int_product_events') }}

    group by customer_id

),

sessions as (

    select
        customer_id,
        count(*) as total_sessions,
        min(session_start) as first_session_at,
        max(session_start) as latest_session_at

    from {{ ref('int_sessions') }}

    group by customer_id

)

select
    coalesce(f.customer_id, p.customer_id, s.customer_id) as customer_id,

    coalesce(f.total_feature_usage, 0) as total_feature_usage,
    coalesce(f.distinct_features_used, 0) as distinct_features_used,
    f.first_feature_usage_date,
    f.latest_feature_usage_date,

    coalesce(p.total_product_events, 0) as total_product_events,
    coalesce(p.distinct_product_events, 0) as distinct_product_events,
    p.first_product_event_at,
    p.latest_product_event_at,

    coalesce(s.total_sessions, 0) as total_sessions,
    s.first_session_at,
    s.latest_session_at

from feature_usage f

full outer join product_events p
    on f.customer_id = p.customer_id

full outer join sessions s
    on coalesce(f.customer_id, p.customer_id) = s.customer_id