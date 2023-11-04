'''ANALYSING RESULTS'''
'''Table from previous exercise'''

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


'''Exercise 1: Use the order_binary metric from the previous exercise, count the number of users
per treatment group for test_id = 7, and count the number of users with orders (for test_id 7)'''

SELECT
  *
FROM
(

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
  test_events.user_id,
  test_events.test_id,
  test_events.test_assignment
) user_level
WHERE test_id = 7

'''Actually, lets leave this Select Star there, and well go to the bottom. Well
add in a Where clause just to look at test_id number 7. Well just check and make
 sure that that runs. Okay. Spacing. Cool. Running it. Great. Now, weve got
 results just for test_id 7. Lets come to the top and figure out what columns
 we want. So, we want to have the test_assignment, but we dont need to put the
 test_id in there because we already know what the test_id is going to be. Then,
  we need to count the user IDs. Thats the users who are assigned in each test.
  Then, we also want to sum the order binary.'''

  SELECT
    test_assignment,
    COUNT(user_id)    AS users,
    SUM(order_binary) AS users_with_orders
  FROM
  (

  SELECT
    test_events.test_id,
    test_events.test_assignment,
    test_events.user_id,
    MAX(CASE WHEN orders.created_at > test_events.event_time THEN 1 ELSE 0 END) AS order_binary
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
    test_events.user_id,
    test_events.test_id,
    test_events.test_assignment
  ) user_level
  WHERE test_id = 7
  GROUP BY
    test_assignment

    '''All right, there we go. You can see how many users had orders in each group.
    So were going to take our results from mode, and were going to enter them into
    this web tool, this A/B testing web tool. Im going to rename our labels. So Control
     and Treatment. Here, the number of trials is the number of users, and the number
      of successes is the users with order. So Im going to cut those from mode. So here,
       users and weve got test_assignment one. That means theyre in treatment so
       Im going to put them there. Then, do the same thing with Control. Put that
       in the Number of trials. The number of users is the number of trials.
       Then the Successes is the users with orders. So that was in, yeah, its in
       treatment. Now, we want to pull in the Control value. Okay. Im running this
        at 95 percent confidence interval. Okay, we can see that the p-value is 0.059,
         and there is an observed lift of five percent. We believe that the actual
         lift is somewhere between negative 0.2 percent and 10 percent. Okay. So weve
          analyzed our first test. Lets think about a little bit about what could go
           wrong with the analysis, that maybe we didnt even see here. So for one,
           there could be errors or biased introduced in the assignment process.
           You might see this if the number of users treated is really different
           between the Treatment and Control. It could also be that the metrics
            were calculating are not relevant to the hypothesis being tested. If
            this was a test that was about account creation, we shouldnt really
            expect there to be a lot of differences in order binary, or maybe we
            would see some. Okay. The other thing is the metrics could be not
            calculated properly. That happens sometimes. It certainly could be that
             the statistics are not calculated properly. So the length that Ive given
              you to the Abba calculator, that will work for binary metrics. But when
              were talking about an aggregation of mean metrics, were going to also
              need to include some stuff thats a little bit different. Were going to
               need more statistics. Were going to need the average, which we did
               before just by adding up the sum, and we could have gotten it by dividing
               by the number of users. But here we also need the standard deviation.
               Thats going to help us figure out our p-values. Were not going to go
               really deep into the statistics in this class. So were not actually
               going to analyze any mean metrics in this exercise or the final project,
                because thats not the focus of the class. So one of the extra things
                 that can go wrong with mean metrics is, computing the standard
                 deviation can be a little bit tricky, especially if youre trying to
                  segment results. If you are trying to look just at mobile users and
                   you were using the standard deviation for everybody, you might be
                    computing it incorrectly. So Ill add that down there to the list
                     of things that could go wrong with the analysis of the test
                     specifically for means metrics.'''

'''Analyzing Results (Solution)'''

'''1. PROPORTION METRICS EXERCISE: Use the order_binary metric from the previous exercise,
For the proportion meric order binary compute the following:
 1) The count of users per treatment group for test_id = 7
 2) The count of users with orders per treatment group:'''

SELECT
  test_assignment,
  COUNT(user_id)    AS users,
  SUM(order_binary) AS orders_completed
FROM
(

SELECT
  assignments.user_id,
  assignments.test_id,
  assignments.test_assignment,
  MAX(CASE WHEN orders.created_at > assignments.event_time THEN 1 ELSE 0 END) AS order_binary
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
          THEN CAST(parameter_value AS INT)
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
    ORDER BY
      event_id
  ) assignments
LEFT OUTER JOIN
  dsv1069.orders
ON
  assignments.user_id = orders.user_id
GROUP BY
  assignments.user_id,
  assignments.test_id,
  assignments.test_assignment
) order_binary
WHERE test_id = 7
GROUP BY
  test_assignment

'''NEXT STEP IS TO COMPUTE IT ON A/B TESTING and to check if it is statiscally relevant'''

'''2. NEW PROPORTION METRIC EXERCISE
Create an item view binary metric.
For the proportion metric item_view binary compute the following:
1) The count of users per treatment group
2) The count of users with item-views per treatment group :'''

SELECT
  test_assignment,
  COUNT(user_id)    AS users,
  SUM(views_binary) AS views_binary
