{% test accepted_platforms(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} NOT IN (   
          'unknown'
        , 'web player'
        , 'android'
        , 'mobile'
        , 'desktop'
        , 'cast to device'
        , 'windows'
        )
{% endtest %}