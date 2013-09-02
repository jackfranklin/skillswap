require "yaml"

def config_for_env
  YAML.load_file("config.yml")[environment.to_s]
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
