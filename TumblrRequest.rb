require 'tumblr_client'
require 'json'

#Processes Tumblr API requests for the application
module TumblrRequest
	#Returns the 10 latest posts on the BORG tumblr
	def TumblrRequest.return_borg_posts
		Tumblr.configure do |config|
		  config.consumer_key = "UmCTsniTesyKD4kSqS0zRsb0AtHt90BhGfJdowds3lXxjoEBeW"
		  config.consumer_secret = "kgnCICK4UuqMY6Q3xc35Khk3UwEfwOtGzm7GJbW7PBHf8Y67bp"
		  config.oauth_token = "waGydozCTJ7Pci5mE0v968vtSMYdfJHj3XsMGmeuFinybPuFlg"
 		  config.oauth_token_secret = "ArK0WScHz3Ox4hkuYce1ohFRq48zJL7qzamMxsNJNmIOuHxzrX"
		end
		client = Tumblr::Client.new
		
		#returns the response hash
		return client.posts("borglings.tumblr.com", :limit => 10)
	end
end