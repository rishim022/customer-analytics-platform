{{ config(materialized='table') }}

select
    csat_id,
    ticket_id,
    rating,
    feedback,
    submitted_at
from {{ source('supportiq', 'customer_satisfaction') }}