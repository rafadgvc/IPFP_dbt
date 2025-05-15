{% test values_after_may_2025(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} < to_date ('2025-05-12')

{% endtest %}