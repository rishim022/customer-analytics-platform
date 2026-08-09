{{ config(materialized='table') }}

select
    session_id,
    customer_id,
    session_start,
    session_end,
    device,
    country
from {{ source('supportiq', 'sessions') }}