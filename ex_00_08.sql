'''Flexible Data Formats. assignment'''
'''Exercise 1: Write a query to format the view_item event into a table with the
 appropiate columns.
 Secret goal: figure out how to do it for multiple parameters

 In this exercise we are passing the referer info from having it in 2 different columns,
 to a single one by creating a column called referrer as follows in the third exercise: 
 MAX(CASE WHEN parameter_name = 'item_id'
       THEN CAST(parameter_value AS INT)
       ELSE NULL
       END) AS item_id,
 MAX(CASE WHEN parameter_name = 'referrer'
       THEN parameter_value
       ELSE NULL
       END) AS referrer

Starter code:

SELECT *
FROM dsv1069.events
WHERE event_name = 'view_item' '''

SELECT
  user_id,
  event_time AS view_time,
  event_id AS item_id,
  platform
FROM dsv1069.events
WHERE event_name = 'view_item';

'''Exercise 2:
Goal: Write a query to format the view_item event into a table with the appropriate columns
(This replicates what we had in the slides, but it is missing a column)
Starter Code'''

SELECT
  event_id,
  event_time,
  user_id,
  platform,
  event_name,
  (CASE WHEN parameter_name = 'item_id'
        THEN CAST(parameter_value AS INT)
        ELSE NULL
        END) AS item_id
FROM
  dsv1069.events
WHERE
  event_name = 'view_item'
ORDER BY event_id;

'''Exercise 3:
Goal: Use the result from the previous exercise, but make sure...?
Starter Code: (Ex#2)'''

SELECT
  event_id,
  event_time,
  user_id,
  platform,
  MAX(CASE WHEN parameter_name = 'item_id'
        THEN CAST(parameter_value AS INT)
        ELSE NULL
        END) AS item_id,
  MAX(CASE WHEN parameter_name = 'referrer'
        THEN parameter_value
        ELSE NULL
        END) AS referrer
FROM
  dsv1069.events
WHERE
  event_name = 'view_item'
GROUP BY
  event_id,
  event_time,
  user_id,
  platform;
