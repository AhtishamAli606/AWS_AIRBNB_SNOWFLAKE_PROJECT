{{ config(materialized='table') }}

select
    obt.booking_id,
    obt.listing_id,
    obt.host_id,
    obt.total_amount,
    obt.accommodates,
    obt.bedrooms,
    obt.bathrooms,
    obt.price_per_night,
    obt.response_rate
from {{ ref('obt') }} obt
left join {{ ref('dim_listings') }} dl
    on obt.listing_id = dl.listing_id
left join {{ ref('dim_hosts') }} dh
    on obt.host_id = dh.host_id

