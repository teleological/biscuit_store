
class BiscuitStore::SignedBiscuitTin <
  ActionDispatch::Cookies::SignedCookieJar

  def initialize(parent_jar, secret, opts={})
    ensure_secret_secure(secret)
    @parent_jar = parent_jar
    @verifier   = ActiveSupport::MessageVerifier.new(secret, opts)
  end

end

