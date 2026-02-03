{{
  config(
    materialized = 'incremental',
    )
}}


select * from {{ source('staging', 'bookings') }}

{% if incremental_flag == 1 %} 
    WHERE {{ incremental_col }} > (SELECT COALESCE(MAX({{ incremental_col }}), '1900-01-01 00:00:00') FROM {{ this }})
{% endif %}
