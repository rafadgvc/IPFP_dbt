{% test accepted_starting_reasons(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} NOT IN (   
          'unknown'
        , 'endplay'
        , 'nextbtn'
        , 'clickrow'
        , 'remote'
        , 'popup'
        , 'trackdone'
        , 'appload'
        , 'backbtn'
        , 'trackerror'
        , 'autoplay'
        , 'fwdbtn'
        , 'playbtn'
        )
{% endtest %}