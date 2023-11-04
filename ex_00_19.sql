'''Create a User Snapshot Table (Activity/Solution)
Our task was to create a user info table
STEP 3. INSERT INTO TABLE
Then I can insert this into the table
by just sticking this in there [inaudible]. Here is it.

[inaudible] You know reading their decision to join the orders table to itself [inaudible].
The fact that its running as long is probably a good sign, at least as expected, all right.'''

/*Insert into to the table on this date */
{% assign ds = '2018-01-01' %}
INSERT INTO
  user_info
SELECT
  users.id                                                 AS user_id,
  IF(users.created_at = '{{ds}}', 1, 0)                    AS created_today,
  IF(users.deleted_at = '{{ds}}', 1, 0)                    AS is_deleted,
  IF(users.deleted_at = '{{ds}}', 1, 0)                    AS is_deleted_today,
  IF(users_with_orders.user_id = IS NOT NULL, 1, 0)        AS has_ever_ordered,
  IF(users_with_orders_today.user_id = IS NOT NULL, 1, 0)  AS ordered_today,
  '{{ds}}'                                                 AS ds
FROM users
LEFT OUTER JOIN
  (
    SELECT
      DISTINCT user_id
    FROM
      orders
    WHERE
      created_at <= '{{ds}}'
  ) users_with_orders
ON
  users_with_orders.user_id = users.id

LEFT OUTER JOIN
  (
  SELECT
    DISTINCT user_id
  FROM
    orders
  WHERE
    created_at <= '{{ds}}'
) users_with_orders
ON
  users_with_orders.user_id = users.id
WHERE
  users.created_at <= '{{ds}}'
