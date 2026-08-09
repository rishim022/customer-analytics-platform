{{ config(materialized='table') }}

select
    ticket_event_id,
    ticket_id,
    event_type,
    event_timestamp,
    actor_type
from {{ source('supportiq', 'ticket_events') }}