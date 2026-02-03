{% macro multiply(a, b, decimals=2) %}
    ROUND({{ a }} * {{ b }}, {{ decimals }})
{% endmacro %}
