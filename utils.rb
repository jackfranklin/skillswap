require "yaml"

def config_for_env
  if environment == :development
    YAML.load_file("config.yml")[environment.to_s]
  else
    {
      "key" => ENV["TWITTER_KEY"],
      "secret" => ENV["TWITTER_SECRET"]
    }
end

def environment
  (ENV["RACK_ENV"] || :development).to_sym
end

def user_signed_in?
  !session[:user].nil?
end

def redirect_if_not_signed_in
  redirect '/' unless user_signed_in?
end
