require 'sinatra'

class PersonalDetailsApp < Sinatra::Base

  get '/' do
    erb :name
  end

  post '/name' do
    name = params[:name]
  end

end