
require 'msgpack'

module BiscuitStore::MessagePackSerializer

  module_function

  def dump(cookie)
    serializable_cookie(cookie).to_msgpack
  end

  def load(serialized_cookie)
    deserialized_cookie(MessagePack.unpack(serialized_cookie))
  rescue MessagePack::UnpackError => e
    msg = "Cookie deserialization error: #{e}"
    defined?(Rails) ? Rails.logger.warn(msg) : warn(msg)
    nil
  end

  class << self

    private

    def serializable_cookie(cookie)
      (cookie.kind_of?(Hash) && cookie.has_key?('flash')) ?
        cookie_with_serializable_flash(cookie) : cookie
    end

    def cookie_with_serializable_flash(cookie)
      cookie.merge('flash' => cookie['flash'].to_hash)
    end

    def deserialized_cookie(cookie)
      (cookie.kind_of?(Hash) && cookie.has_key?('flash')) ?
        cookie_with_deserialized_flash(cookie) : cookie
    end

    def cookie_with_deserialized_flash(cookie)
      flash = ActionDispatch::Flash::FlashHash.new.replace(cookie['flash'])
      cookie.merge('flash' => flash)
    end

  end

end

