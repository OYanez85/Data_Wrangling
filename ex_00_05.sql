'''Exercise 6:
--Goal: For each user figure out IF a user has ordered something, and when their first purchase
was. The query below doesn’t return info for any of the users who haven’t ordered anything.'''
'''The following statement returns how many users do i have?
SELECT COUNT(*) FROM dsv1069.users'''

SELECT
  users.id AS user_id,
  MIN(orders.paid_at) AS min_paid_at
FROM dsv1069.users
LEFT OUTER JOIN dsv1069.orders
ON orders.user_id = users.id
GROUP BY users.id;

'''
SELECT
  users.id AS user_id,
  MIN(orders.paid_at) AS min_paid_at,
  CASE
    WHEN MIN(orders.paid_at) IS NOT NULL THEN 'Ordered'
    ELSE 'Not Ordered'
  END AS Boolean_order
FROM dsv1069.users
LEFT JOIN dsv1069.orders
ON users.id = orders.user_id
GROUP BY users.id;'''
