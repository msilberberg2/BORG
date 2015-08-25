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
require './models/post'
require './models/topic'
#Contains dummy classes
require './classes.rb'
#Processes requests to the Tumblr API
require './TumblrRequest.rb'
#Allows Timestamps to be viewed
require './TimeConverter.rb'

enable :sessions

def create_event(title, date, time, location, description, year)
	Event.create(title: title, eventdate: date, time: time, location: location, description: description, year: year)
end

def create_review(title, piclink, pubdate, revdate, author, description)
	Review.create(title: title, picture: piclink, pubdate: pubdate, revdate: revdate, author: author, description: description)
end

def create_post(user_id, topic_id, content)
	Post.create(user_id: user_id, topic_id: topic_id, content: content)
	topic = Topic.find(topic_id)
	topic.post_count = topic.post_count + 1
	topic.save
end

#Checks if a user is logged in
def login?
	if session[:user_id] == nil && session[:user_admin] == nil
		return false
	elsif session[:user_id] == nil || session[:user_admin] == nil
		#If part of the user's info is there but not all, the user is automatically logged out to correct mistake
		session[:user_id] = nil
		session[:user_admin] = nil
		return false
	else
		return true
	end	
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
	#webadmin is used as a permanent admin. Will be removed later once site is fully operational, for security purposes
	if session[:user_admin] || User.find(session[:user_id]).name == "webadmin"
		erb :adminpage
	else
		redirect "/"
	end
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

#Main forum page
get '/forum' do
	@topics = Topic.find_by_sql("SELECT topics.*, users.name FROM topics
		INNER JOIN users ON topics.user_id = users.id
		ORDER BY topics.updated_at desc")
	erb :forum
end

#Page for a specific forum thread
get '/forum/topics/:topic' do
	@posts = Post.find_by_sql("SELECT posts.*, topics.title, users.name FROM posts
		INNER JOIN topics ON posts.topic_id = topics.id
		INNER JOIN users ON posts.user_id = users.id
		WHERE #{params['topic']} = posts.topic_id
		ORDER BY posts.created_at asc")
	@topic_id = params['topic']
	erb :topic
end


#Logs the user in
post '/login' do
	user = User.where(name: params[:loguser]).first
	if user == nil
		flash[:alert] = "User Does Not Exist"
	elsif user.password == params[:logpassword]
		session[:user_id] = user.id
		session[:user_admin] = user.admin
		flash[:alert] = "Welcome, #{user.name}!"
	else
		flash[:alert] = "Wrong Password"
	end  
	redirect "/"
end

#Logs the user out
post '/logout' do
	session[:user_id] = nil
	session[:user_admin] = nil
	redirect "/"
end

#Creates a thread with one initial post
post '/create_topic' do
	if login?
		topic = Topic.create(title: params[:title], post_count: 0, user_id: session[:user_id])
		create_post(session[:user_id], topic.id, params[:content])
		redirect "/forum/topics/#{topic.id}"
	else
		flash[:alert] = "Please Log In"
		redirect "/"
	end
end

#Creates a post
post '/forum/topics/:topic/create_post' do
	if login?
		create_post(session[:user_id], params['topic'], params[:content])
		
		redirect "/forum/topics/#{params['topic']}"
	else
		flash[:alert] = "Please Log In"
		redirect "/"
	end
end


#Updates a post's content
post '/forum/posts/:post/update_post' do
	curr_post = Post.find(params['post'])
	curr_post.content = params[:content]
	curr_post.save
	redirect "/forum/topics/#{curr_post.topic_id}"
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

#Deletes a review, given the review's id
post '/delete_review/:review' do
	Review.find(params['review']).destroy
	redirect '/bookreviews'
end


#Deletes an event
post '/delete_event/:event' do
	Event.find(params['event']).destroy
	redirect '/events'
end

#Registers a new user
post '/register' do
	if params[:univPass] != "Borgling"
		flash[:alert] = "Universal Password Is Incorrect"
	elsif User.where(name: params[:user]).first != nil
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

#Adds admin status to a user
post "/add_admin" do
	user = User.where(name: params[:inputUser]).first
	if user != nil
		user.admin = true
		user.save
	else
		flash[:alert] = "User Does Not Exist"
	end
	redirect "/adminpage"
end

#Removes admin status from a user
post "/remove_admin" do
	user = User.where(name: params[:inputUser]).first
	#A logged-in user can't remove their own admin status
	if user != nil && user.id != session[:user_id]
		user.admin = false
		user.save
	else
		flash[:alert] = "Cannot remove admin status of non-existent users or yourself"
	end
	redirect "/adminpage"
end