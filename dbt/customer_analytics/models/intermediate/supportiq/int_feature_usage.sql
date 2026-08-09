{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='feature_usage_id',
    on_schema_change='sync_all_columns',
    dist='customer_id',
    sort=['usage_date']
) }}

select
    feature_usage_id,
    customer_id,
    feature_name,
    usage_count,
    cast(usage_date as date) as usage_date

from {{ ref('stg_feature_usage') }}

{% if is_incremental() %}

where usage_date >= (
    select coalesce(
        max(usage_date) - interval '2 days',
        '1900-01-01'::date
    )
    from {{ this }}
)

{% endif %}