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
      message: I18n.t('token_expired')
    }
  rescue JWT::VerificationError
    {
      error: true,
      message: I18n.t('unverified_token')
    }
  rescue JWT::DecodeError
    {
      error: true,
      message: I18n.t('decodeerror')
    }
  end
end
