'''Identifying Unreliable Data + Nulls
Log onto Mode Analytics and from the home page, create a new report by clicking on the green
plus sign button in the upper right-hand corner. Enter the starter code where provided for each
exercise. You may want to create a new tab for each exercise.
Please use the discussion forum for any questions and/or comments you might have. Once you
have tried the exercises, feel free to watch the solutions video. Good luck with your practice!
Note: When querying a table, remember to prepend dsv1069, which is the schema, or folder
that contains the course data.
Exercise 1: Using any methods you like determine if you can you trust this events table.
SECRET: There are some entire days missing

Starter Code:'''
SELECT *
FROM dsv.events_201701

'''ANSWER: relation "dsv.events_201701" does not exist'''
'''I am going to check how many rows there are:
SELECT
  date(event_time) AS date,
  COUNT(*) AS rows
FROM
  dsv1069.events_201701
GROUP BY
  date(event_time)

ANSWER: It returns just 31 rows, that means there is some data missin.
I should have known that just because of the name".'''

'''Exercise 2:
Using any methods you like, determine if you can you trust this events table. (HINT: When did
we start recording events on mobile)
SECRET: In this case, mobile logging has not been implemented until recently.
Starter Code:'''

'''ANSWER:'''
SELECT
  date(event_time) AS date,
  event_name,
  COUNT(*)
FROM
  dsv1069.events_ex2
GROUP BY
  date(event_time),
  event_name


'''ANSWER: I can create a line chart with date, count and event_name just to confirm
 there is no missing data. Now I can try another categorical variable as platform:'''

 SELECT
   date(event_time) AS date,
   platform,
   COUNT(*)
 FROM
   dsv1069.events_ex2
 GROUP BY
   date(event_time),
   platform;

'''ANSWER: before 2016 there was no data for neither Adnorid nor IOS recorded. So
if this is the best data that we have, now we know something is wrong'''

'''Exercise 3: Imagine that you need to count item views by day. You found this table
item_views_by_category_temp - should you use it to answer your questiuon?
Starter Code'''
SELECT *
FROM dsv1069.item_views_by_category_temp

'''ANSWER: I can not group by event time because there is no date column
I can check how many events we have by:

SELECT SUM(view_events) AS event_count
FROM dsv1069.item_views_by_category_temp

I can run as well the following statement:
SELECT
  COUNT(DISTINCT event_id) AS event_count
FROM
  dsv1069.events
WHERE
  event_name = 'view_item'

ANSWER: that returns 262786 This event count is way bigger than item views by
category 10. We dont know when this table was created, but it really wasnt meant
 to be used because of the name. So, I dont think its a good idea to use this table.
  I think it might be a good idea to look at the query that generated it somehow
  and maybe use that as a base if youre trying to do an analysis where you need
  to account by and views by category, because maybe someones already done the
  work for you and its okay to build up over peoples groups.  '''

'''Exercise 4: Using any methods you like, decide if this table is ready to be used as a source of
truth.
SECRET: For web events, the user_id is null

Starter Code'''

SELECT
  date(event_time) AS date,
  COUNT (*) AS row_count,
  COUNT(event_id) AS event_count,
  COUNT(user_id) AS user_count
FROM  dsv1069.events_ex2
GROUP BY
  date(event_time);

  --SELECT *
-- FROM dsv1069.events_201701
--WHERE event_time < '2014-01-01'

'''ANSWER: even though for the teacher the web events are null, she was working with a databaase
which was not available to me.. In my database there was no issues with the data
and time dates. FOr the record, always to create a chart to visualize if there
are any null values.'''

'''Exercise 5: Is this the right way to join orders to users? Is this the right way this join.
Starter Code'''

'''ANSWER: When I run
SELECT *
FROM dsv1069.orders

when I count how many rows there are:
SELECT COUNT(*)
FROM dsv1069.orders
 I get 47402

 when I run
 SELECT COUNT(*)
FROM dsv1069.orders
JOIN dsv1069.users
ON orders.user_id = users.parent_user_id

I just get 2604, a lot less than that.

If I join by ON orders.user_id = users.id, the i get 47402.So there if I do that,
 then I get the full number of orders, but because the current user ID was null
 in a lot of cases.

SELECT COUNT(*)
FROM dsv1069.orders
JOIN dsv1069.users
ON orders.user_id = users.id

So what if I still really want to be joining on parent user ID. But I also want
to include the cases where a user doesnt have a parent user ID. So anyone who
hasnt been merged doesnt have a parent user ID in there, so I can use that
COALESCE statement.I can say, and if its available, use the parent user ID. If
its not available, use users.id. I can put that in my join key.

SELECT COUNT(*)
FROM dsv1069.orders
JOIN dsv1069.users
ON orders.user_id = COALESCE(users.parent_user_id, users.id)

I get something that makes a lot more sense. I might be, so thats how I want to
think about that join. There were some nulls in there in the users table, and
now its causing some problems. Depend at what like what you do. After this,
depends a little bit on what you are using this query for, but be really careful
 about joining on a column that might be null. That was it, thats whats going wrong.




SELECT *
FROM dsv1069.orders
JOIN dsv1069.users
ON orders.user_id = users.parent_user_id

'''ANSWER: For example, if you want to retrieve all rows from the "orders" table
 and only matching rows from the "users" table, you can use a LEFT JOIN.
 EXAMPLE:

 SELECT *
FROM dsv1069.orders
LEFT JOIN dsv1069.users
ON orders.user_id = users.parent_user_id;'''
