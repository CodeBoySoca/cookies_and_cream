require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv'
require 'pony'
require 'erb'
require 'rack/protection'
require 'securerandom'
require 'redis'
require 'json'


Dotenv.load
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |model| require model}

class CookiesCreamApp < Sinatra::Base
  redis = Redis.new(url: ENV['REDIS_URL'])

  configure do
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    use Rack::Protection
    use Rack::Protection::AuthenticityToken
  end

  helpers do
    def csrf_tag
      "<input type='hidden' id='csrf_token' name='authenticity_token' value='#{env['rack.session'][:csrf]}'>"
    end
  end

  helpers do
    def toast(message)
      "<span class='error'>#{message}</span>"
    end
  end

  helpers do
    def server_email_credentials()
      {
        :address =>  ENV['EMAIL_SERVER'],
        :port =>  ENV['EMAIL_PORT'],
        :enable_starttls_auto =>  true,
        :user_name =>  ENV['EMAIL_SENDER'],
        :password =>  ENV['EMAIL_PASSWORD']
      }
    end
  end

  #global
  get '/' do
    #a landing page?
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

  post '/signup' do
    @name = User.validate_name(params[:name])
    @username = User.validate_username(params[:username])
    if @name && @username
        #add the username and name to redis
        session[:username] = params[:username]
        account = Account.new
        account.cache_account(redis, session.id, {name: params[:name], username: params[:username]})
       redirect :'email/magic-link'
    else
       erb :'registration/signup', locals: {:toast => toast('Username or name has invalid characters')}
    end
  end

  get '/email/magic-link' do
    erb :'authentication/signin'
  end

  post '/email/magic-link' do
    email = Email.validate_email(params[:email])
    if email
       user = User.new
       account = Account.new
       account_status = user.check_for_existence(params[:email])
       if account_status != 404
          erb :'authentication/signin', locals: {:toast => toast('User already has an account')}
       else
          account.cache_account(redis, session.id, {email: params[:email]})
          redirect '/send/magic-link'
       end
    end
    erb :'authentication/signin', locals: {:toast => toast('E-mail is invalid')}
  end

  get '/send/magic-link' do
    #page to display to the user to tell them to check their e-mail
    #send email with magic link
    account = Account.new
    user_data = account.get_cached_data(redis, session.id)
    email = Email.new
    token = email.generate_token(params[:email])
    magic_link = "http://localhost:4567/verify/account/?token=#{token}"
    email.send_magic_link({
        :to =>  ENV['EMAIL_RECIPIENT'],
        :via => :smtp,
        :via_options => server_email_credentials(),
        :subject => 'Cookies and Cream - Magic Link',
        :html_body => ERB.new(File.read('views/authentication/magic_link.erb')).result_with_hash({
            :name => User.format_name(user_data['name']),
            :magic_link => magic_link
        }),
        :body => 'Hello #{data["name"]} click the link to sign in <a href="#{data["magic_link"]}">Sign in</a>'
      })
    erb :'authentication/email_sent'
  end

  get '/verify/account/' do
    #verify the users token
    email = Email.new
    decoded_token = email.verify_token(params[:token])
    if decoded_token
       redirect :'profile-image'
    else
      'Invalid or expired token'
    end
  end

  get '/profile-image' do
    erb :'registration/profile_image'
  end

  post '/profile-image' do
    temp = params[:image][:tempfile]
    @profile_image = params[:image][:filename]
    filepath = "./public/images/profiles/users/#{@profile_image}"
    image_size = User.check_image_size(temp, @profile_image) || {:toast => toast('Image exceeds 1MB')}
    file_type = User.validate_image_upload(params[:image][:type]) ||
    {:toast => toast('Image format is invalid(the image must be JPEG,PNG or GIF format)')}
    if image_size.respond_to?(:has_key?)
      erb :'registration/profile_image', locals: image_size
    elsif file_type.respond_to?(:has_key?)
      erb :'registration/profile_image', locals: file_type
    else
      File.open(filepath, 'wb') { |f| f.write(temp.read)}
      account = Account.new
      account.cache_account(redis, session.id, {image: filepath})
      redirect :'dessert/fav'
    end
  end

  get '/dessert/fav' do
    erb :'registration/dessert_preference'
  end

  post '/dessert/fav' do
    @dessert_choice = request.body.read
    account = Account.new
    account.cache_account(redis, session.id, {dessert: @dessert_choice})
    erb :'registration/location'
  end

  get '/location' do
    erb :'registration/location'
  end

  post '/location' do
     #redirect to shops after adding everything to db
     @city = params[:city]
     @country = params[:country]
     @state = params[:state]
    if @city == nil || @city == '' || @country == nil || @country == '' || @state == nil || @state == ''
      erb :'registration/location'
    else
      account = Account.new
      account.cache_account(redis, session.id, {city: @city, state: @state, country: @country})
      redirect :shops
    end
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
