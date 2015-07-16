#Written By: Martin Silberberg
#2015

require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'json'
require './models/event'
require './models/review'
require './classes.rb'

def create_event(title, date, time, location, description, year)
	Event.create(title: title, eventdate: date, time: time, location: location, description: description, year: year)
end

def create_review(title, piclink, pubdate, revdate, author, description)
	Review.create(title: title, picture: piclink, pubdate: pubdate, revdate: revdate, author: author, description: description)
end

get '/' do
	if Review.last != nil
		@review = Review.last
	else
		@review = DummyReview.new
	end
	#Reorders events based on the dates of those events
	@events = Event.all.order('year', 'eventdate').take(3)
	erb :homepage
end

get '/events' do
	@events = Event.all.order('year', 'eventdate')
	erb :events
end

get '/aboutus' do
	erb :aboutus
end

get '/adminpage' do
	erb :adminpage
end

get '/bookreviews' do
	@reviews = Review.all.reverse
	erb :bookreviews
end

get '/constitution' do
	erb :constitution
end

#Creates a new entry in the reviews table, using the inputted variables
post '/review' do
	create_review(params[:inputTitle2], params[:inputPic], params[:inputDatePub], params[:inputDateRev], params[:inputAuthor], params[:inputDesc2])
	redirect '/adminpage'
end

#Creates a new entry in the events table, using the inputted variables
post '/create_event' do
	eventdate = params[:inputDateMonth]+"/"+params[:inputDate]+"/"+params[:inputDateYear]
	create_event(params[:inputTitle], eventdate, params[:inputTime], params[:inputLoc], params[:inputDesc], params[:inputDateYear])
	redirect '/adminpage'
end