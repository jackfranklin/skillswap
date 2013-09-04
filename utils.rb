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

def tidy_results_for_api(results)
  results.map do |result|
    tidy_result_for_api(result)
  end
end

def tidy_result_for_api(result)
  {
    :id => result._id,
    :skill_needed => result.skill_needed,
    :skill_offered => result.skill_offered,
    :created_at => result.created_at,
    :user => result.user
  }
end
