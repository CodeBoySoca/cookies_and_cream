require 'jwt'
require 'time'

class Email
  SECRET_KEY = Base64.urlsafe_encode64(SecureRandom.random_bytes(32))

  def generate_token(email)
    payload = {email: email, exp: Time.now.to_i + 800, iat: Time.now.to_i}
    return JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def send_magic_link(mail_message)
    Pony.mail(mail_message)
  end

  def verify_token(token)
    begin
       return JWT.decode(token, SECRET_KEY, true, {algorithm: 'HS256'})[0]
    rescue JWT::ExpiredSignature
      nil
    rescue JWT::VerificationError
      nil
    rescue JWT::DecodeError
      nil
    end
  end

end
