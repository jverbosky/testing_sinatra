require 'minitest/autorun'
require 'rack/test'
require_relative '../app.rb'

class TestApp < Minitest::Test



end



# - can run from terminal to verify that Gemfile is good:
#      bundle exec ruby tests/tests_app.rb
# - if something wrong in Gemfile will throw an error