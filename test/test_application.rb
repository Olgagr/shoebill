require_relative 'test_helper'

class TestApp < Shoebill::Application
end

class ShoebillAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get '/'
    assert last_response.ok?
    assert_equal 'Hello World from Shoebill', last_response.body
  end
end