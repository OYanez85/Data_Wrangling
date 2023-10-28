'''Exercise 1:
Goal: Here we use users table to pull a list of user email addresses. Edit the query to pull email
addresses, but only for non-deleted users.'''

SELECT id AS user_id, email_address
FROM dsv1069.users
WHERE deleted_at IS NULL;
