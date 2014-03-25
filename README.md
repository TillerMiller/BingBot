BingBot
=======

Description
-----------

BingBot is my attempt at creating a ruby script to automate searches on bing.  The script is built on ruby and yaml.  It uses the selenium driver to log into facebook and or outlook, and then runs searches.  The script logs into each account, and then runs the searches in the total amount of time specified by the $runTimeHours variable.  The searches are randomized using both the faker and i_heart_quotes gems, and the time between searches is randomized so that this bot appears less 'bottish'.

Dependencies
------------

* Ruby 1.9.3 (I have not tried running this script on any other version of ruby)
* Firefox (you can choose another driver/browser if you like, just choose one that you don't save passwords or auto log into facebook or outlook)
* Gems:
 * i_heart_quotes
 * faker
 * selenium-webdriver
 * yaml
* Headless server (optional - I run my Browsie with xvfb so that I never even see an open browser)

Install Instructions
---------------------

1. Install Git - http://www.git-scm.com/downloads
 * If you've never used git before I highly recommend watching videos to get familiarized
2. Install Ruby - https://www.ruby-lang.org/en/downloads/
3. Clone this repository (Instructions on how to clone a repo - http://git-scm.com/book/en/Git-Basics-Getting-a-Git-Repository):
 1. Open git bash (windows) or your terminal window (Linux, OSX)
 2. Change directory ('cd') to your desired working directory - cd 'c:/example/of/desiredworking/directory'
 3. 'git init'
 4. 'git clone https://github.com/TillerMiller/BingBot.git'
4. If using windows install this dev kit - https://github.com/oneclick/rubyinstaller/wiki/development-kit
5a. If using bundler 'bundler update'
5b. If not using bundler Install the required gems:
 * 'gem install faker'
 * 'gem install i_heart_quotes'
 * 'gem install selenium-webdriver'
6. Change the config-example.yaml to contain your facebook and outlook credentials, and rename the file to config.yaml
7. Set Browsie.rb to run automatically every day!
 * Windows - Task Scheduler
 * OSX - Automator
 * Linux - Crontab

Pipeline
--------

I will be automating an email notification when there are items worth checking in the 'Notification Center'
