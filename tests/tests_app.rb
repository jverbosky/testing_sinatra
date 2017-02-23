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
    post '/name', user_name: 'John'  # seed value - not an assertion, corresponds to backend_name = params[:user_name]
    follow_redirect!  # need to include this line to trace the value through the routes - see notes in lines 26 - 29
    assert(last_response.ok?)  # for "post '/name' do", need to retrieve something from the server to pass
    assert(last_response.body.include?('John'))  # two ways to pass assertion - see notes in lines 31- 36
  end

  def test_get_age
    get '/age', u_name: 'jv'  # seed value - not an assertion, corresponds to backend_name_2 = params[:u_name]
    # get '/age?user_name=jv'  # variation of previous line since we're using a redirect
    assert(last_response.ok?)  # for "get 'get_age' do", need to retrieve something from the server to pass
    assert(last_response.body.include?('jv'))  # reminder - body != erb body, see notes in lines 31 - 36
    assert(last_response.body.include?('What is your age?'))
    assert(last_response.body.include?('<form method="post" action="age">'))
    assert(last_response.body.include?('<input type="text" name="user_age">'))
  end

  def test_post_age
    # post '/post_age', user_age: '41'
    # assert(last_response.ok?)
    post '/post_age', user_n: 'john_v'
    assert(last_response.ok?)
    assert(last_response.body.include?('john_v'))
  end


# create tests for anything on the page that might break things
# controls (such as forms) and variables



end



# - can run from terminal to verify that Gemfile is good:
#      bundle exec ruby tests/tests_app.rb
# - if something wrong in Gemfile will throw an error