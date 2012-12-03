
require 'active_support'
require 'action_dispatch'

class BiscuitStore < ActionDispatch::Session::CookieStore

  extend ActiveSupport::Autoload
  autoload :SignedBiscuitTin
  autoload :MessagePackSerializer
  autoload :MarshalSerializer

  private

  def unpacked_cookie_data(env)
    env["action_dispatch.request.unsigned_session_cookie"] ||= begin
      stale_session_check! do
        if data = signed_biscuit_tin(env)[@key]
          data.stringify_keys!
        end
        data || {}
      end
    end
  end

  def set_cookie(env, session_id, cookie)
    signed_biscuit_tin(env)[@key] = cookie
  end

  def signed_biscuit_tin(env)
    request = ActionDispatch::Request.new(env)
    SignedBiscuitTin.new(request.cookie_jar,
                         request.env[ActionDispatch::Cookies::TOKEN_KEY],
                         message_verifier_options)

  end

  def message_verifier_options
    default_options.slice(:digest, :serializer)
  end

end

