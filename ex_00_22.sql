'''Promo Email'''
'''Log onto Mode Analytics and from the home page, create a new report by clicking on the green
plus sign button in the upper right-hand corner. Enter the starter code where provided for each
exercise. You may want to create a new tab for each exercise.
Please use the discussion forum for any questions and/or comments you might have. Once you
have tried the exercises, feel free to watch the solutions video. Good luck with your practice!
Note: When querying a table, remember to prepend dsv1069, which is the schema, or folder
that contains the course data.
Exercise 1:
Create the right subtable for recently viewed events using the view_item_events table.
Starter Code:'''

--SELECT *
--FROM dsv1069.view_item_events

SELECT
  event_id,
  item_id,
  event_time,
  ROW_NUMBER(  ) OVER (PARTITION BY user_id ORDER BY event_time DESC)
    AS row_number,
  RANK(  ) OVER (PARTITION BY user_id ORDER BY event_time DESC)
    AS rank,
  DENSE_RANK(  ) OVER (PARTITION BY user_id ORDER BY event_time DESC)
    AS dense_rank
FROM
  dsv1069.view_item_events

'''Exercise 2: Check your joins. Join your tables together recent_views, users, items
Starter Code: The result from Ex'''
SELECT
  event_id,
  item_id,
  event_time,
  ROW_NUMBER(  ) OVER (PARTITION BY user_id ORDER BY event_time DESC)
    AS view_number
FROM
  dsv1069.view_item_events

  '''Exercise 2: Check your joins. Join your tables together recent_views, users, items
  Starter Code: The result from Ex'''

  SELECT *
  FROM
    (
      SELECT
        user_id,
        item_id,
        event_time,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
          AS view_number
        FROM
          dsv1069.view_item_events
        ) recent_views
  JOIN
  dsv1069.users
  ON
  users.id = recent_views.user_id
  JOIN
  dsv1069.items
  ON
  items.id = recent_views.item_id

  '''Exercise 3. Clean up this query outline and pull only the columns you need'''

  SELECT
    users.id            AS user_id,
    users.email_address,
    items.id            AS item_id,
    items.name          AS item_name,
    items.category      AS item_category
  FROM
    (
      SELECT
        user_id,
        item_id,
        event_time,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
          AS view_number
        FROM
          dsv1069.view_item_events
        ) recent_views
  JOIN
  dsv1069.users
  ON
  users.id = recent_views.user_id
  JOIN
  dsv1069.items
  ON
  items.id = recent_views.item_id

'''EXTRA FILTERS'''
  '''So one thing that Im looking at is what if a user has been deleted or merged?'''

  SELECT
    COALESCE(users.parent_user_id, users.id)   AS user_id,
    users.email_address,
    items.id                                   AS item_id,
    items.name                                 AS item_name,
    items.category                             AS item_category
  FROM
    (
      SELECT
        user_id,
        item_id,
        event_time,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
          AS view_number
        FROM
          dsv1069.view_item_events
        ) recent_views
  JOIN
  dsv1069.users
  ON
  users.id = recent_views.user_id
  JOIN
  dsv1069.items
  ON
  items.id = recent_views.item_id

  '''Another thing that I could take care of is I could make sure that the users
   arent deleted, so I could say where and deleted_at, the users.deleted_at is
   not null.'''
   SELECT
     COALESCE(users.parent_user_id, users.id)   AS user_id,
     users.email_address,
     items.id                                   AS item_id,
     items.name                                 AS item_name,
     items.category                             AS item_category
   FROM
     (
       SELECT
         user_id,
         item_id,
         event_time,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
           AS view_number
         FROM
           dsv1069.view_item_events
         ) recent_views
   JOIN
    dsv1069.users
   ON
    users.id = recent_views.user_id
   JOIN
    dsv1069.items
   ON
    items.id = recent_views.item_id
   WHERE
    view_number = 1
   AND
    users.deleted_at IS NOT NULL

