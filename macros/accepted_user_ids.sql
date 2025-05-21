{% test accepted_user_ids(model, column_name) %}
 -- it should be noted that this test would 
 -- have to be changed if new users were added
   select *
   from {{ model }}
   where {{ column_name }} NOT IN (   
          '62wauy6fpg5dg5s86y9bpof1r'
        , '95buwo3thj5dg5s12r9trop9c'
        , '14ysrj7atn9yn9s57h8cuie3w'
        )
{% endtest %}