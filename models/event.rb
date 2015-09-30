class Event < ActiveRecord::Base
	#Creates an event with the given parameters
	def self.create_event(title, date, time, location, description, year)
		self.create(title: title, eventdate: date, time: time, location: location, description: description, year: year)
	end
end