class Review < ActiveRecord::Base
	#Creates a review with the given parameters
	def self.create_review(title, piclink, pubdate, revdate, author, description)
		self.create(title: title, picture: piclink, pubdate: pubdate, revdate: revdate, author: author, description: description)
	end
end