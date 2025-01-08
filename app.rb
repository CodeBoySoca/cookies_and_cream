require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv'

Dotenv.load
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |model| require model}


class CookiesCreamApp < Sinatra::Base

  get '/' do

  end

  get '/signin' do
    erb :signin
  end

  post '/email/sent' do
    #page to display to the user to tell them to check their e-mail
    erb :email_sent
  end

  post '/send/email' do
    #send email with magic link
  end

  get '/verify/token' do
    #verify the users token
  end

  get '/signout' do
  end

  get '/shops' do

  end

  get '/dessert/:name' do

  end

  get '/shop/:shop_name' do

  end

  get '/messages/' do

  end

  post '/messages' do

  end

  get '/settings' do

  end

  patch '/settings' do

  end

  get '/favorites' do

  end

  post '/favorites' do
  end

  get '/boards' do

  end

  post '/create/board' do

  end

  get '/board/:letters' do

  end

  post '/board/:letters' do

  end

  get '/board/:letters/conversations/:conversation_id' do

  end

  post '/board/:letters/conversations/:conversation_id' do

  end

  get '/board/:letters/posts/:post' do

  end

 post '/board/:letters/posts/:post' do

 end

  get '/register/shop' do

  end

  post '/register/shop' do

  end

  get '/shops/:account_id' do

  end

  post '/shops/:account_id' do

  end

  get '/settings/:account_id' do

  end

  patch '/settings/:account_id' do

  end

  patch '/shop/edit/:shop_id' do

  end

  delete '/shop/remove/:shop_id' do
  end

  get '/shop/reviews/:shop_id' do

  end

  get '/shop/messages/:shop_id' do

  end

  post '/shop/:shop_id/message/:user_id' do
  end

  run!
end
