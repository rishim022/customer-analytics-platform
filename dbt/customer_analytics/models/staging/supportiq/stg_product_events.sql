{{ config(materialized='table') }}

select
    event_id,
    customer_id,
    event_name,
    event_timestamp,
    source
from {{ source('supportiq', 'product_events') }}