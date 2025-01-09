require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv'
require 'pony'
require 'erb'
require 'json'

Dotenv.load
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |model| require model}

enable :sessions

class CookiesCreamApp < Sinatra::Base

  get '/' do
    #a landing page?
  end

  get '/signout' do
  end

  get '/signin' do
    erb :signin
  end

  post '/email/sent' do
    #page to display to the user to tell them to check their e-mail
    #send email with magic link
    email = Email.new
    token = email.generate_token(params[:email])
    magic_link = "http://localhost:4567/verify?token=#{token}"
    email.send_magic_link({
        :to =>  ENV['EMAIL_RECIPIENT'],
        :via => :smtp,
        :via_options => {
        :address =>  ENV['EMAIL_SERVER'],
          :port =>  ENV['EMAIL_PORT'],
          :enable_starttls_auto =>  true,
          :user_name =>  ENV['EMAIL_SENDER'],
          :password =>  ENV['EMAIL_PASSWORD']
        },
        :subject => 'Cookies and Cream - Magic Link',
        :html_body => ERB.new(File.read('views/magic_link.erb')).result_with_hash({:name => 'Joe', :magic_link => magic_link}),
        :body => 'Hello #{data["name"]} click the link to sign in <a href="#{data["magic_link"]}">Sign in</a>'
      })
    erb :email_sent
  end

  get '/verify' do
    #verify the users token
    email = Email.new
    decoded_token = email.verify_token(params[:token])
    if decoded_token
       #save to database and create a session
       redirect :shops
    else
      'Invalid or expired token'
    end
  end

  get '/profile/setup' do
  end

  get '/shops' do
    erb :shops
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
