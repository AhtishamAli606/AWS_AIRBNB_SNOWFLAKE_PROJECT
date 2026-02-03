{{ config(
    materialized='incremental',
    unique_key='listing_id'
) }}

with ranked as (
    select
        listing_id,
        host_id,
        property_type,
        room_type,
        city,
        country,
        accommodates,
        bedrooms,
        bathrooms,
        price_per_night,
        created_at,
        row_number() over (
            partition by listing_id
            order by created_at desc
        ) as rn
    from {{ ref('bronze_listings') }}
)

select *
from ranked
where rn = 1
