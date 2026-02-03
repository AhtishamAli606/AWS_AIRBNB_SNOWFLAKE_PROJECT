{{ config(materialized='table') }}

with ranked as (
    select
        listing_id,
        property_type,
        room_type,
        city,
        country,
        price_per_night,
        listing_created_at,
        row_number() over (
            partition by listing_id
            order by listing_created_at desc
        ) as rn
    from {{ ref('silver_listings') }}
)

select *
from ranked
where rn = 1;
