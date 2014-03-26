#!/usr/bin/env ruby

require 'selenium-webdriver'
require 'faker'
require 'yaml'
require 'i_heart_quotes'
require 'net/smtp'
require 'mailfactory'
  
# Submits a randomized search at bing.com
def Search()
	$driver.navigate.to "http://bing.com"
	sleep $sleepWaitTime
	searchBar = $driver.find_element(:name, 'q')
	case Random.rand(1...10)
		when 1 then searchBar.send_keys IHeartQuotes::Client.where(:max_lines => 1).random.quote() #multi lined quotes was breaking this for me
		when 2 then searchBar.send_keys IHeartQuotes::Client.random.source()
		when 3 then searchBar.send_keys Faker::Address.state() 
		when 4 then searchBar.send_keys Faker::Address.city()
		when 5 then searchBar.send_keys Faker::Address.country()
		when 6 then searchBar.send_keys Faker::Commerce.product_name()
		when 7 then searchBar.send_keys Faker::Company.catch_phrase()
		when 8 then searchBar.send_keys Faker::Company.name()
		when 9 then searchBar.send_keys Faker::Name.name()
	end
	searchBar.submit
	sleep $sleepWaitTime
end

# Logs into Facebook
def LogIntoFacebook(index)
	$driver.navigate.to "http://facebook.com"
	email = $driver.find_element(:name, 'email')
	email.send_keys $config['FACEBOOK_EMAIL'][index]
	pass = $driver.find_element(:name, 'pass')
	pass.send_keys $config['FACEBOOK_PASSWORD'][index]
	pass.submit
end

# Logs into Outlook
def LogIntoOutlook(index)
	$driver.navigate.to "http://outlook.com"
	email = $driver.find_element(:name, 'login')
	email.send_keys $config['OUTLOOK_EMAIL'][index] 
	pass = $driver.find_element(:name, 'passwd')
	pass.send_keys $config['OUTLOOK_PASSWORD'][index]
	pass.submit
end

# Wrapper for searching that  randomizes the wait time between searches
def StartSearchLoop()
	$forLoopCount.times do
		$waitTimeMin = Random.rand(1..$blockTime)
		$waitTimeSec = Random.rand(1..60)
		sleep(($waitTimeMin * 60) + $waitTimeSec) #waitTime converted to seconds for sleep call
		Search()
		#sleep(((24 - $waitTimeMin) * 60) + (60 - $waitTimeSec)) #This line is only to round out the 24 minute block if desired
	end
end

# Logs out of either account using partial link text 'Sign out'
def LogOut()
	$driver.find_element(:id, 'id_l').click
	sleep $sleepWaitTime
	$driver.find_element(:partial_link_text, 'Sign out').click
end

def CheckNotificationCenter(toEmail, account)
	begin
		notificationCount = $driver.find_element(:id, 'bep')
		SendEmail(toEmail, notificationCount, account)
	rescue Exception=>e
		puts e
	end
end

# Sends an email notifying that there are items in the Notification Center to check
def SendEmail(toEmail, notificationCount, account)
    mail = MailFactory.new()
    mail.to = toEmail
    mail.from = $config['EMAIL_SENDER']
    mail.subject = "Bingbot Notifications"
    mail.text = "The number of items in the notification center is " + notificationCount.text + " for " + account + " User: " + toEmail
	smtp = Net::SMTP.new 'smtp.gmail.com', 587
	smtp.enable_starttls
	smtp.start('gmail.com', $config['EMAIL_SENDER'], $config['EMAIL_PASSWORD'], :login)
	smtp.send_message mail.to_s(), $config['EMAIL_SENDER'], toEmail
	smtp.finish
end

I18n.enforce_available_locales = true
$config = YAML::load(File.read('config.yaml')) #; puts $config.inspect # for debugging purposes to see if the yaml file is formatted correctly
#`export DISPLAY=:10` # I use this line for starting xvfb headless server
$driver = Selenium::WebDriver.for :firefox
$testMode = false # true = quicker runtimes, false = full runs for full points
$sleepWaitTime = 5
if $testMode then
	$forLoopCount = 1 # for testing/debugging
	$blockTime = 1    # for testing /debugging
else
	$forLoopCount = 30 # only change this variable if you need more than 30 searches to get 15 points each day
	$runTimeHours = 3 # change this variable to determine the total runtime for each account
	$blockTime = ($runTimeHours * 60) / $forLoopCount # calculate the time block size needed to execute 30 searches given the total desired run time
end

if $config.has_key?('FACEBOOK_EMAIL') 
	for i in 1..$config['FACEBOOK_EMAIL'].count do
		LogIntoFacebook(i-1)
		StartSearchLoop()
		CheckNotificationCenter($config['FACEBOOK_EMAIL'][i-1], "Facebook")
		LogOut()
		sleep $sleepWaitTime # needed to ensure logout success
	end
end

if $config.has_key?('OUTLOOK_EMAIL') 
	for i in 1..$config['OUTLOOK_EMAIL'].count do
		LogIntoOutlook(i-1)
		StartSearchLoop()
		CheckNotificationCenter($config['OUTLOOK_EMAIL'][i-1], "Outlook")
		LogOut()
		sleep $sleepWaitTime # needed to ensure logout success
	end
end

$driver.quit
