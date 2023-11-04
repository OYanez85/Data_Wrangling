'''CREATE A TEST METRIC'''
SELECT
  event_id,
  event_time,
  user_id,
  platform,
MAX(CASE WHEN parameter_name = 'test_id'
      THEN CAST(parameter_value AS INT)
      ELSE NULL
  END) AS test_id,
MAX(CASE WHEN parameter_name = 'test_assignment'
      THEN Parameter_value
      ELSE NULL
  END) AS test_assignment
FROM
  dsv1069.events
WHERE
    event_name = 'test_assignment'
GROUP BY
  event_id,
  event_time,
  user_id,
  platform
ORDER BY
  event_id

'''Exercise 1:
--Using the table from Exercise 4.3 and compute a metric that measures
--Whether a user created an order after their test assignment
--Requirements: Even if a user had zero orders, we should have a row that counts
-- their number of orders as zero
--If the user is not in the experiment they should not be included'''
SELECT
  test_events.test_id,
  test_events.test_assignment,
  test_events.user_id,
  (CASE WHEN orders.created_at > test_events.event_time THEN invoice_id ELSE NULL END) AS orders_after_assignment
FROM
  (
    SELECT
      event_id,
      event_time,
      user_id,
      MAX(CASE WHEN parameter_name = 'test_id'
          THEN CAST(parameter_value AS INT)
          ELSE NULL
      END) AS test_id,
      MAX(CASE WHEN parameter_name = 'test_assignment'
          THEN parameter_value
          ELSE NULL
      END) AS test_assignment
    FROM
      dsv1069.events
    WHERE
      event_name = 'test_assignment'
    GROUP BY
      event_id,
      event_time,
      user_id
  ) test_events
LEFT JOIN
  dsv1069.orders
ON
  orders.user_id = test_events.user_id;

------------------------------------------
'''So here we have a bunch of users. Some of them have no orders after assignment
 and then we can see this one user, and because theres three line items in the
 orders table, were getting three copies of this orders after assignment. So if
 we wanted to count how many orders there were, we would probably want to do a
 count distinct on the invoice id. But right now here actually we just want to
 figure out if there was an order. So here, Im just going to say, Im going to
 change this to be a max statement of the case when order created_at is after
 event time, and then instead of invoice, Im just going to say one, and otherwise
 Im going to say zero. Then, Im going put it in, so all the parentheses I need,
 one of them binary and in order to do this max statement, I need to put all of
  this stuff in the Group By down below.'''

SELECT
  test_events.test_id,
  test_events.test_assignment,
  test_events.user_id,
  MAX(CASE WHEN orders.created_at > test_events.event_time THEN 1 ELSE 0 END) AS orders_after_assignment_binary
FROM
  (
    SELECT
      event_id,
      event_time,
      user_id,
      MAX(CASE WHEN parameter_name = 'test_id'
          THEN CAST(parameter_value AS INT)
          ELSE NULL
      END) AS test_id,
      MAX(CASE WHEN parameter_name = 'test_assignment'
          THEN parameter_value
          ELSE NULL
      END) AS test_assignment
    FROM
      dsv1069.events
    WHERE
      event_name = 'test_assignment'
    GROUP BY
      event_id,
      event_time,
      user_id
  ) test_events
LEFT JOIN
  dsv1069.orders
ON
  orders.user_id = test_events.user_id
GROUP BY
  test_events.test_id,
  test_events.test_assignment,
  test_events.user_id

'''So here, we can see now we have this column, where sometimes its a one,
sometimes its a zero. But if Im looking at it based on user id, Im not going to
find people showing up here multiple times for the same test'''

-----------------------------------------
'''SECOND PART'''
'''Here, were doing something similar except instead of just the binary, were
going to compute the total number of invoices, the total number of line items,
and the total revenue from these orders.'''

