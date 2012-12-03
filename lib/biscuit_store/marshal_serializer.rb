
module BiscuitStore::MarshalSerializer

  module_function

  def dump(cookie)
    Marshal.dump(cookie)
  end

  def load(serialized_cookie)
    Marshal.load(serialized_cookie)
  rescue TypeError => e
    msg = "Cookie deserialization error: #{e}"
    defined?(Rails) ? Rails.logger.warn(msg) : warn(msg)
  end

end

