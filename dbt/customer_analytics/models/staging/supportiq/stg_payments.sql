{{ config(materialized='table') }}

select
    payment_id,
    invoice_id,
    payment_date,
    amount,
    payment_method,
    status
from {{ source('supportiq', 'payments') }}