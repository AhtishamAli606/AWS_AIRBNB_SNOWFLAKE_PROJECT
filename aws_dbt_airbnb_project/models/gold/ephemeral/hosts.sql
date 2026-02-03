{{ config(materialized='table') }}

with ranked as (
    select
        host_id,
        host_name,
        host_since,
        is_superhost,
        response_rate_quality,
        host_created_at,
        row_number() over (
            partition by host_id
            order by host_created_at desc
        ) as rn
    from {{ ref('silver_hosts') }}
)

select *
from ranked
where rn = 1;
