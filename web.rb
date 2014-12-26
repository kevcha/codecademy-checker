require 'sinatra'
require_relative "user"

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

get '/:nickname' do
  user = Codeacademy::User.new(params[:nickname])
  @ruby_badges = user.badges('ruby')
  @code_badges = user.badges('code')
  @web_badges = []
  @code_badges.each do |code_badge|
    if WEB_BADGES_EN.include?(code_badge.title) ||
       WEB_BADGES_FR.include?(code_badge.title)
       @web_badges << code_badge
    end
  end
  erb :user
end