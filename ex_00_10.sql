'''Counting Users: USERS TABLE
Log onto Mode Analytics and from the home page, create a new report by clicking on the green
plus sign button in the upper right-hand corner. Enter the starter code where provided for each
exercise. You may want to create a new tab for each exercise.
Please use the discussion forum for any questions and/or comments you might have. Once you
have tried the exercises, feel free to watch the solutions video. Good luck with your practice!
Note: When querying a table, remember to prepend dsv1069, which is the schema, or folder
that contains the course data.
Exercise 1: We’ll be using the users table to answer the question “How many new users are
added each day?“. Start by making sure you understand the columns in the table.
Starter Code:'''
SELECT *
FROM dsv1069.users
'''teacher uses the following code to go through the data'''
SELECT
  id,
  parent_user_id,
  merged_date
FROM dsv1069.users
ORDER BY parent_user_id ASC


'''Exercise 2: WIthout worrying about deleted user or merged users, count the number of users
added each day.
Starter Code: (none)'''
SELECT
  DATE(created_at) AS registration_date,
  COUNT(*) AS new_users_count
FROM dsv1069.users
GROUP BY registration_date
ORDER BY registration_date;

'''Exercise 3: Consider the following query. Is this the right way to count merged or deleted
users? If all of our users were deleted tomorrow what would the result look like?
Starter Code:'''
SELECT
  date(created_at) AS day,
  COUNT(*) AS new_users_added_users
FROM
  dsv1069.users
'''excluding deleted users below'''
WHERE
  deleted_at IS NULL
'''excluding merged users below'''
AND
  (id <> parent_user_id
OR
  parent_user_id IS NULL)
GROUP BY
  date(created_at)

'''ANSWER: The provided query is designed to count the number of users who are
neither merged nor deleted. It uses the created_at column to group the results
by the day users were created. The conditions in the WHERE clause filter out users
 where deleted_at is not null (i.e., they are not deleted) and where id is not
 equal to parent_user_id or parent_user_id is null (i.e., they are not merged).

If all users were deleted tomorrow, the query would return the count of users
created on each day, as long as those users were not merged. Users who were merged
 would not be included in the results, even if they were deleted.

In other words, the query provides a count of new, non-merged users created on
each day. If all users were deleted tomorrow, the query would not show any new
users in the results for the following days because it specifically filters out
 merged users.'''

'''Exercise 4: Count the number of users deleted each day. Then count the number of users
removed due to merging in a similar way.
Starter Code: (Use the result from #2 as a guide)'''
SELECT
  DATE(deleted_at) AS deleted_date,
  COUNT(*) AS new_exusers_count
FROM dsv1069.users
GROUP BY deleted_date
ORDER BY deleted_date;

'''Exercise 5: Use the pieces you’ve built as subtables and create a table that has a column for
the date, the number of users created, the number of users deleted and the number of users
merged that day.
Starter Code:
(none)'''
'''ANSWER: First I create a merged count column:'''
SELECT
  DATE(merged_at) AS merged_date,
  COUNT(*) AS merged_users
FROM dsv1069.users
GROUP BY merged_date
ORDER BY merged_date;

'''ANSWER: Then I will have thre different columns: new_users_count,
new_exusers_count and merged_users. And finally the table summing up all the columns:'''
SELECT
  COALESCE(r.registration_date, d.deleted_date, m.merged_date) AS date,
  COALESCE(new_users_count, 0) AS new_users_count,
  COALESCE(new_exusers_count, 0) AS new_exusers_count,
  COALESCE(merged_users, 0) AS merged_users,
  COALESCE(new_users_count, 0) - COALESCE(merged_users, 0) - COALESCE(new_exusers_count, 0) AS net_added_users
FROM
  (SELECT DATE(created_at) AS registration_date, COUNT(*) AS new_users_count
   FROM dsv1069.users
   GROUP BY registration_date) r
FULL OUTER JOIN
  (SELECT DATE(deleted_at) AS deleted_date, COUNT(*) AS new_exusers_count
   FROM dsv1069.users
   GROUP BY deleted_date) d
ON r.registration_date = d.deleted_date
FULL OUTER JOIN
  (SELECT DATE(merged_at) AS merged_date, COUNT(*) AS merged_users
   FROM dsv1069.users
   GROUP BY merged_date) m
ON COALESCE(r.registration_date, d.deleted_date) = m.merged_date
ORDER BY date;


'''ANSWER: In this query:

We use subqueries to calculate the counts of new users, deleted users, and merged
 users for each day.We use the FULL OUTER JOIN clause to combine the results of
 these subqueries, ensuring that all dates are included in the final result, even
  if there are no corresponding counts in one of the subqueries.
We use the COALESCE function to replace NULL values with zeros for days where
there are no new users, deleted users, or merged users.
The result is ordered by the date.
This query will provide a table with columns for the date, the number of new
users created, the number of users deleted, and the number of users merged for each day.'''


'''Exercise 6: Refine your query from #5 to have informative column names and so that null
columns return 0.
Starter Code: (none)'''
'''ANSWER: Already done on exercise 5.'''

'''Exercise 7: ANSWER: Already done on exercise 5.
What if there were days where no users were created, but some users were deleted or merged.
Does the previous query still work? No, it doesn’t. Use the dates_rollup as a backbone for this
query, so that we won’t miss any dates.
Starter Code:
SELECT * FROM dsv1069.dates_rollu'''

'''ANSWER: The previous query handles cases where there are days with no new users
created but some users were deleted or merged. It uses a FULL OUTER JOIN between
the subqueries for new users, deleted users, and merged users. This type of join
 ensures that all dates from each subquery are included in the final result, regardless
  of whether there are corresponding counts in the other subqueries.

If there are days with no new users created but some users were deleted or merged,
the result will still include those dates with zeros for the counts of new users.
This is because the COALESCE function is used to replace NULL values with zeros for
 the counts where there are no corresponding records.

So, the query will work correctly and provide a comprehensive summary of the number
 of new users, deleted users, and merged users for each day, including days
 where some counts are zero.

 To add a net_added_users column that shows the difference between new users,
 deleted users, and merged users, you can perform arithmetic operations in your
 query. Youll calculate net_added_users by subtracting merged_users and
 new_exusers_count from new_users_count.

In this modified query, the net_added_users column is calculated as
new_users_count - merged_users - new_exusers_count. The COALESCE function is
used to handle null values, setting them to 0 if they are null. This ensures
that you get a result for all dates, even if there are no records for certain
events on some days.
 '''
