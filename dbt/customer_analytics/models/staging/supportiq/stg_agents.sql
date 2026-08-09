{{ config(materialized='table') }}

select
    agent_id,
    first_name,
    last_name,
    email,
    team,
    country,
    hire_date,
    status
from {{ source('supportiq', 'agents') }}