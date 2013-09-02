require 'omniauth'
require 'omniauth-twitter'
require_relative 'utils'

use OmniAuth::Builder do
  provider :twitter, config_for_env["key"], config_for_env["secret"]
end
