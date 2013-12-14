require 'erubis'
require 'shoebill/file_model'
require 'rack/request'

module Shoebill

  class Controller

    include Shoebill::Model

    attr_reader :env, :request

    def initialize(env)
      @env = env
    end

    def response(text, status = 200, headers = {})
      raise 'Already responded!' if @response
      content = [text].flatten
      @response = Rack::Response.new(content, status, headers)
    end

    def get_response
      @response
    end

    def render(view_name, status = 200, headers = { 'Content-Type' => 'text/html' }, *args)
      response render_template(view_name, *args), status, headers
    end

    def render_template(*args)
      file_name = File.join 'app', 'views', "#{Shoebill::Utils.get_controller_name(self.class)}", "#{args[0].to_s}.html.erb"
      template = File.read file_name
      eruby = Erubis::Eruby.new(template)
      eruby.result get_instance_variables
    end

    def get_instance_variables
      symbols = self.instance_variables
      Hash[symbols.zip(symbols.map { |sym| self.instance_variable_get sym })]
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params
    end

  end

end