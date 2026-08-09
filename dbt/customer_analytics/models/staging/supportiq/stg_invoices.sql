{{ config(materialized='table') }}

select
    invoice_id,
    subscription_id,
    invoice_date,
    due_date,
    amount,
    status
from {{ source('supportiq', 'invoices') }}