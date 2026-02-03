{{ config(materialized='table') }}

{% set configs = [
    {
        "table_name": "AIRBNB.SILVER.SILVER_BOOKINGS",
        "columns": "BOOKINGS.*",
        "alias": "BOOKINGS"
    },
    {
        "table_name": "AIRBNB.SILVER.SILVER_LISTINGS",
        "columns": "
            LISTINGS.HOST_ID,
            LISTINGS.PROPERTY_TYPE,
            LISTINGS.ROOM_TYPE,
            LISTINGS.CITY,
            LISTINGS.COUNTRY,
            LISTINGS.ACCOMMODATES,
            LISTINGS.BEDROOMS,
            LISTINGS.BATHROOMS,
            LISTINGS.PRICE_PER_NIGHT,
            LISTINGS.CREATED_AT AS LISTING_CREATED_AT
        ",
        "alias": "LISTINGS",
        "join_condition": "BOOKINGS.listing_id = LISTINGS.listing_id"
    },
    {
        "table_name": "AIRBNB.SILVER.SILVER_HOSTS",
        "columns": "
            HOSTS.HOST_NAME,
            HOSTS.HOST_SINCE,
            HOSTS.IS_SUPERHOST,
            HOSTS.RESPONSE_RATE,
            HOSTS.RESPONSE_RATE_QUALITY,
            HOSTS.CREATED_AT AS HOST_CREATED_AT
        ",
        "alias": "HOSTS",
        "join_condition": "LISTINGS.host_id = HOSTS.host_id"
    }
] %}

select
{% for c in configs %}
    {{ c.columns }}{% if not loop.last %},{% endif %}
{% endfor %}

from {{ configs[0].table_name }} {{ configs[0].alias }}

{% for c in configs[1:] %}
left join {{ c.table_name }} {{ c.alias }}
    on {{ c.join_condition }}
{% endfor %}
