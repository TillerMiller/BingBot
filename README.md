BingBot
=======

Description
-----------

BingBot is my attempt and creating a ruby scrit to automate searches on bing to generate bing points.  The script is built on ruby and uses the selenium driver to log into facebook and or outlook, and then run 30 searches to get 15 points.  The script will attempt to log into each account, and then run the searches in the total amount of time specified by the $runTimeHours variable.  The searches are randomized using both the faker and i_heart_quotes gems, and the time between searches is randomized so that this bot appears less 'bottish'

Dependencies
------------
* ruby 1.9.3 (I have not tried running this script on any other version of ruby)
* firefox (you can choose another driver/browser if you like, just choose one that you don't save passwords or auto log into facebook or outlook)
* Gems:
 * i_heart_quotes
 * faker
 * selenium-webdriver
 * yaml
* headless server (optional - I run my Browsie with xvfb)
