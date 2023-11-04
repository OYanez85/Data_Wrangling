'''HOW TO CREATE A TABLE'''
'''STEP 1. WRITE A QUERY'''
'''Turn a Clean Query Into a Table (Activity/Solution)'''
'''Just need to add the CREATE TABLE chunk. Just the 2 lines below:'''
CREATE TABLE
  view_item_events_1
AS
SELECT
  event_id,
  event_time,
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
