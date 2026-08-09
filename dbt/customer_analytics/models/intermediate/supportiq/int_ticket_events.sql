{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='ticket_event_id',
    dist='ticket_id',
    sort=['event_timestamp']
) }}

select
    ticket_event_id,
    ticket_id,
    event_type,
    event_timestamp,
    actor_type

from {{ ref('stg_ticket_events') }}

{% if is_incremental() %}

where event_timestamp >= (
    select coalesce(
        max(event_timestamp) - interval '2 days',
        '1900-01-01'::timestamp
    )
    from {{ this }}
)

{% endif %}
