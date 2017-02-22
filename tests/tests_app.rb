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
    assert(last_response.body.include?('<input type="text" name="name">'))
    assert(last_response.body.include?('<form method="post" action="name">'))
  end

  def test_post_name
    post '/name', name: 'John'  # corresponds to name = params[:name]
    follow_redirect!  # need to specify to follow through route
    assert(last_response.ok?)
    assert(last_response.body.include?('John'))  # getting value via redirect in post '/name'
  end

  # def test_get_age
  #   get '/age', user_name: 'jv'
  #   # get '/age?user_name=jv'  # variation of previous line
  #   assert(last_response.ok?)
  #   assert(last_response.body.include?('jv'))
  #   # can now add other assertions (form, input box)
  #   # assert(last_response.body.include?('What is your name?'))
  #   # assert(last_response.body.include?('<input type="text" name="name">'))
  #   # assert(last_response.body.include?('<form method="post" action="name">'))
  # end


# create tests for anything on the page that might break things
# controls (such as forms) and variables


end



# - can run from terminal to verify that Gemfile is good:
#      bundle exec ruby tests/tests_app.rb
# - if something wrong in Gemfile will throw an error