require 'jwt'

class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(payload, exp = 60.minutes.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    #HashWithIndifferentAccess.new decoded
  end

  def self.encode(payload)
    JWT.encode payload, Rails.application.secrets.secret_key_base
  end

  def self.decode(token)
    JWT.decode token, Rails.application.secrets.secret_key_base
  end
end



