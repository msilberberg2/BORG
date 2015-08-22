#This module converts an ActiveRecord timestamp into the usual American date/time format, with no milliseconds
#ex. 2015-08-21 14:05:50 UTC => 08/21/2015 02:05 PM
module TimeConverter
	#The string is separated into separate named variables so that the method can be easily modified into other datetime manipulation methods
	#in the future
	def TimeConverter.convert_time(timestamp)
		timestamp = timestamp.to_s
		year = timestamp[0..3]
		day = timestamp[8..9]
		month = timestamp[5..6]

		hour = timestamp[11..12]
		minute = timestamp[14..15]

		time = convert_12_hour(hour, minute)
		puts "#{month}/#{day}/#{year} #{time}"
		return "#{month}/#{day}/#{year} #{time}"
	end

	#Converts a 24 hour time to a 12 hour clock, given hours and minutes
	def TimeConverter.convert_12_hour(hour, minute)
		#indicates whether current time is AM or PM
		meridiem = "AM"

		if hour.to_i > 12
			meridiem = "PM"
			hour = (hour.to_i - 12).to_s
		elsif hour.to_i == 0
			hour = "12"
		end
		return "#{hour}:#{minute} #{meridiem}"
	end
end