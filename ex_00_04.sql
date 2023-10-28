'''Exercise 5:
--Goal:Compute the number of items in the items table which have been ordered. The query
below runs, but it isn’t right. Determine what is wrong and correct the error or start from scratch.
Starter Code:
SELECT
  COUNT(item_id) AS item_count
FROM dsv1069.orders
INNER JOIN dsv1069.items
ON orders.item_id = items.id
--Error: This query runs but the number isn’t right'''
'''Just needs to add DISTINCT otherwise counts the duplicates'''
SELECT
  COUNT(DISTINCT item_id) AS item_count
FROM dsv1069.orders

'''the following statement it is not necessary
INNER JOIN dsv1069.items
ON orders.item_id = items.id'''

'''The following is another way of doing it:
SELECT
  COUNT(DISTINCT dsv1069.items.id) AS item_count
FROM dsv1069.items
INNER JOIN dsv1069.orders
ON dsv1069.items.id =  dsv1069.orders.item_id'''

'''To compute the number of items in the "items" table that have been ordered,
you need to properly associate the "items" table with the "orders" table using
the relevant foreign keys. In your starter code, it appears youre trying to join
 the tables using an incorrect condition (orders.item_id = items.id), which is
 likely causing the inaccurate result. Assuming there is a foreign key relationship
 between the 'items' and 'orders' tables, you should match the correct foreign keys.
 Heres a corrected query:
 In this corrected query:We use COUNT(DISTINCT items.id) to count the unique "item_id"
 values in the "items" table that have been ordered. This ensures that each item is only
 counted once, even if it has been ordered multiple times.
We use the INNER JOIN clause to properly join the "items" table with the "orders" table,
 matching the "id" column from the "items" table with the "item_id" column from the
 "orders" table.This query should give you an accurate count of items that have been ordered.'''
