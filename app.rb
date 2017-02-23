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
    redirect '/age?u_name=' + backend_name  # comment out for test_post_name_no_redirect
  end

  get '/age' do
    backend_name_2 = params[:u_name]
    erb :get_age, locals: {u_name: backend_name_2}
  end

  post '/post_age' do
    backend_name_3 = params[:user_n]  # can use to pass basic (no redirect) name and age assertions (line 58)
    backend_age = params[:user_a]
    redirect '/numbers?u_n=' + backend_name_3 + '&u_a=' + backend_age  # comment out for test_post_age_multiple_values_no_redirect
  end

  get '/numbers' do
    backend_name_4 = params[:u_n]
    backend_age_2 = params[:u_a]
    # "Your name is #{backend_name_4} and your age is #{backend_age_2}"  # kept failing on name, so used to verify output via rackup
    erb :get_numbers, locals: {u_n: backend_name_4, u_a: backend_age_2}
  end

  post '/post_numbers' do
    backend_name_5 = params[:un]
    backend_age_3 = params[:ua]
    one = params[:num_1]
    two = params[:num_2]
    three = params[:num_3]
    sum = one.to_i + two.to_i + three.to_i
    compare = (sum < backend_age_3.to_i) ? "less" : "greater"
    "Hello again #{backend_name_5}.<br>
     You are #{backend_age_3} years old.<br>
     Your favorite numbers are #{one}, #{two} and #{three}.<br>
     The sum of your favorite numbers is #{sum}, which is #{compare} than your age."
  end

end

