'''HOW TO CREATE A TABLE'''
'''STEP 4. INSERT DATA - BAD COLUMNS'''

INSERT INTO
'view item events'

SELECT
  /*event_id, */
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

'''RATIONALE: if you commented: Column count doesnt match value count at row 1.
Because the event_id was commented on line 8.'''
