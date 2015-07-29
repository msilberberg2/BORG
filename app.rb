#Written By: Martin Silberberg
#2015

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'bcrypt'
require 'json'
require './models/event'
require './models/review'
require './models/user'
require './classes.rb'
require './tumblr_request.rb'

enable :sessions

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

get '/tumblr' do
	tumblr_posts = TumblrRequest.return_borg_posts
	#Assigns various information about the BORG tumblr to variables
	blog = tumblr_posts["blog"]
	@blog_title = blog["title"]
	@posts = tumblr_posts["posts"]
	erb :tumblr
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

#Registers a new user
post '/register' do
	if User.where(name: params[:user]).first != nil
		flash[:alert] = "User Already Exists"
	elsif params[:password].length < 5
		flash[:alert] = "Please Include a Password With At Least 5 Characters"
	elsif params[:user] == ""
		flash[:alert] = "Please Include a Username"
	elsif !params[:email].include? "@"
		flash[:alert] = "Please Include an Email Address"
	else
		user = User.new
		user.name = params[:user]
		user.password = params[:password]
		user.email = params[:email]
		user.admin = false
		if user.save
	    	flash[:notice] = "Welcome to the Site!"
		else
			flash[:alert] = "Site Error. Please Try again"
		end
	end
	redirect "/"
end