SELECT
  test_events.test_id,
  test_events.test_assignment,
  test_events.user_id,
  COUNT(DISTINCT(CASE WHEN orders.created_at > test_events.event_time THEN invoice_id ELSE NULL END)) AS orders_after_assignment
FROM
  (
    SELECT
      event_id,
      event_time,
      user_id,
      MAX(CASE WHEN parameter_name = 'test_id'
          THEN CAST(parameter_value AS INT)
          ELSE NULL
      END) AS test_id,
      MAX(CASE WHEN parameter_name = 'test_assignment'
          THEN parameter_value
          ELSE NULL
      END) AS test_assignment
    FROM
      dsv1069.events
    WHERE
      event_name = 'test_assignment'
    GROUP BY
      event_id,
      event_time,
      user_id
  ) test_events
LEFT JOIN
  dsv1069.orders
ON
  orders.user_id = test_events.user_id
GROUP BY
  test_events.test_id,
  test_events.test_assignment,
  test_events.user_id

'''So that gets me. See it? It looks fairly similar. But okay, here, I think we
found someone in here with two orders. So here, this user has two orders after
their test assignment. So here, it differs from the order binary. We can change
this to also be line items. So if we wanted some instead count how many items
they purchased, we could do that.'''

SELECT
  test_events.test_id,
  test_events.test_assignment,
  test_events.user_id,
  COUNT(DISTINCT(CASE WHEN orders.created_at > test_events.event_time THEN invoice_id ELSE NULL END)) AS orders_after_assignment,
  COUNT(DISTINCT(CASE WHEN orders.created_at > test_events.event_time THEN line_item_id ELSE NULL END)) AS items_after_assignment
FROM
  (
    SELECT
      event_id,
      event_time,
      user_id,
      MAX(CASE WHEN parameter_name = 'test_id'
          THEN CAST(parameter_value AS INT)
          ELSE NULL
      END) AS test_id,
      MAX(CASE WHEN parameter_name = 'test_assignment'
          THEN parameter_value
          ELSE NULL
      END) AS test_assignment
    FROM
      dsv1069.events
    WHERE
      event_name = 'test_assignment'
    GROUP BY
      event_id,
      event_time,
      user_id
  ) test_events
LEFT JOIN
  dsv1069.orders
ON
  orders.user_id = test_events.user_id
GROUP BY
  test_events.test_id,
  test_events.test_assignment,
  test_events.user_id

'''Then if I want to count total revenue, I instead want to sum something. So its
 going to be little distinct,but its going to be the price.'''

 SELECT
   test_events.test_id,
   test_events.test_assignment,
   test_events.user_id,
   COUNT(DISTINCT(CASE WHEN orders.created_at > test_events.event_time THEN invoice_id ELSE NULL END))
     AS orders_after_assignment,
   COUNT(DISTINCT(CASE WHEN orders.created_at > test_events.event_time THEN line_item_id ELSE NULL END))
     AS items_after_assignment,
   SUM((CASE WHEN orders.created_at > test_events.event_time THEN price ELSE 0 END))
     AS total_revenue
 FROM
   (
     SELECT
       event_id,
       event_time,
       user_id,
       MAX(CASE WHEN parameter_name = 'test_id'
           THEN CAST(parameter_value AS INT)
           ELSE NULL
       END) AS test_id,
       MAX(CASE WHEN parameter_name = 'test_assignment'
           THEN parameter_value
           ELSE NULL
       END) AS test_assignment
     FROM
       dsv1069.events
     WHERE
       event_name = 'test_assignment'
     GROUP BY
       event_id,
       event_time,
       user_id
   ) test_events
 LEFT JOIN
   dsv1069.orders
 ON
   orders.user_id = test_events.user_id
 GROUP BY
   test_events.test_id,
   test_events.test_assignment,
   test_events.user_id

'''So here we go. We can see again this user ordered, made one order with two
items. The total revenue for those items was 89. So this is a way that you can
 generate some of those metrics if youre going to measure the results.'''
