#!/usr/bin/env ruby

require 'selenium-webdriver'
require 'faker'
require 'yaml'
require 'i_heart_quotes'

def Search()
	$driver.navigate.to "http://bing.com"
	sleep 5
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
	sleep 5 
end

def LogIntoFacebook()
	$driver.navigate.to "http://facebook.com"
	email = $driver.find_element(:name, 'email')
	email.send_keys $config['FACEBOOK_USERNAME']
	pass = $driver.find_element(:name, 'pass')
	pass.send_keys $config['FACEBOOK_PASSWORD']
	pass.submit
end

def LogIntoOutlook()
	$driver.navigate.to "http://outlook.com"
	email = $driver.find_element(:name, 'login')
	email.send_keys $config['OUTLOOK_EMAIL']
	pass = $driver.find_element(:name, 'passwd')
	pass.send_keys $config['OUTLOOK_PASSWORD']
	pass.submit
end

def StartSearchLoop()
	for i in 1..5 do
		$waitTimeMin = Random.rand(1...$blockTime)
		$waitTimeSec = Random.rand(1..60)
		sleep(($waitTimeMin * 60) + $waitTimeSec) #waitTime converted to seconds for sleep call
		Search()
		#sleep(((24 - $waitTimeMin) * 60) + (60 - $waitTimeSec)) #This line is only to round out the 24 minute block if desired
	end
end

I18n.enforce_available_locales = true
$config = YAML::load(File.read('config.yaml'))
#`export DISPLAY=:10` # I use this line for starting xvfb headless server
sleep 5
$driver = Selenium::WebDriver.for :firefox

#calculate the time block size needed to execute 30 searches given the total desired run time
$runTimeHours = 1
$blockTime = ($runTimeHours * 60) / 30

LogIntoOutlook()
StartSearchLoop()
$driver.deleteAllVisibleCookies()
LogIntoFacebook()
StartSearchLoop()

$driver.quit
