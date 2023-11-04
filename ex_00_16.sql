'''Create a User Snapshot Table (Activity/Solution)
STEP 0: LIQUID TAGS -(VARIABLES)'''

'''First concept I want to point out here is something called Liquid tags.
I think thats what mode calls it. Really its just a variable. What you should
 notice is that theres something that doesnt look like SQL showing up there and
 down here. So really being able to put a variable into your SQL is one of the
 keys that you have to figure out in order to unlock scheduling queries to run.
So Im just going to show you what it looks like here. So I can pull the user ID,
and then I just wanted to insert this date into the column just so you can see
that I can put it anywhere I want. This query that Ive written doesnt really
make any sense, its nonsense.'''

{% assign ds = '2018-01-01' %}
SELECT
  id,
  '{{ds}}' AS variable_column
FROM users

'''I might want do something a little bit more meaningful if I wanted to just
look at users who were created before a specific time. So we had created a less
than or equal to this date. That might be a more meaningful thing to query.
There we go.'''

  {% assign ds = '2018-01-01' %}
  SELECT
    id,
  FROM
    users
  WHERE
  created_at <= '{{ds}}'
