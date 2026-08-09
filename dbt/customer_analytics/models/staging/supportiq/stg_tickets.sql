{{ config(materialized='table') }}

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
    resolved_at
from {{ source('supportiq', 'tickets') }}