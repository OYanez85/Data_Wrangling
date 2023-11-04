'''Create a User Snapshot Table (Activity/Solution)
Our task was to create a user info table
STEP 2. CREATE TABLE'''

CREATE TABLE IF NOT EXISTS user_info
(
  user_id           INT(10)     NOT NULL,
  created_today     INT(1)      NOT NULL,
  is_deleted        INT(1)      NOT NULL,
  is_deleted_today  INT(1)      NOT NULL,
  has_ever_ordered  INT(1)      NOT NULL,
  ordered_today     INT(1)      NOT NULL,
  ds                DATE        NOT NULL
);
DESCRIBE user_info;

'''So Im going to create a table to put this stuff into. That is exactly the way
 I want it to be. So user ID is going to be an integer, the created_today, is_deleted,
  is_deleted_today has ever ordered, ordered_today are all integers with just one
  digit because theyre just binary values, yes or no. Then ds I guess is the date.
  Okay, and theres no primary key for this table because users are going to show up
  once for every day that theyve existed.'''
