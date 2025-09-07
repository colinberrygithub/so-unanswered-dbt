{% macro sk(columns) -%}
    to_hex(md5(cast(concat({{ columns | map('string') | join(',') }}) as bytes)))
{%- endmacro %}
