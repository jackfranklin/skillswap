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