''' Another thing that I could take care of is I could make sure that the users
 arent deleted, so I could say where and deleted_at, the users.deleted_at is not
null.So I dont I want to send this to any deleted users. So, thats how were
going to do it. Another thing that I might want to add in is I dont necessarily
want to send someone is email notification if they viewed the item 10 years ago.'''
SELECT
  COALESCE(users.parent_user_id, users.id)   AS user_id,
  users.email_address,
  items.id                                   AS item_id,
  items.name                                 AS item_name,
  items.category                             AS item_category
FROM
  (
    SELECT
      user_id,
      item_id,
      event_time,
      ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
        AS view_number
      FROM
        dsv1069.view_item_events
      WHERE
        event_time >= '2017-01-01'
      ) recent_views
JOIN
 dsv1069.users
ON
 users.id = recent_views.user_id
JOIN
 dsv1069.items
ON
 items.id = recent_views.item_id
WHERE
 view_number = 1
AND
 users.deleted_at IS NOT NULL

'''Lets move on to one more thing that I might add which is I dont really want
to send someone an email notification to buy a thing that they looked at if they
 already bought it. So, Im going to do something else which is a little tricky
 here. Im going to left to join in the orders table, DSV1069.orders.'''
 SELECT
   COALESCE(users.parent_user_id, users.id)   AS user_id,
   users.email_address,
   items.id                                   AS item_id,
   items.name                                 AS item_name,
   items.category                             AS item_category
 FROM
   (
     SELECT
       user_id,
       item_id,
       event_time,
       ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
         AS view_number
       FROM
         dsv1069.view_item_events
       WHERE
         event_time >= '2017-01-01'
       ) recent_views
 JOIN
  dsv1069.users
 ON
  users.id = recent_views.user_id
 JOIN
  dsv1069.items
 ON
  items.id = recent_views.item_id
LEFT OUTER JOIN
  dsv1069.orders
ON
  orders.item_id = recent_views.item_id
AND
  orders.user_id = recent_views.user_id
WHERE
  view_number = 1
AND
  users.deleted_at IS NOT NULL

'''Then, it also needs to be same thing here except for user. It needs to match
in the user as well. So orders.userID and recent_views.userID. So just running it,
 we can see if this actually works. Cant really tell whats going on because this
  might be a pretty rare case. So if you want it to look specifically at the cases
   where the order actually did happen, you could just look at the inner join and
   see. Okay, so this user, Mary Murphy, looked at a prize-winning gadget and
   ordered a prize winning gadget, so we dont need to send her the email. The
   way that he would filter that out using the join is just stick that left out
    of join back in there and then require some part of the orders table to be
    null because you know when you left join in a table and its null, it means
    that there was nothing there, there would have been nothing there in the inner
     join. So Im going to add in orders, and it doesnt really matter, it could
     be userID or itemID, that you put in here. You just need something specifically
      from the orders table to be null. So now were going to not have that case
      where Mary Murphy gets an email. Okay. So these are some extra filters that
       I would add in just to make this emails sending process a little bit nicer
        for whoever is sending it. Again, these are things that you werent
        specifically asked to do but are above and beyond.'''
        SELECT
          COALESCE(users.parent_user_id, users.id)   AS user_id,
          users.email_address,
          items.id                                   AS item_id,
          items.name                                 AS item_name,
          items.category                             AS item_category
        FROM
          (
            SELECT
              user_id,
              item_id,
              event_time,
              ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
                AS view_number
              FROM
                dsv1069.view_item_events
              WHERE
                event_time >= '2017-01-01'
              ) recent_views
        JOIN
         dsv1069.users
        ON
         users.id = recent_views.user_id
        JOIN
         dsv1069.items
        ON
         items.id = recent_views.item_id
       LEFT OUTER JOIN
         dsv1069.orders
       ON
         orders.item_id = recent_views.item_id
       AND
         orders.user_id = recent_views.user_id
       WHERE
         view_number = 1
       AND
         users.deleted_at IS NOT NULL
      AND
        ordes.item_id IS NULL
