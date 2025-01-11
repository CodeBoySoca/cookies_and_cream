require 'bcrypt'

class User < ActiveRecord::Base

  def create_user_account(user)
  end

  def check_for_existence(email)
    result = User.find_by(email: email)
    if result
       return result
    else
       return 404
    end
  end

  def format_name(name)
     name.capitalize.split[0]
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
