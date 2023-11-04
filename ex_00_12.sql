'''HOW TO CREATE A TABLE'''
'''STEP 2. EDIT THE QUERY'''
'''EDIT THE QUERY'''
'''So, we might need to at this point edit the query a little bit to make sure
that the data types are coming out right. So, for example here Ive slapped on
this timestamp. Im going to gloss over this here but Im taking time to make
this an extra step because I want to make sure that you know that editing a
table that lots of people uses really delicate and it makes sense to test all of
 your little steps, all of your little change.'''
 CREATE TABLE
   view_item_events_1
 AS
 SELECT
   event_id,
   TIMESTAMP(event_time) AS event_time,
   user_id,
   platform,
   MAX(CASE WHEN parameter_name = 'item_id'
         THEN parameter_value
         ELSE NULL
       END) AS item_id,
   MAX(CASE WHEN parameter_name = 'referrer'
         THEN parameter_value
         ELSE NULL
       END) AS item_id,
   MAX(CASE WHEN parameter_name = 'referrer'
         THEN parameter_value
         ELSE NULL
       END) AS referrer
   FROM
     events
   WHERE
     event_name = 'view_item'
   GROUP BY
     event_id,
     event_time,
     user_id,
     platform
   ORDER BY
     event_id
