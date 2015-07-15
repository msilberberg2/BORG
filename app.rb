#Written By: Martin Silberberg
#2015

require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'json'
require './models/event'
require './models/review'

def create_event(title, date, time, location, description)
	Event.create(title: title, eventdate: date, time: time, location: location, description: description)
end

def create_review(title, piclink, pubdate, revdate, author, description)
	Review.create(title: title, picture: piclink, pubdate: pubdate, revdate: revdate, author: author, description: description)
end

get '/' do
	erb :homepage
end

get '/events' do
	@events = Event.all
	erb :events
end

get '/aboutus' do
	erb :aboutus
end

get '/adminpage' do
	erb :adminpage
end

get '/bookreviews' do
	@reviews = Review.all
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
	create_event(params[:inputTitle], params[:inputDate], params[:inputTime], params[:inputLoc], params[:inputDesc])
	redirect '/adminpage'
end