{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='event_id',
    on_schema_change='sync_all_columns',
    dist='customer_id',
    sort=['event_timestamp']
) }}

select
    event_id,
    customer_id,
    event_name,
    cast(event_timestamp as timestamp) as event_timestamp,
    source

from {{ ref('stg_product_events') }}

{% if is_incremental() %}

where event_timestamp >= (
    select coalesce(
        max(event_timestamp) - interval '2 days',
        '1900-01-01'::timestamp
    )
    from {{ this }}
)

{% endif %}