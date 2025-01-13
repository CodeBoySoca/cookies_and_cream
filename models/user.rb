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

  def self.format_name(name)
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

  def self.validate_name(name)
     (/\A[a-z\s]+\z/i).match?(name)
  end

  def self.validate_username(username)
    (/\A[a-z0-9_-]+\z/i).match?(username)
  end

  def self.validate_image_upload(image, message)
    unless ['image/jpeg', 'image/gif', 'image/png'].include?(image)
      message
    end
  end

end
