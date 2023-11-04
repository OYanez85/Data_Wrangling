'''HOW TO CREATE A TABLE'''
'''STEP 5. INSERT DATA INTO TABLE - GOOD'''
REPLACE INTO
'view item events'

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

'''RATIONALE: So, Ive been using insert into, and what this does is it takes the
 data that I query and adds it into the table. So, it could be adding in a whole
bunch of duplicate data because I keep running this over and over again.
If instead what I wanted to do is replace everything in the table, I could use
  this command replace into, and that would clear out the table and just put the
 new stuff in and replace into is MySQL specific syntax, however its called,
 INSERT OVERWRITE instead of insert into. So, dont pay attention too much to
 that specific syntax. Again, we get no rows returned, but that is exactly
 what we would expect from the screen.'''
