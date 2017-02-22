require 'sinatra'

class PersonalDetailsApp < Sinatra::Base

  get '/' do
    erb :name
  end

  post '/name' do

  end

end