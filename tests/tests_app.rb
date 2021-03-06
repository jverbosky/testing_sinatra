require 'minitest/autorun'  # need for the Minitest::Test class
require 'rack/test'  # need for the Rack::Test::Methods mixin
require_relative '../app.rb'  # path to app file (one subdirectory higher than this file)

class TestApp < Minitest::Test  # TestApp subclass inherits from Minitest::Test class
  include Rack::Test::Methods  # Include the methods in the Rack::Test:Methods module (mixin)
  # Methods include: get, post, last_response, follow_redirect!

  def app
    PersonalDetailsApp  # most examples use App.new - reason why we don't need .new here?     ?????
  end

  def test_get_entry_page
    get '/'  # verify a (get '/' do) route exists - doesn't need erb statement to pass
    assert(last_response.ok?)  # verify server response == 200 for (get '/') action - doesn't need erb statement to pass
    assert(last_response.body.include?('Hello, what is your name?'))  # can pass with text in route (app.rb line 16) or with text in get_name.erb
    assert(last_response.body.include?('<form method="post" action="name">'))  # need get_name.erb specified in route with same text in erb
    assert(last_response.body.include?('<input type="text" name="user_name">'))  # ditto
  end

  # def test_post_name_no_redirect  # example without redirect (comment out app.rb line 22)
  #   post '/name', user_name: 'John'  # seed values - not an assertion, corresponds to backend_name = params[:user_name]
  #   assert(last_response.body.include?('John'))  # getting value via seed value
  # end

# Notes on using follow_redirect!
# - need to include follow_redirect! in order to redirected value through routes
# - in order for subsequent last_response.ok? assertion to pass, need to have get route available in app.rb
#   - for example, simply having "get '/age' do (line 25) and "end" (line 30) present will allow the assertion to pass

