require 'sinatra'

class PersonalDetailsApp < Sinatra::Base

  get '/' do
    # erb :get_name
  end

  post '/name' do
    backend_name = params[:user_name]
    redirect '/age?u_name=' + backend_name
  end

  get '/age' do
    backend_name_2 = params[:u_name]
    # for test_post_name > assert(last_response.ok?) to pass,
    # can't return erb without specifying u_name in the .erb
    erb :get_age, locals: {u_name: backend_name_2}
  end

end

# have to run the class via rackup
#
# 1) Create and configure config.ru (same dir as app.rb)
# 2) Use rackup to instantiate the PersonalDetailsApp class
#     - From terminal run: rackup
#     - Per Matt, in Windows may need to run: bundle exec rackup
# 3) Sinatra will host the app, open a web browser and access via:
#     - http://localhost:9292
#