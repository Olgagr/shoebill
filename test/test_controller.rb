require_relative 'test_helper'

class TestController < Shoebill::Controller

  def show
    @some_var = 'Hello World'
  end

end

class ShoebillControllerTest < Test::Unit::TestCase

  def setup
    @env = {"GATEWAY_INTERFACE"=>"CGI/1.1", "PATH_INFO"=>"/favicon.ico", "QUERY_STRING"=>"", "REMOTE_ADDR"=>"127.0.0.1", "REMOTE_HOST"=>"localhost", "REQUEST_METHOD"=>"GET", "REQUEST_URI"=>"http://localhost:3001/favicon.ico", "SCRIPT_NAME"=>"", "SERVER_NAME"=>"localhost", "SERVER_PORT"=>"3001", "SERVER_PROTOCOL"=>"HTTP/1.1", "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/2.0.0/2013-06-27)", "HTTP_HOST"=>"localhost:3001", "HTTP_CONNECTION"=>"keep-alive", "HTTP_ACCEPT"=>"*/*", "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.57 Safari/537.36", "HTTP_ACCEPT_ENCODING"=>"gzip,deflate,sdch", "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.8,pl;q=0.6"}
    @contr = TestController.new(@env)
  end

  def test_initialize
    assert @contr.env
  end

  def test_render
    @contr.show
    File.expects(:join).returns('test/files/view.html.erb')
    assert_kind_of Rack::Response, @contr.render('view')
  end

end