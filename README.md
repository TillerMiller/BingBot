BingBot
=======

Description
-----------

BingBot is my attempt and creating a ruby scrit to automate searches on bing to generate bing points.  The script is built on ruby and uses the selenium driver to log into facebook and or outlook, and then run 30 searches to get 15 points.  The script will attempt to log into each account, and then run the searches in the total amount of time specified by the $runTimeHours variable.  The searches are randomized using both the faker and i_heart_quotes gems, and the time between searches is randomized so that this bot appears less 'bottish'

Dependencies
------------

* faker
* yaml
* selenium
* i_heart_quotes
