'''Flexible Data Formats. Theory'''
'''SELECT
  event_id,
  event_time,
  event_name,
  user_id,
  platform,
  parameter_name,
  parameter_value
FROM
  dsv1069.events
WHERE
  event_name = 'view_user_profile''''

'''The followed statement is cleaned from the data we do not need'''

SELECT
  event_id,
  event_time,
  --event_name,
  user_id,
  platform,
  --parameter_name,
  parameter_value AS viewed_user_id
FROM
  dsv1069.events
WHERE
  event_name = 'view_user_profile'

'''Check when we started recording the event for each platform. We just put the
parameter in a column using a where clause like this'''

  SELECT
    event_id,
    event_time,
    user_id,
    platform,
    CAST(parameter_value AS INT) AS viewed_user_id
  FROM
    dsv1069.events
  WHERE
    event_name = 'view_user_profile'

'''But how are we going to extend this if we want to have more parameter names as columns like in the exercise? Imagine that we decide we want to start logging user profile view events that are anonymous'''

SELECT
  event_id,
  event_time,
  user_id,
  platform,
  CAST(parameter_value AS INT) AS viewed_user_id
FROM
  dsv1069.events
WHERE
  event_name = 'view_user_profile'
AND
  parameter_name = 'viewed_user_id'

'''. So we would like to instead of just using viewed the user ID, we want to
have a browser or device identifier. We woul not start getting this data until
after we decided to record it. So then if we wanted to write a query that will
 still work as we add more parameters, this format with the where clause is not
 going to work. So lets figure out what would need to change. It might be helpful
  to think about how to get the perimeter value to show up in a specific column
  only when the parameter name is the right one.'''
'''the following statement does not work because: Lets have that case to the
list of things that might go wrong with an events table. A parameter might not
be listed for all of the events.  A parameter might not be listed for all of the events'

  SELECT
    event_id,
    event_time,
    user_id,
    platform,
    --CAST(parameter_value AS INT) AS viewed_user_id,
    (CASE WHEN parameter_name == 'viewed_user_id'
          THEN CAST(parameter_value AS INT)
          ELSE NULL
            END) AS viewed_user_id
  FROM
    dsv1069.events
  WHERE
    event_name = 'view_user_profile'

'''Now, lets think about how we could do this if our events are formatted in
another way like in JSON. If your data is formatted in this way, then hopefully
your version of SQL has a function that can extract text from JSON. Our first
step might look something like this, where we use a getJSON function and it lets
us pull out our perimeter'''

SELECT
  event_id,
  event_time,
  user_id,
  platform,
  get_json(raw.viewed_user_id) AS viewed_user_id
FROM
  dsv1069.events
WHERE
  event_name = 'view_user'
