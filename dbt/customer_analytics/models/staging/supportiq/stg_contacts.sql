{{ config(materialized='table') }}

select
    contact_id,
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    contact_type,
    created_at
from {{ source('supportiq', 'contacts') }}