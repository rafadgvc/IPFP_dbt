{% test values_below_7(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} >= 7

{% endtest %}