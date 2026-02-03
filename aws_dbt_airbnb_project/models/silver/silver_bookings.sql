{{ 
    config(
        materialized='incremental',
        unique_key='BOOKING_ID',
        incremental_strategy='merge'
    )
}}

with ranked as (

    select
        BOOKING_ID,
        LISTING_ID,
        BOOKING_DATE,
        {{ multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT', 2) }}
            + CLEANING_FEE
            + SERVICE_FEE as TOTAL_AMOUNT,
        BOOKING_STATUS,
        CREATED_AT,
        row_number() over (
            partition by BOOKING_ID
            order by CREATED_AT desc
        ) as rn
    from {{ ref('bronze_bookings') }}

)

select
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE,
    TOTAL_AMOUNT,
    BOOKING_STATUS,
    CREATED_AT
from ranked
where rn = 1
