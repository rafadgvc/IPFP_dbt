{% test values_after_2008(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} < to_date ('2008-01-01')

{% endtest %}