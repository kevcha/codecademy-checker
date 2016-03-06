require './web'
# require 'pry-byebug'
require 'dotenv'
Dotenv.load

run Sinatra::Application
