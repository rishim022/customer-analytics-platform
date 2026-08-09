{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='session_id',
    dist='customer_id',
    sort=['session_start']
) }}

select
    session_id,
    customer_id,
    session_start,
    session_end,
    device,
    country

from {{ ref('stg_sessions') }}

{% if is_incremental() %}

where session_start >= (
    select coalesce(
        max(session_start) - interval '2 days',
        '1900-01-01'::timestamp
    )
    from {{ this }}
)

{% endif %}
