'''FINAL ASSIGNMENT'''
'''1. DATA QUALITY CHECK. --We are running an experiment at an item-level, which means all users who visit will see the same page, but the layout of different item pages may differ.
--Compare this table to the assignment events we captured for user_level_testing.
--Does this table have everything you need to compute metrics like 30-day view-binary?'''
SELECT
  *
FROM
  dsv1069.final_assignments_qa

---SOLUTION: No it doesnt because we lack a date column so that we can group the data by test_id
---and the date, and the event_rows column will show how many events occurred for each unique combination of test_id and day.

'''2.REFORMAT THE DATA.'''
'''Reformat the final_assignments_qa to look like the final_assignments table, filling in any missing values with a placeholder of the appropriate data type.'''

SELECT
  dsv1069.final_assignments_qa.item_id,
  test_a AS test_assignment,
  CASE
    WHEN test_a IS NOT NULL THEN 'item_test_1'
  ELSE 'Null'
  END AS test_number,
  CASE
    WHEN test_a IS NOT NULL THEN (
      SELECT MAX(test_start_date)
      FROM dsv1069.final_assignments
      WHERE dsv1069.final_assignments.item_id = dsv1069.final_assignments_qa.item_id
    )
  END AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT
  dsv1069.final_assignments_qa.item_id,
  test_b AS test_assignment,
  CASE
    WHEN test_b IS NOT NULL THEN 'item_test_2'
    ELSE 'Null'
  END AS test_number,
  CASE
    WHEN test_b IS NOT NULL THEN (
      SELECT MAX(test_start_date)
      FROM dsv1069.final_assignments
      WHERE dsv1069.final_assignments.item_id = dsv1069.final_assignments_qa.item_id
    )
  END AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT
  dsv1069.final_assignments_qa.item_id,
  test_c AS test_assignment,
  CASE
    WHEN test_c IS NOT NULL THEN 'item_test_3'
    ELSE 'Null'
  END AS test_number,
  CASE
    WHEN test_c IS NOT NULL THEN (
      SELECT MAX(test_start_date)
      FROM dsv1069.final_assignments
      WHERE dsv1069.final_assignments.item_id = dsv1069.final_assignments_qa.item_id
    )
  END AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT
  dsv1069.final_assignments_qa.item_id,
  test_d AS test_assignment,
  CASE
     WHEN test_d IS NOT NULL THEN 'item_test_4'
     ELSE 'Null'
  END AS test_number,
  CASE
     WHEN test_d IS NOT NULL THEN '2017-01-07'::date + (FLOOR(RANDOM() * 86400) * '1 second'::interval)
  END AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT
  dsv1069.final_assignments_qa.item_id,
  test_e AS test_assignment,
  CASE
     WHEN test_e IS NOT NULL THEN 'item_test_5'
     ELSE 'Null'
  END AS test_number,
  CASE
     WHEN test_e IS NOT NULL THEN '2018-01-07'::date + (FLOOR(RANDOM() * 86400) * '1 second'::interval)
  END AS test_start_date
FROM dsv1069.final_assignments_qa
UNION
SELECT
  dsv1069.final_assignments_qa.item_id,
  test_f AS test_assignment,
  CASE
     WHEN test_f IS NOT NULL THEN 'item_test_6'
     ELSE 'Null'
  END AS test_number,
  CASE
     WHEN test_f IS NOT NULL THEN '2019-01-07'::date + (FLOOR(RANDOM() * 86400) * '1 second'::interval)
  END AS test_start_date
FROM dsv1069.final_assignments_qa
ORDER BY test_number;


'''COMPUTE ORDER BINARY.
Use this table to
compute order_binary for the 30 day window after the test_start_date
for the test named item_test_2'''

SELECT test_assignment ,
       SUM(ORDER_BINARY) AS orders_completed_30d ,
       count(distinct item_id) AS items,
      SUM(orders)/COUNT(item_id) AS average_views_per_item
FROM
  (SELECT
    test_events.item_id,
    test_events.test_assignment,
    test_events.order_date,
    test_events.test_number,
    test_events.test_date,
    count(invoice_id) as orders,
    MAX(CASE WHEN (order_date > test_events.test_date
        AND DATE_PART('day', order_date-test_date) <= 30)
        THEN 1 ELSE 0 END) AS order_binary
  FROM
  (SELECT A.item_id AS item_id,
          test_assignment,
          test_number,
          test_start_date AS test_date,
          created_at AS order_date,
          invoice_id
   FROM dsv1069.final_assignments A
   LEFT JOIN dsv1069.orders B
     ON A.item_id = B.item_id
     WHERE test_number = 'item_test_2'
    ) AS test_events
    GROUP BY test_events.item_id,
          test_events.test_assignment,
          test_events.order_date,
          test_events.test_number,
          test_events.test_date
  ) AS ORDER_BINARY
GROUP BY test_assignment

'''COMPUTE VIEW ITEM METRICS.
-- Use this table to
-- compute view_binary for the 30 day window after the test_start_date
-- for the test named item_test_2'''

SELECT test_assignment,
       SUM(view_binary) AS views_binary_30,
       count(distinct item_id) AS items,
	   CAST(100*SUM(view_binary)/COUNT(item_id) AS FLOAT) AS viewed_percent,
      SUM(events)/COUNT(item_id) AS average_views_per_item
FROM (
SELECT test_events.item_id,
       test_events.test_assignment,
       test_events.test_number,
       test_events.test_date,
       count(event_id) as events,
       MAX(CASE
               WHEN (event_time > test_events.test_date
                     AND DATE_PART('day', event_time-test_date) <= 30) THEN 1
               ELSE 0
           END) AS view_binary
FROM
  (SELECT assignment.item_id AS item_id,
          test_assignment,
          test_number,
          test_start_date AS test_date,
          event_time,
          event_id
   FROM dsv1069.final_assignments assignment
   LEFT JOIN
       (SELECT event_time,
              event_id,
               CASE
                   WHEN parameter_name = 'item_id' then cast (parameter_value AS float)
                   ELSE null
               END AS item_id
      FROM dsv1069.events
      WHERE event_name = 'view_item' ) AS views
     ON assignment.item_id =views.item_id
     WHERE test_number = 'item_test_2'
     ) AS test_events
   GROUP BY test_events.item_id,
         test_events.test_assignment,
         test_events.test_number,
       test_events.test_date
         ) AS views_binary
GROUP BY test_assignment,
  test_date

'''COMPUTE LIFT AND P-VALUE.
--Use the https://thumbtack.github.io/abba/demo/abba.html to compute the lifts
in metrics and the p-values for the binary metrics ( 30 day order binary and 30
day view binary) using a interval 95% confidence.'''

'''ANSWER: View Binary
  We can say with 95% confidence that the lift value is 2% and the p_value is 0.2.
There is not a significant difference in the number of views within 30days of the assigned treatment date between the two treatments.

  Order binary
  There is no detectable change in this metric. The p-value is 0.86
  meaning that there is a no significant difference in the number of orders within 30days of the assigned treatment date between      the two treatments.'''
