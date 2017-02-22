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
    assert(last_response.ok?)
    assert(last_response.body.include?('Hello, what is your name?'))
    assert(last_response.body.include?('<input type="text" name="name">'))
  end




end



# - can run from terminal to verify that Gemfile is good:
#      bundle exec ruby tests/tests_app.rb
# - if something wrong in Gemfile will throw an error