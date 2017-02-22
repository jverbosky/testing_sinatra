require 'sinatra'

class PersonalDetailsApp < Sinatra::Base

  get '/' do
    erb :get_name
  end

  post '/name' do
    backend_name = params[:user_name]
    redirect '/get_age?u_name=' + backend_name
  end

  get '/get_age' do
    backend_name_2 = params[:u_name]
    # for test_post_name > assert(last_response.ok?) to pass,
    # can't return erb without specifying u_name in the .erb
    # erb :get_age, locals: {u_name: backend_name_2}
  end


end