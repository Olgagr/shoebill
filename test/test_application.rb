require_relative 'test_helper'

class TestApp < Shoebill::Application
end

class TestController < Shoebill::Controller

  def show
    'This is a test response'
  end

end

class ShoebillAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get '/test/show'
    assert last_response.ok?
    assert_equal 'This is a test response', last_response.body
  end

  def test_routing
    env = { 'PATH_INFO' => '/test/show' }
    assert app.get_controller_and_action(env) == [TestController, 'show']
  end
end