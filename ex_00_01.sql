'''Exercise 2:
--Goal: Use the items table to count the number of items for sale in each category
Starter Code: (none)'''

SELECT COUNT(id) AS item_count, category
FROM dsv1069.items
GROUP BY category
ORDER BY item_count DESC
