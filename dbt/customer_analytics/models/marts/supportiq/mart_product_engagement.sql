{{ config(
    materialized='table',
    dist='customer_id',
    sort=['customer_id', 'feature_name']
) }}

with feature_usage as (

    select
        customer_id,
        feature_name,

        sum(usage_count) as total_usage_count,
        min(usage_date) as first_usage_date,
        max(usage_date) as latest_usage_date

    from {{ ref('int_feature_usage') }}

    group by
        customer_id,
        feature_name

),

product_events as (

    select
        customer_id,
        event_name,

        count(*) as total_events,
        min(event_timestamp) as first_event_at,
        max(event_timestamp) as latest_event_at

    from {{ ref('int_product_events') }}

    group by
        customer_id,
        event_name

)

select
    f.customer_id,
    f.feature_name,

    f.total_usage_count,
    f.first_usage_date,
    f.latest_usage_date,

    coalesce(p.total_events, 0) as total_events,
    p.first_event_at,
    p.latest_event_at

from feature_usage f

left join product_events p
    on f.customer_id = p.customer_id
    and f.feature_name = p.event_name