# Notes on assert(last_response.body.include?('John')) when used with follow_redirect!
# - assertion requires value to be available in redirect destination route (get '/age' do)
# - if no erb specfied in route, will obtain value via params[] (ex: backend_name_2 = params[:u_name])
# - if erb is specified in route, need to pass variable to erb (ex: locals: {u_name: backend_name_2})
#   and add value somewhere in erb (ex: via <%= u_name %>)
#   - note that if erb is specified, value can be commented out in erb and assertion will still pass

  def test_post_name
    post '/name', user_name: 'John'  # seed value - not an assertion
    # user_name trail: get_name.erb (name="user_name") > app.rb (backend_name = params[:user_name] > here
    follow_redirect!  # need to include this line to trace the value through the routes - see notes in lines 26 - 29
    assert(last_response.ok?)  # verify that the the subsequent get route is accessible, no values required to pass
    assert(last_response.body.include?('John'))  # two ways to pass assertion - see notes in lines 31- 36
  end

  def test_get_age
    # get '/age', u_name: 'JV'  # seed value - not an assertion, corresponds to backend_name_2 = params[:u_name]
    get '/age?u_name=JV'  # variation of previous line - this is what is actually appearing in browser's address field
    # u_name trail: app.rb (redirect '/age?u_name=' + backend_name)
    #   > app.rb (backend_name_2 = params[:u_name])
    assert(last_response.ok?)  # for "get '/age' do", need to retrieve something from the server to pass
    # assert(last_response.body.include?('JV'))  # reminder - body != erb body, see notes in lines 31 - 36
    assert(last_response.body.include?('Hello JV, what is your age?'))
    assert(last_response.body.include?('<form method="post" action="post_age?user_n=JV'))
    assert(last_response.body.include?('<input type="text" name="user_a">'))
  end

  # def test_post_age_multiple_values_no_redirect  # app.rb line 31 uncommented
  #   post '/post_age', user_n: 'john_v', user_a: '41'  # passing multiple values
  #   assert(last_response.ok?)
  #   assert(last_response.body.include?('john_v' && '41'))  # verifying multiple values, via assignments in app.rb lines 31 & 32
  # end

  def test_post_age_multiple_values_redirect
    # post '/post_age', user_n: 'john_v', user_a: '41'  # user_a corresponds directly to name="user_a" in input
    post '/post_age?user_n=john_v', user_a: '41'  # variation of previous line - this is what is actually appearing in browser's address field
    # user_n/user_a trail: get_age.erb (action="post_age?user_n=<%= u_name %>", name="user_a")
    #   > app.rb (backend_name_3 = params[:user_n], backend_age = params[:user_a])
    follow_redirect!  # need to include this line to trace the values through the routes - see notes in lines 26 - 29
    assert(last_response.ok?)  # verify that the the subsequent get route is accessible, no values required to pass
    assert(last_response.body.include?('john_v'))  # two ways to pass assertion - see notes in lines 31- 36
    assert(last_response.body.include?('41'))  # two ways to pass assertion - see notes in lines 31- 36
  end

  def test_get_numbers
    # get '/numbers', u_n: 'jverb', u_a: '41'   # seed value - not an assertion, corresponds to backend_name_4 = params[:u_name], etc.
    get '/numbers?u_n=jverb&u_a=41'  # variation of previous line - this is what is actually appearing in browser's address field
    # u_n/u_a trail: app.rb (redirect '/numbers?u_n=' + backend_name_3 + '&u_a=' + backend_age)
    #   > app.rb (backend_name_4 = params[:u_n], backend_age_2 = params[:u_a])
    assert(last_response.ok?)  # for "get '/numbers' do", need to retrieve something from the server to pass
    # assert(last_response.body.include?('jverb'))  # reminder - body != erb body, see notes in lines 31 - 36
    # assert(last_response.body.include?('41'))  # reminder - body != erb body, see notes in lines 31 - 36
    assert(last_response.body.include?('Hello jverb, I see you are 41.  What are your favorite numbers?'))
    assert(last_response.body.include?('<form method="post" action="post_numbers?un=jverb&ua=41">'))
    assert(last_response.body.include?('<input type="text" name="num_1">'))
    assert(last_response.body.include?('<input type="text" name="num_2">'))
    assert(last_response.body.include?('<input type="text" name="num_3">'))
  end

  # def test_post_numbers_multiple_values_no_redirect
  #   # post 'post_numbers', n: 'JCV', a: '41', num_1: '10', num_2: '20', num_3: '30'  # num_1, etc correspond directly to name="num_1" in input
  #   post '/post_numbers?un=JCV&ua=41', num_1: '10', num_2: '20', num_3: '30'  # variation of former with browser address field value
  #   # un/ua trail: get_numbers.erb (action="post_numbers?un=<%= usn %>&ua=<%= usa %>")
  #   #   > app.rb (backend_name_5 = params[:un], backend_age_3 = params[:ua])
  #   assert(last_response.ok?)
  #   assert(last_response.body.include?('Hello again JCV.'))
  #   assert(last_response.body.include?('You are 41 years old.'))
  #   assert(last_response.body.include?('Your favorite numbers are 10, 20 and 30.'))
  #   assert(last_response.body.include?('The sum of your favorite numbers is 60, which is greater than your age.'))
  # end

  def test_post_numbers_multiple_values_redirect
    # post 'post_numbers', n: 'JCV', a: '41', num_1: '10', num_2: '20', num_3: '30'  # num_1, etc correspond directly to name="num_1" in input
    post '/post_numbers?un=JCV&ua=41', num_1: '10', num_2: '20', num_3: '30'  # variation of former with browser address field value
    # un/ua trail: get_numbers.erb (action="post_numbers?un=<%= usn %>&ua=<%= usa %>")
    #   > app.rb (backend_name_5 = params[:un], backend_age_3 = params[:ua])
    follow_redirect!  # need to include this line to trace the values through the routes - see notes in lines 26 - 29
    assert(last_response.ok?)  # verify that the the subsequent get route is accessible, no values required to pass
    assert(last_response.body.include?('JCV'))  # two ways to pass assertion - see notes in lines 31- 36
    assert(last_response.body.include?('41'))  # two ways to pass assertion - see notes in lines 31- 36
    assert(last_response.body.include?('10'))  # two ways to pass assertion - see notes in lines 31- 36
    assert(last_response.body.include?('20'))  # two ways to pass assertion - see notes in lines 31- 36
    assert(last_response.body.include?('30'))  # two ways to pass assertion - see notes in lines 31- 36
  end

  def test_get_results_multiple_values_redirect
    # seed values - not an assertion, corresponds to backend_name_6 = params[:u_name], etc.
    # get '/results', n: 'Johnny', a: '41', n1: '100', n2: '200', n3: '300'
    get '/results?n=Johnny&a=41&n1=100&n2=200&n3=300'  # variation of previous line - this is what is actually appearing in browser's address field
    assert(last_response.ok?)  # for "get '/results' do", need to retrieve something from the server to pass
    assert(last_response.body.include?('Hello again Johnny.'))
    assert(last_response.body.include?('You are 41 years old.'))
    assert(last_response.body.include?('Your favorite numbers are 100, 200 and 300.'))
    assert(last_response.body.include?('The sum of your favorite numbers is 600, which is greater than your age.'))
    # how to add assertions for erb statements (i.e. lines 5 & 6 in results.erb) - fails on variables?     ?????
    # assert(last_response.body.include?('<% sum = view_n1.to_i + view_n2.to_i + view_n3.to_i %>'))
  end

end

# create tests for anything on the page that might break things
# controls (such as forms) and variables