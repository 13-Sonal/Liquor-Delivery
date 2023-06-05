require 'jwt'
module JsonWebToken
  SECRET_KEY = Rails.application.credentials[:secret_key_base]

  def jwt_encode(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::ExpiredSignature
    {
      error: true,
      message: 'Token has been expired'
    }
  rescue JWT::VerificationError
    {
      error: true,
      message: 'Unable to verify token'
    }
  rescue JWT::DecodeError
    {
      error: true,
      message: 'Unable to decode token'
    }
  end
end
