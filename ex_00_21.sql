'''Promo Email'''
'''Log onto Mode Analytics and from the home page, create a new report by clicking on the green
plus sign button in the upper right-hand corner. Enter the starter code where provided for each
exercise. You may want to create a new tab for each exercise.
Please use the discussion forum for any questions and/or comments you might have. Once you
have tried the exercises, feel free to watch the solutions video. Good luck with your practice!
Note: When querying a table, remember to prepend dsv1069, which is the schema, or folder
that contains the course data.
Exercise 1:
Create the right subtable for recently viewed events using the view_item_events table.
Starter Code:'''

--SELECT *
--FROM dsv1069.view_item_events

SELECT
  event_id   AS event,
  event_time AS time,
  DISTINCT user_id   AS user
FROM
  dsv1069.view_item_events
GROUP BY
  event_id,
  event_time,
  user_id
ORDER BY
  event_time

'''Exercise 2: Check your joins. Join your tables together recent_views, users, items
Starter Code: The result from Ex'''

SELECT
    event_id AS latest_event,
    event_time AS latest_time,
    user
FROM
    (SELECT
        user_id AS user,
        MAX(event_time) AS latest_event_time
    FROM
        dsv1069.view_item_events
    GROUP BY
        user_id
    ) latest_events
JOIN
    dsv1069.view_item_events subquery
ON
    latest_events = user_id
    AND latest_events.latest_event_time = subquery.event_time
ORDER BY
    latest_time;
