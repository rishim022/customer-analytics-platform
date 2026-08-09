{{ config(materialized='table') }}

select
    feature_usage_id,
    customer_id,
    feature_name,
    usage_count,
    usage_date
from {{ source('supportiq', 'feature_usage') }}