{{ config(materialized='table') }}

select
    t.ticket_id,
    t.customer_id,
    t.agent_id,

    t.subject,
    t.category,
    t.priority,
    t.channel,
    t.status,

    t.created_at,
    t.first_response_at,
    t.resolved_at,

    a.first_name as agent_first_name,
    a.last_name as agent_last_name,
    a.email as agent_email,
    a.team as agent_team,
    a.country as agent_country,
    a.status as agent_status

from {{ ref('stg_tickets') }} t

left join {{ ref('stg_agents') }} a
    on t.agent_id = a.agent_id