{{ config(materialized='table') }}

select
    t.customer_id,

    count(distinct t.ticket_id) as total_tickets,

    count(
        distinct case
            when t.status = 'open'
            then t.ticket_id
        end
    ) as open_tickets,

    count(
        distinct case
            when t.status = 'resolved'
            then t.ticket_id
        end
    ) as resolved_tickets,

    count(
        distinct case
            when t.priority = 'high'
            then t.ticket_id
        end
    ) as high_priority_tickets,

    avg(
        datediff(
            minute,
            t.created_at,
            t.first_response_at
        )
    ) as avg_first_response_minutes,

    avg(
        datediff(
            minute,
            t.created_at,
            t.resolved_at
        )
    ) as avg_resolution_minutes,

    min(t.created_at) as first_ticket_at,
    max(t.created_at) as latest_ticket_at

from {{ ref('int_tickets') }} t

group by
    t.customer_id