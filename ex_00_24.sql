'''Exercise 1: Figure out how many tests we have running right now
Starter code as:'''
SELECT
  *
FROM
  dsv1069.events
WHERE
  event_name = 'test_assignment'
-----------
SELECT
  COUNT(DISTINCT event_name)
FROM
  dsv1069.events
GROUP BY
  event_name
  ----------------
  SELECT
    DISTINCT event_name
  FROM
    dsv1069.events

'''Exercise 2: Check for potential problems with test assignments. For example Make sure there
is no data obviously missing (This is an open ended question)'''

--SELECT
  --parameter_name AS parameter_name,
  --CASE WHEN event_id IS NULL THEN 1 ELSE 0 END AS Null_event,
  --CASE WHEN event_time IS NULL THEN 1 ELSE 0 END AS Null_time,
  --CASE WHEN user_id IS NULL THEN 1 ELSE 0 END AS Null_user_id,
  --CASE WHEN event_name IS NULL THEN 1 ELSE 0 END AS Null_event_name,
  --CASE WHEN platform IS NULL THEN 1 ELSE 0 END AS Null_platform,
  --CASE WHEN parameter_name IS NULL THEN 1 ELSE 0 END AS Null_parameter_name,
  --CASE WHEN parameter_value IS NULL THEN 1 ELSE 0 END AS Null_parameter_value
--FROM dsv1069.events;

SELECT
  SUM(CASE WHEN event_id IS NULL THEN 1 ELSE 0 END) AS Total_Null_event,
  SUM(CASE WHEN event_time IS NULL THEN 1 ELSE 0 END) AS Total_Null_time,
  SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS Total_Null_user_id,
  SUM(CASE WHEN event_name IS NULL THEN 1 ELSE 0 END) AS Total_Null_event_name,
  SUM(CASE WHEN platform IS NULL THEN 1 ELSE 0 END) AS Total_Null_platform,
  SUM(CASE WHEN parameter_name IS NULL THEN 1 ELSE 0 END) AS Total_Null_parameter_name,
  SUM(CASE WHEN parameter_value IS NULL THEN 1 ELSE 0 END) AS Total_Null_parameter_value,
  SUM(
    CASE
      WHEN event_id IS NULL THEN 1 ELSE 0 END +
    CASE
      WHEN event_time IS NULL THEN 1 ELSE 0 END +
    CASE
      WHEN user_id IS NULL THEN 1 ELSE 0 END +
    CASE
      WHEN event_name IS NULL THEN 1 ELSE 0 END +
    CASE
      WHEN platform IS NULL THEN 1 ELSE 0 END +
    CASE
      WHEN parameter_name IS NULL THEN 1 ELSE 0 END +
    CASE
      WHEN parameter_value IS NULL THEN 1 ELSE 0 END
  ) AS Total_Null_AllColumns
FROM dsv1069.events;
'''Exercise 3: Write a query that returns a table of assignment events.Please include all of the
relevant parameters as columns (Hint: A previous exercise as a template)
Starter Code:'''

'''Exercise 4: Check for potential assignment problems with test_id 5. Specifically, make sure
users are assigned only one treatment group'''
