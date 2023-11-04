'''Product Analysis'''
'''Log onto Mode Analytics and from the home page, create a new report by clicking on the green
plus sign button in the upper right-hand corner. Enter the starter code where provided for each
exercise. You may want to create a new tab for each exercise.
Please use the discussion forum for any questions and/or comments you might have. Once you
have tried the exercises, feel free to watch the solutions video. Good luck with your practice!
Note: When querying a table, remember to prepend dsv1069, which is the schema, or folder
that contains the course data.

Exercise 0: Count how many users we have
Starter Code:'''
--SELECT *
--FROM dsv1069.users
--LIMIT 100
SELECT COUNT(DISTINCT id) AS total_users
FROM dsv1069.users
LIMIT 100
--SOLUTION: 117178
'''Exercise 1: Find out how many users have ever ordered
Starter Code:'''
SELECT COUNT(DISTINCT user_id) AS users_with_orders
FROM dsv1069.orders
--SOLUTION: 17463
'''Exercise 2:
--Goal find how many users have reordered the same item
Starter Code:'''
SELECT user_id, item_id, COUNT(DISTINCT line_item_id) AS times_user_ordered
FROM dsv1069.orders
GROUP BY user_id, item_id

'''im writing the previous query into a subquery'''


'''Exercise 3:
--Do users even order more than once?
Starter Code:'''
SELECT
COUNT(DISTINCT user_id) AS users_who_reordered
--*
FROM
(
SELECT
  user_id,
  item_id,
  COUNT(DISTINCT line_item_id) AS times_user_ordered
FROM dsv1069.orders
GROUP BY
  user_id,
  item_id
) user_level_orders
WHERE  times_user_ordered > 1
'''SOLUTION: So, 211 users have ever reordered an item. We have over a 100,000 users
almost 20,000 users who have ordered something ever. This number is pretty small so we are going to recap'''

SELECT
user_id,
COUN(DISTINCT invoice_id) AS order_count
FROM dsv1069.orders
GROUP BY
user_id
'''So, lots of people have just ordered once. Same trick as before, count how many people have ordered multiple times.'''
SELECT
COUNT(DISTINCT user_id)
FROM(
SELECT
user_id,
COUN(DISTINCT invoice_id) AS order_count
FROM dsv1069.orders
GROUP BY
user_id
) user_level
WHERE order_count >1

'''Exercise 4:
--Orders per item
Starter Code:'''
SELECT COUNT(DISTINCT user_id) AS users_with_orders,
item_name
FROM dsv1069.orders
GROUP BY item_id,
item_name
'''another way of doing it by the teacher:'''
SELECT
  item_id,
  COUNT(line_item_id) AS times_ordered
FROM dsv1069.orders
GROUP BY
  item_id

'''Exercise 5:
--Orders per category
Starter Code:'''
SELECT
  item_category,
  COUNT(line_item_id) AS times_ordered
FROM dsv1069.orders
GROUP BY item_category

'''Exercise 6:
--Goal: Do user order multiple things from the same category?
Starter Code:'''
SELECT
user_id,
item_category,
COUNT(line_item_id) AS times_category_ordered
FROM dsv1069.orders
GROUP BY
  user_id,
  item_category

'''then'''
SELECT
user_id,
item_category,
COUNT(DISTINCT line_item_id) AS times_category_ordered
FROM dsv1069.orders
GROUP BY
  user_id,
  item_category

'and then'''
SELECT
AVG(times_category_ordered) AS avg_times_category_ordered
FROM
(
SELECT
user_id,
item_category,
COUNT(DISTINCT line_item_id) AS times_category_ordered
FROM dsv1069.orders
GROUP BY
  user_id,
  item_category
) user_level

'''lets see if it is different by category'''
SELECT
item_category,
AVG(times_category_ordered) AS avg_times_category_ordered
FROM
(
SELECT
user_id,
item_category,
COUNT(DISTINCT line_item_id) AS times_category_ordered
FROM dsv1069.orders
GROUP BY
  user_id,
  item_category
) user_level
GROUP BY item_category

'''So, whenever people order instrument, they tend to order multiple items from
that category. Thats a pretty good insight.That could tell you that while people
 are in the middle of ordering instruments, you want to recommend other instruments
 to them and maybe theyre not going to order it a second time on a different date
  but they might add it to their order and when were thinking about how many users
   have ordered at all, remember we looked at that users orders. Thats a much
   bigger audience than the users with re-orders. We could make a much more meaningful
  product change if we targeted just everyone coming in who had an order.'''

'''Exercise 7:
--Goal: Find the average time between orders
--Decide if this analysis is necessary
Starter Code'''

SELECT
  first_orders.user_id,
  DATE(first_orders.paid_at) AS first_order_date,
  DATE(second_orders.paid_at) AS second_order_date,
  DATE(second_orders.paid_at) -date(first_orders.paid_at) AS date_diff
--THIS WILL VARY DEPENDING ON YOUR FLAVOUR OF SQL
FROM
(
SELECT
  user_id,
  invoice_id,
  paid_at,
  DENSE_RANK() OVER (PARTITION BY user_id ORDER BY paid_at ASC)
    AS order_num
FROM
  dsv1069.orders
) first_orders
JOIN
(
  SELECT
    user_id,
    invoice_id,
    paid_at,
    DENSE_RANK() OVER (PARTITION BY user_id ORDER BY paid_at ASC)
      AS order_num
  FROM
    dsv1069.orders
  ) second_orders
ON
  first_orders.user_id = second_orders.user_id
WHERE
  first_orders.order_num = 1
AND
  second_orders.order_num = 2;

'''To sum up our good solution is we take an item that you have already put in
your cart and we recommend other items from that same category because thats a
behavior thats very likely most people order in multiple items from the same
category when they order and thats a pretty big chunk of people. Users with orders
 is pretty big. Its as big of a targetable audiences youre going to have for
 something related to ordering.'''
