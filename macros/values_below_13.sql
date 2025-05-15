{% test values_below_13(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} >= 13

{% endtest %}