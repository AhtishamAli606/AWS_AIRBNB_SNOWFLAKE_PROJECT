{{ config(
    materialized='incremental',
    unique_key='HOST_ID'
) }}

with ranked_hosts as (

    select
        HOST_ID,
        replace(HOST_NAME, ' ', '_') as HOST_NAME,
        HOST_SINCE,
        IS_SUPERHOST,
        RESPONSE_RATE,
        case
            when RESPONSE_RATE > 95 then 'VERY GOOD'
            when RESPONSE_RATE >= 80 then 'GOOD'
            when RESPONSE_RATE >= 60 then 'FAIR'
            else 'POOR'
        end as RESPONSE_RATE_QUALITY,
        CREATED_AT,
        row_number() over (
            partition by HOST_ID
            order by CREATED_AT desc
        ) as rn
    from {{ ref('bronze_hosts') }}

)

select
    HOST_ID,
    HOST_NAME,
    HOST_SINCE,
    IS_SUPERHOST,
    RESPONSE_RATE,
    RESPONSE_RATE_QUALITY,
    CREATED_AT
from ranked_hosts
where rn = 1
