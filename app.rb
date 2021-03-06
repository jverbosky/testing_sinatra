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
    backend_name = params[:user_name]  # value pulled via name="user_name" in get_name.erb
    # comment out line 23 for test_post_name_no_redirect
    redirect '/age?u_name=' + backend_name  # u_name variable accessed via params[] on line 27
  end

  get '/age' do
    backend_name_2 = params[:u_name]  # u_name here corresponds to u_name on line 23 in redirect > must match
    erb :get_age, locals: {uname: backend_name_2}  # uname variable only used to pass value to get_age.erb
  end

  post '/post_age' do
    # lines 32 & 33 can use to pass basic (no redirect) name and age assertions (test_app.rb line 58)
    backend_name_3 = params[:user_n]  # value pulled via action="post_age?user_n=<%= uname %>" in get_age.erb
    backend_age = params[:user_a]  # value pulled via name="user_a" in get_age.erb
    # comment out line 36 for test_post_age_multiple_values_no_redirect
    redirect '/numbers?u_n=' + backend_name_3 + '&u_a=' + backend_age  # u_n/u_a variables accessed via params[] on lines 40 & 41
  end

  get '/numbers' do
    backend_name_4 = params[:u_n]  # u_n corresponds to u_n on line 36 in redirect > must match
    backend_age_2 = params[:u_a]  # u_a corresponds to u_a on line 36 in redirect > must match
    # "Your name is #{backend_name_4} and your age is #{backend_age_2}"  # test line - kept failing on name, so used to verify output via rackup
    erb :get_numbers, locals: {usn: backend_name_4, usa: backend_age_2}  # usn: & usa: variables only used to pass values to get_numbers.erb
  end

  post '/post_numbers' do
    backend_name_5 = params[:un]  # value pulled via action="post_numbers?un=<%= usn %>&ua=<%= usa %>" in get_numbers.erb
    backend_age_3 = params[:ua]  # value pulled via action="post_numbers?un=<%= usn %>&ua=<%= usa %>" in get_numbers.erb
    one = params[:num_1]  # value pulled via name="num_1" in get_numbers.erb
    two = params[:num_2]  # value pulled via name="num_2" in get_numbers.erb
    three = params[:num_3]  # value pulled via name="num_3" in get_numbers.erb
    # comment out line 54 for test_post_numbers_multiple_values_no_redirect
    # n/a/n1/n2/n3 variables accessed via params[] on lines 65 - 69
    redirect '/results?n=' + backend_name_5 + '&a=' + backend_age_3 + '&n1=' + one + '&n2=' + two + '&n3=' + three
    # # comment out lines 56 - 61 if returning final results via this route
    # sum = one.to_i + two.to_i + three.to_i
    # compare = (sum < backend_age_3.to_i) ? "less" : "greater"
    # "Hello again #{backend_name_5}.<br>
    #  You are #{backend_age_3} years old.<br>
    #  Your favorite numbers are #{one}, #{two} and #{three}.<br>
    #  The sum of your favorite numbers is #{sum}, which is #{compare} than your age."
  end

  get '/results' do
    backened_name_6 = params[:n]  # n corresponds to n on line 54 in redirect > must match
    backened_age_4 = params[:a]  # a corresponds to a on line 54 in redirect > must match
    one_2 = params[:n1]  # n1 corresponds to n1 on line 54 in redirect > must match
    two_2 = params[:n2]  # n2 corresponds to n2 on line 54 in redirect > must match
    three_2 = params[:n3]  # n3 corresponds to n3 on line 54 in redirect > must match
    # line 70 for test_post_numbers_multiple_values_redirect to verify that redirected values made it to this route
    # "name = #{backened_name_6}, age = #{backened_age_4}, first = #{one_2}, second = #{two_2}, third = #{three_2}"
    # view_name:, view_age:, view_n1:, view_n2: and view_n3: variables only used to pass values to results.erb
    erb :results, locals: {view_name: backened_name_6, view_age: backened_age_4, view_n1: one_2, view_n2: two_2, view_n3: three_2}
  end

end