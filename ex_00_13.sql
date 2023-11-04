'''HOW TO CREATE A TABLE'''
'''STEP 3. CREATE THE TABLE'''
'''Here we create the table structure'''
CREATE TABLE IF NOT EXISTS 'view_item_events' (
  event_id    VARCHAR(32) NOT NULL PRIMARY KEY,
  event_time  VARCHAR(26) ,
  user_id     INT(10) ,
  platform    VARCHAR(10) ,
  item_id     INT(10),
  referrer    VARCHAR(17)
);


INSERT INTO
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

'''when running the query it gave error: the view_item_events already existed:
SOLUTION: to add IF NOT EXISTS:
CREATE TABLE IF NOT EXISTS 'view_item_events' ( (on line 4 of the code)'''
