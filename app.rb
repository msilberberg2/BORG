require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'json'
require './models/event'
require './models/review'

get '/' do
	erb :homepage
end
get '/events' do
	erb :events
end