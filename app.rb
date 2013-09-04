require 'sinatra'
require 'mongoid'
require_relative 'utils'
require_relative 'omniauth'
require_relative 'models/swap.rb'

Mongoid.load!("mongoid.yml", environment)

enable :sessions

get '/' do
  message = session[:message]
  session[:message] = nil
  erb :index, :locals => { :message => message, :swaps => Swap.all.reverse }
end

get '/auth/twitter/callback' do
  hash = request.env['omniauth.auth']
  session[:user] = hash[:info][:nickname]
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

post '/create' do
  swap = Swap.new({
    :skill_needed => params[:skill_needed],
    :skill_offered => params[:skill_offered],
    :user => session[:user]
  })
  if swap.valid?
    swap.save!
    session[:message] = "Swap added"
    redirect '/'
  else
    # erb :new, :locals => { :errors => swap.errors }
    session[:message] = "You gotta fill out all the fields!"
    redirect '/'
  end
end

# API

get '/api/swaps' do
  { :swaps => tidy_results_for_api(Swap.all)}.to_json
end

get '/api/swaps/:id' do
  {
    :swap => tidy_result_for_api(Swap.find(params[:id]))
  }.to_json
end

get '/api/user' do
  { :user => session[:user] }.to_json
end

post '/api/swaps' do
  content_type :json
  puts "rack intput"
  data = request.env["rack.input"].read
  json_data = JSON.parse(data)
  record = json_data["swap"]
  if user_signed_in?
    swap = Swap.new({
      :skill_needed => record["skill_needed"],
      :skill_offered => record["skill_offered"],
      :user => session[:user]
    })
    if swap.valid?
      swap.save!
    else
    end
  end
end

