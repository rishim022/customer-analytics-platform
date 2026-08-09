{{ config(
    materialized='table',
    dist='customer_id',
    sort=['created_at']
) }}

select
    ticket_id,
    customer_id,
    agent_id,

    subject,
    category,
    priority,
    channel,
    status,

    created_at,
    first_response_at,
    resolved_at,

    datediff(
        minute,
        created_at,
        first_response_at
    ) as first_response_minutes,

    datediff(
        minute,
        created_at,
        resolved_at
    ) as resolution_minutes,

    case
        when first_response_at is not null
        then true
        else false
    end as has_first_response,

    case
        when resolved_at is not null
        then true
        else false
    end as is_resolved,

    agent_first_name,
    agent_last_name,
    agent_email,
    agent_team,
    agent_country,
    agent_status

from {{ ref('int_tickets') }}
