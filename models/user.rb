require 'bcrypt'

class User < ActiveRecord::Base

  def create_user_account(user)
  end

  def check_for_existence(email)
  end

  def check_for_user_session()
     #run this before any of the methods for request
     #user to be logged in
  end

  def retrieve_user_account(email)
  end

  def edit_user_account(email)
  end

  def deactivate_user_account(email)
  end

  def signout()
  end

end
