require 'sinatra'

class PersonalDetailsApp < Sinatra::Base

  get '/' do
    erb :get_name
  end

  post '/name' do
    name = params[:name]
    redirect '/age?user_name=' + name
  end

  # get '/age' do
  #   name = params[:user_name]
  #   erb :get_age
  # end


end