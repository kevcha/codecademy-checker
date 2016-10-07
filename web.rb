require 'sinatra'
require 'sinatra/json'
require 'sinatra/respond_with'
require_relative "user"
require 'active_support/core_ext/hash'

configure :development do
  require "sinatra/reloader"
  require "better_errors"
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

get '/' do
  erb :index
end

post '/user' do
  redirect "/#{params[:nickname]}"
end

WEB_BADGES_FR = [
  'Le b.a.-ba du langage HTML',
  'Développez votre propre site',
  'Le b.a.-ba du langage HTML II',
  'Profil d\'un Réseau Social',
  'Le b.a.-ba du langage HTML III',
  'Une page avec photo cliquable',
  'CSS : un aperçu',
  'Concevez un bouton pour votre site',
  'Les sélecteurs CSS',
  'Triez vos amis',
  'Le positionnement CSS',
  'Créer un CV'
]

WEB_BADGES_EN = [
  'Build a Resume',
  'CSS Positioning',
  'Sorting Your Friends',
  'CSS Selectors',
  'Design a Button for Your Website',
  'CSS: An Overview',
  'Clickable Photo Page',
  'HTML Basics III',
  'Social Networking Profile',
  'Build Your Own Webpage',
  'HTML Basics'
]

RUBY_BADGES_COUNT = 19
WEB_BADGES_COUNT = WEB_BADGES_EN.count
PYTHON_BADGES_COUNT = 21

COUNT = {
  'ruby' => RUBY_BADGES_COUNT,
  'web' => WEB_BADGES_COUNT,
  'python' => PYTHON_BADGES_COUNT
}

get '/:nickname' do
  user = Codeacademy::User.new(params[:nickname])
  begin
    @ruby_badges = user.badges('ruby')
    @code_badges = user.badges('code')
    @python_badges = user.badges('python')
    @web_badges = []
    @code_badges.each do |code_badge|
      if WEB_BADGES_EN.include?(code_badge.title) ||
         WEB_BADGES_FR.include?(code_badge.title)
         @web_badges << code_badge
      end
    end
    erb :user
  rescue Codeacademy::User::UnknownUserError => e
    erb :unknown_user
  end
end

def call_api(params)
  answer = nil
  begin
    if !COUNT.keys.include?(params[:language])
      answer = { error: { type: "UnsupportedLanguage", message: "#{params[:language]} is not yet supported by the API"}}
    else
      user = Codeacademy::User.new(params[:nickname])
      badges = user.badges(params[:language])
      answer = { percentage: (badges.count.fdiv(COUNT[params[:language]]) * 100).round, badges: badges }
    end
  rescue Codeacademy::User::UnknownUserError => e
    answer = { error: { type: e.class.name, message: "#{params[:nickname]} is not a CodeCademy username" } }
  rescue Net::HTTPFatalError => e
    answer = { error: { type: e.class.name, message: e.message }}
  end
  return answer
end

get "/api/:language/:nickname.xml" do
  answer = call_api(params)
  content_type "application/xml"
  answer.to_xml
end

get "/api/:language/:nickname" do
  answer = call_api(params)
  json(answer)
end
