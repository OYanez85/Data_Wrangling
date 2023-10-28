'''Exercise 7:
--Goal: Figure out what percent of users have ever viewed the user profile page, but this query
isn’t right. Check to make sure the number of users adds up, and if not, fix the query.
Starter Code'''
'''SELECT
(CASE WHEN first_view IS NULL THEN false
    ELSE true END) AS has_viewed_profile_page,
COUNT(user_id) as users
FROM
  (SELECT
    users.id AS user_id,
    MIN(event_time) AS first_view
   FROM
     dsv1069.users
   LEFT OUTER join
     dsv1069.events
   ON
     events.user_id = users.id
   WHERE
     event_name = 'view_user_profile'
   GROUP BY
    users.id
  ) first_profile_views
  GROUP BY
   (CASE WHEN first_view IS NULL THEN false
      ELSE true END)'''

'''THE FOLLOWING IS TH TEACHERS teachers WAY OF DOING IT JUST CHANGING WHERE BY AND IN THE INNER JOINT:
      '''SELECT
      (CASE WHEN first_view IS NULL THEN false
          ELSE true END) AS has_viewed_profile_page,
      COUNT(user_id) as users
      FROM
        (SELECT
          users.id AS user_id,
          MIN(event_time) AS first_view
         FROM
           dsv1069.users
         LEFT OUTER join
           dsv1069.events
         ON
           events.user_id = users.id
         AND
           event_name = 'view_user_profile'
         GROUP BY
          users.id
        ) first_profile_views
        GROUP BY
         (CASE WHEN first_view IS NULL THEN false
            ELSE true END)'''

      SELECT
        (CASE WHEN has_viewed_profile_page THEN 'Yes' ELSE 'No' END) AS has_viewed_profile_page,
        COUNT(user_id) AS user_count,
        ROUND((COUNT(user_id) * 100.0 / (SELECT COUNT(*) FROM dsv1069.users)), 2) AS percent_of_users
      FROM (
        SELECT
          users.id AS user_id,
          CASE WHEN MIN(event_name) IS NOT NULL THEN true ELSE false END AS has_viewed_profile_page
        FROM dsv1069.users
        LEFT JOIN dsv1069.events
        ON users.id = events.user_id AND event_name = 'view_user_profile'
        GROUP BY users.id
      ) user_views
      GROUP BY has_viewed_profile_page;
