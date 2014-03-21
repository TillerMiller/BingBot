#!/usr/bin/env ruby

require 'selenium-webdriver'
require 'faker'
require 'yaml'
require 'i_heart_quotes'

def Search()
	$driver.navigate.to "http://bing.com"
	sleep $sleepWaitTime
	searchBar = $driver.find_element(:name, 'q')
	case Random.rand(1...10)
		when 1 then searchBar.send_keys IHeartQuotes::Client.where(:max_lines => 1).random.quote() #multi lined quotes was breaking this for me
			#puts "Switch 1 chosen"
		when 2 then searchBar.send_keys IHeartQuotes::Client.random.source()
			#puts "Switch 2 chosen"
		when 3 then searchBar.send_keys Faker::Address.state() 
			#puts "Switch 3 chosen"
		when 4 then searchBar.send_keys Faker::Address.city()
			#puts "Switch 4 chosen"
		when 5 then searchBar.send_keys Faker::Address.country()
			#puts "Switch 5 chosen"
		when 6 then searchBar.send_keys Faker::Commerce.product_name()
			#puts "Switch 6 chosen"
		when 7 then searchBar.send_keys Faker::Company.catch_phrase()
			#puts "Switch 7 chosen"
		when 8 then searchBar.send_keys Faker::Company.name()
			#puts "Switch 8 chosen"
		when 9 then searchBar.send_keys Faker::Name.name()
			#puts "Switch 9 chosen"
	end
	searchBar.submit
	sleep $sleepWaitTime
end

def LogIntoFacebook(index)
	$driver.navigate.to "http://facebook.com"
	email = $driver.find_element(:name, 'email')
	email.send_keys $config['FACEBOOK_EMAIL'][index]
	pass = $driver.find_element(:name, 'pass')
	pass.send_keys $config['FACEBOOK_PASSWORD'][index]
	pass.submit
end

def LogIntoOutlook(index)
	$driver.navigate.to "http://outlook.com"
	email = $driver.find_element(:name, 'login')
	email.send_keys $config['OUTLOOK_EMAIL'][index] 
	pass = $driver.find_element(:name, 'passwd')
	pass.send_keys $config['OUTLOOK_PASSWORD'][index]
	pass.submit
end

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

I18n.enforce_available_locales = true
$config = YAML::load(File.read('config.yaml'))
#puts $config.inspect # for debugging purposes to see if the yaml file is formatted correctly
#`export DISPLAY=:10` # I use this line for starting xvfb headless server
$driver = Selenium::WebDriver.for :firefox
$testMode = false # true = quicker runtimes, false = full runs for full points
$sleepWaitTime = 5
if $testMode then
	$forLoopCount = 1 # for testing/debugging
	$blockTime = 1    # for testing /debugging
else
	$forLoopCount = 30 # don't change this variable, you need 30 searches to get 15 points each day
	$runTimeHours = 3 # change this variable to determine the total runtime for each account
	# calculate the time block size needed to execute 30 searches given the total desired run time
	$blockTime = ($runTimeHours * 60) / 30
end

for i in 1..$config['FACEBOOK_EMAIL'].count do
	LogIntoFacebook(i-1)
	StartSearchLoop()
	LogOut()
	sleep $sleepWaitTime # needed to ensure logout success
end

for i in 1..$config['OUTLOOK_EMAIL'].count do
	LogIntoOutlook(i-1)
	StartSearchLoop()
	LogOut()
	sleep $sleepWaitTime # needed to ensure logout success
end

$driver.quit
