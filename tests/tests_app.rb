require 'minitest/autorun'
require 'rack/test'
require_relative '../app.rb'

class TestApp < Minitest::Test
  include Rack::Test::Methods

  def app
    PersonalDetailsApp
  end

  def test_get_entry_page
    get '/'
    assert(last_response.ok?)  # assert server response == 200
    assert(last_response.body.include?('Hello, what is your name?'))
    assert(last_response.body.include?('<form method="post" action="name">'))
    assert(last_response.body.include?('<input type="text" name="user_name">'))
  end

  def test_post_name
    post '/name', user_name: 'John'  # dummy values, corresponds to backend_name = params[:user_name]
    follow_redirect!  # need to specify to follow through route
    assert(last_response.ok?)  # for "post '/name' do", need to retrieve something from the server to pass
    assert(last_response.body.include?('John'))  # getting value via redirect in post '/name'
  end

  def test_get_age
    get '/age', u_name: 'jv'  # dummy values, corresponds to backend_name_2 = params[:u_name]
    # get '/age?user_name=jv'  # variation of previous line
    assert(last_response.ok?)  # for "get 'get_age' do", need to retrieve something from the server to pass
    assert(last_response.body.include?('jv'))
    # can now add other assertions (form, input box)
    assert(last_response.body.include?('What is your age?'))
    assert(last_response.body.include?('<form method="post" action="age">'))
    assert(last_response.body.include?('<input type="text" name="user_age">'))
  end


# create tests for anything on the page that might break things
# controls (such as forms) and variables



end



# - can run from terminal to verify that Gemfile is good:
#      bundle exec ruby tests/tests_app.rb
# - if something wrong in Gemfile will throw an error