{% test values_above_5000(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} < 5000

{% endtest %}