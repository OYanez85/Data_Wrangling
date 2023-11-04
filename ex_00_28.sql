'''FINAL ASSIGNMENT'''
'''1. DATA QUALITY CHECK. --We are running an experiment at an item-level, which means all users who visit will see the same page, but the layout of different item pages may differ.
--Compare this table to the assignment events we captured for user_level_testing.
--Does this table have everything you need to compute metrics like 30-day view-binary?

SELECT
  *
FROM
  dsv1069.final_assignments_qa'''

'''2.REFORMAT THE DATA.
--Reformat the final_assignments_qa to look like the final_assignments table, filling in any missing values with a placeholder of the appropriate data type.

SELECT
  *
FROM
  dsv1069.final_assignments_qa'''

'''COMPUTE ORDER BINARY.
-- Use this table to
-- compute order_binary for the 30 day window after the test_start_date
-- for the test named item_test_2

SELECT
 *
FROM
  dsv1069.final_assignments'''

'''COMPUTE VIEW ITEM METRICS.
-- Use this table to
-- compute view_binary for the 30 day window after the test_start_date
-- for the test named item_test_2

SELECT
 *
FROM
  dsv1069.final_assignments'''

'''COMPUTE LIFT AND P-VALUE.
--Use the https://thumbtack.github.io/abba/demo/abba.html to compute the lifts
in metrics and the p-values for the binary metrics ( 30 day order binary and 30
day view binary) using a interval 95% confidence.'''
