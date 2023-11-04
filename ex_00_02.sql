'''Exercise 3:
--Goal: Select all of the columns from the result when you JOIN the users table to the orders
table
Starter Code: (none)'''

'''The following statement is correct as well:
SELECT *
FROM dsv1069.users
JOIN dsv1069.orders ON dsv1069.users.id = dsv1069.orders.user_id'''

SELECT *
FROM dsv1069.orders
JOIN dsv1069.users ON dsv1069.orders.user_id = dsv1069.users.id
