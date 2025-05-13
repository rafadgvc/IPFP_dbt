{% test accepted_user_ids(model, column_name) %}

   select *
   from {{ model }}
   where {{ column_name }} NOT IN (   
          '62wauy6fpg5dg5s86y9bpof1r'
        , '95buwo3thj5dg5s12r9trop9c'
        , '14ysrj7atn9yn9s57h8cuie3w'
        )
{% endtest %}