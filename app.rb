require 'sinatra'


class CookiesCreamApp < Sinatra::Base

  get '/' do

  end

  get '/register' do

  end

  get '/login' do

  end

  get '/logout' do

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
