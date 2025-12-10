module Tokenizable
  extend ActiveSupport::Concern

  SECRET_KEY = ENV['CRYPTOR_SECRET_KEY']

  def encrypt_token(data)
    cryptor.encrypt_and_sign(data)
  end

  def decrypt_token(token)
    return if token.blank?

    begin
      cryptor.decrypt_and_verify(token)
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      nil
    end
  end

  private

  def cryptor
    ActiveSupport::MessageEncryptor.new(SECRET_KEY)
  end
end