FROM
(
  SELECT
    assignments.user_id,
    assignments.test_id,
    assignments.test_assignment,
    MAX(CASE WHEN views.event_time > assignments.event_time THEN 1 ELSE 0 END) AS views_binary
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
          THEN CAST(parameter_value AS INT)
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
    ORDER BY
      event_id
  ) assignments
LEFT OUTER JOIN
  (
    SELECT
      *
    FROM
      dsv1069.events
    WHERE
      event_name = 'view_item'
  ) views
ON
  assignments.user_id = views.user_id
GROUP BY
  assignments.user_id,
  assignments.test_id,
  assignments.test_assignment
) order_binary
WHERE test_id = 7
GROUP BY
  test_assignment

'''EXERCISE 3. TIME CAPPED BINARY METRICS
Use the previous part of this assignment with an item view binary metric.
Alter the metric to compute the users who viewed an item WITHIN 30 days of their
treatment event.'''

SELECT
  test_assignment,
  COUNT(user_id)        AS users,
  SUM(views_binary)     AS views_binary,
  SUM(views_binary_30d) AS views_binary_30d
FROM
  (
  SELECT
    assignments.user_id,
    assignments.test_id,
    assignments.test_assignment,
    MAX(CASE WHEN views.event_time > assignments.event_time THEN 1 ELSE 0 END) AS views_binary,
    MAX(CASE WHEN (views.event_time > assignments.event_time AND
                   DATE_PART('day' , views.event_time - assignments.event_time ) <= 30)
             THEN 1 ELSE 0 END) AS views_binary_30d
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
          THEN CAST(parameter_value AS INT)
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
    ORDER BY
      event_id
  ) assignments
LEFT OUTER JOIN
  (
    SELECT
      *
    FROM
      dsv1069.events
    WHERE
      event_name = 'view_item'
  ) views
ON
  assignments.user_id = views.user_id
GROUP BY
  assignments.user_id,
  assignments.test_id,
  assignments.test_assignment
) order_binary
WHERE test_id = 7
GROUP BY
  test_assignment

'''EXERCISE 4. MEAN VALUE METRICS
Use the table from the previous exercise.
For the mean value metrics invoices, line items, and total revenue compute the following:
1) The count of users per treatment group
2) The average value of the metric per treatemnt group
3) The standard deviation of the metric per treatment group'''

SELECT
  test_id,
  test_assignment,
  COUNT(user_id)   AS users,
  AVG(invoices)    AS avg_invoices,
  STDDEV(invoices) AS stddev_invoices
FROM
  (
  SELECT
    assignments.user_id,
    assignments.test_id,
    assignments.test_assignment,
    COUNT(DISTINCT CASE WHEN orders.created_at > assignments.event_time THEN orders.invoice_id ELSE NULL END)
      AS invoices,
    COUNT(DISTINCT CASE WHEN orders.created_at > assignments.event_time THEN orders.line_item_id ELSE NULL END)
      AS line_items,
    COALESCE(SUM(CASE WHEN orders.created_at > assignments.event_time THEN orders.price ELSE 0 END), 0)
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
              THEN CAST(parameter_value AS INT)
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
  ORDER BY
    event_id
   ) assignments
LEFT OUTER JOIN
  dsv1069.orders
ON
  assignments.user_id = orders.user_id
GROUP BY
  assignments.user_id,
  assignments.test_id,
  assignments.test_assignment
) mean_metrics
GROUP BY
  test_id,
  test_assignment
ORDER BY
  test_id;

'''So, here we can see the way is where the invoice averages changes. We can look
 at it in the context of this standard deviation. This is something you would do
  to set up evaluating an AB test based on some mean metrics, and you can just
  swap in if you wanted to look at line items if you wanted to look at total revenue.
   You could swap that in here, here, et cetera and just get the same idea.'''

   SELECT
     test_id,
     test_assignment,
     COUNT(user_id)   AS users,
     AVG(total_revenue)    AS total_revenue,
     STDDEV(total_revenue) AS stddev_total_revenue
   FROM
     (
     SELECT
       assignments.user_id,
       assignments.test_id,
       assignments.test_assignment,
       COUNT(DISTINCT CASE WHEN orders.created_at > assignments.event_time THEN orders.invoice_id ELSE NULL END)
         AS invoices,
       COUNT(DISTINCT CASE WHEN orders.created_at > assignments.event_time THEN orders.line_item_id ELSE NULL END)
         AS line_items,
       COALESCE(SUM(CASE WHEN orders.created_at > assignments.event_time THEN orders.price ELSE 0 END), 0)
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
                 THEN CAST(parameter_value AS INT)
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
     ORDER BY
       event_id
      ) assignments
   LEFT OUTER JOIN
     dsv1069.orders
   ON
     assignments.user_id = orders.user_id
   GROUP BY
     assignments.user_id,
     assignments.test_id,
     assignments.test_assignment
   ) mean_metrics
   GROUP BY
     test_id,
     test_assignment
   ORDER BY
     test_id;

--  '''Exercise 2: Create a new tem view binary metric. Count the number of users per treatment
--  group, and count the number of users with views (for test_id 7)'''

--  '''Exercise 3: Alter the result from EX 2, to compute the users who viewed an item WITHIN 30
--  days of their treatment event'''

--'''Exercise 4:
--Create the metric invoices (this is a mean metric, not a binary metric) and for test_id = 7
----The count of users per treatment group
----The average value of the metric per treatment group
----The standard deviation of the metric per treatment group'''
