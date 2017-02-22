require 'sinatra'

class PersonalDetailsApp < Sinatra::Base

  get '/' do
    erb :name
  end

end