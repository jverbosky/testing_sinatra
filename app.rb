require 'sinatra'  # in modular style, should we use:  'sinatra/base' instead of 'sinatra'?     ?????

# modular style application - PersonalDetailsApp subclass inherits from Sinatra::Base class
class PersonalDetailsApp < Sinatra::Base

# have to run the app (class) via rackup
#
# 1) Create and configure config.ru (same dir as app.rb)
# 2) Use rackup to instantiate the PersonalDetailsApp class
#     - From terminal run: rackup
#     - Per Matt, in Windows may need to run: bundle exec rackup
# 3) Sinatra will host the app, open a web browser and access via:
#     - http://localhost:9292

  get '/' do
    # "Hello, what is your name?" # can use to pass string test assertion (test_app.rb line 16)
    erb :get_name
  end

  post '/name' do
    backend_name = params[:user_name]
    redirect '/age?u_name=' + backend_name  # comment out for def test_post_name_no_redirect
  end

  get '/age' do
    backend_name_2 = params[:u_name]
    erb :get_age, locals: {u_name: backend_name_2}
  end

  post '/post_age' do
    backend_name_3 = params[:user_n]
    backend_age = params[:user_a]
  end

end

