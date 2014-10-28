require 'sinatra'
require_relative "user"

get '/' do
  erb :index
end

post '/user' do
  redirect "/#{params[:nickname]}"
end

get '/:nickname' do
  user = Codeacademy::User.new(params[:nickname])
  @badges = user.badges('ruby')
  erb :user
end