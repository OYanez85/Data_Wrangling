'''Exercise 4:
--Goal: Check out the query below. This is not the right way to count the number of viewed_item
events. Determine what is wrong and correct the error.
Starter Code:
SELECT
COUNT(event_id) AS events
FROM dsv1069.events
WHERE event_name = ‘view_item’'''

SELECT
COUNT(event_id) AS events
FROM dsv1069.events
WHERE event_name = 'view_item'
