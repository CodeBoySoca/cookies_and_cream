require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv'
require 'pony'
require 'erb'
require 'rack/protection'
require 'securerandom'

Dotenv.load
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |model| require model}

class CookiesCreamApp < Sinatra::Base
  configure do
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    use Rack::Protection
    use Rack::Protection::AuthenticityToken
  end

  helpers do
    def csrf_tag
      "<input type='hidden' name='authenticity_token' value='#{env['rack.session'][:csrf]}'>"
    end
  end

  helpers do
    def toast(message)
      "<span class='error'>#{message}</span>"
    end
  end

  #global
  get '/' do
    #a landing page?
    user = User.new
    result = user.check_for_existence('betty@t.net')
    puts result
  end

  get '/signout' do
  end

  get '/account/type' do
    erb :'registration/account_type'
  end

  patch '/settings' do

  end

  get '/settings/' do

  end

  #users
  get '/signup' do
    erb :'registration/signup'
  end

  post '/email/magic-link' do
    erb :'authentication/signin'
  end

  post '/send/magic-link' do
    #page to display to the user to tell them to check their e-mail
    #send email with magic link
    user = User.new
    email = user.check_for_existence(params[:email])
    if email == 404
        email = Email.new
        token = email.generate_token(params[:email])
        magic_link = "http://localhost:4567/verify/account/?token=#{token}"
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
            :html_body => ERB.new(File.read('views/authentication/magic_link.erb')).result_with_hash({:name => user.name, :magic_link => magic_link}),
            :body => 'Hello #{data["name"]} click the link to sign in <a href="#{data["magic_link"]}">Sign in</a>'
          })
        erb :'authentication/email_sent'
     else
       erb :'authentication/signin', locals: {:toast => toast('User already has an account')}
     end
    end

  get '/verify/account/' do
    #verify the users token
    email = Email.new
    decoded_token = email.verify_token(params[:token])
    if decoded_token
       #save to database and create a session
       redirect :'profile-image'
    else
      'Invalid or expired token'
    end
  end


  get '/profile-image' do
    erb :'registration/profile_image'
  end

  get '/dessert/favs' do
    erb :'registration/dessert_preference'
  end

  get '/location' do
    erb :'registration/location'
  end

  post '/location' do
     #redirect to shops after adding everything to db
  end

  get '/shops' do
    erb :'user/shops'
  end

  get '/dessert/:name' do
    erb :'user/dessert'
  end

  get '/messages/' do
    erb :'user/messages'
  end

  post '/messages' do

  end

  get '/favorites' do
    erb :'user/favorites'
  end

  post '/favorites' do
  end

  get '/boards' do
    erb :'user/boards'
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

  #shops
  get '/shop/signup' do
     erb :'registration/signup'
  end

  get '/shop/email/magic-link' do
    erb :'authentication/signin'
  end

  post '/shop/send/magic-link' do
    #page to display to the user to tell them to check their e-mail
    #send email with magic link
    user = User.new
    email = user.check_for_existence(params[:email])
    if email == 404
        email = Email.new
        token = email.generate_token(params[:email])
        magic_link = "http://localhost:4567/verify/account/?token=#{token}"
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
            :html_body => ERB.new(File.read('views/authentication/magic_link.erb')).result_with_hash({:name => user.name, :magic_link => magic_link}),
            :body => 'Hello #{data["name"]} click the link to sign in <a href="#{data["magic_link"]}">Sign in</a>'
          })
        erb :'authentication/email_sent'
     else
       erb :'authentication/signin', locals: {:toast => toast('User already has an account')}
     end
    end


  get '/shop/verify/account' do
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

  get '/shop/owner/profile' do
    #this is for the photo of the owner
  end

  get '/shop/owner/location' do
  end

  get '/shop/add' do
    erb :'shop/shop'
  end

  post '/shop/add' do
  end

  get '/shop/menu' do
    erb :'shop/menu'
  end

  get '/shop/:shop_name' do
  end

  get '/shop/edit/:shop_name' do
  end

  get '/shop/remove/:shop_name' do
  end

  get '/shops/:account_id' do
  end

  get '/shop/reviews/:shop_name' do
  end

  get '/shop/messages/:shop_name' do

  end

  post '/shop/:shop_name/message/:user_id' do
  end

  run!
end
