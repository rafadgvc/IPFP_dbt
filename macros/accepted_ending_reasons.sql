{% test accepted_ending_reasons(model, column_name) %}

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
        , 'unexpected-exit'
        , 'trackerror'
        , 'unexpected-exit-while-paused'
        , 'logout'
        , 'autoplay'
        , 'fwdbtn'
        , 'reload'
    )
{% endtest %}