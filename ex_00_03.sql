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

'''The given query performs the following:

COUNT(event_id) AS events: This part of the query calculates the count of rows
where the event_name is 'view_item' in the dsv1069.events table and aliases the
result as 'events.' It counts the number of events with the name 'view_item.'
Based on this query, the following statements are true:

The query counts the number of events with the name 'view_item' (i.e., it counts
   how many events in the table have the event_name 'view_item').
The other statements cant be determined from this query alone because it doesnt
 provide information about specific values or additional conditions in the dataset.'''
