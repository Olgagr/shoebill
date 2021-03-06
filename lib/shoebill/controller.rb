require 'erubis'
require 'rack/request'

module Shoebill

  # Main controller class.
  class Controller

    include Shoebill::Model

    attr_reader :env, :request, :routing_params

    def initialize(env)
      @env = env
      @routing_params = {}
    end

    # Returns proper response.
    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      self.send(action)

      if get_response
        st, hd, rs = get_response.to_a
        [st, hd, [rs.body].flatten]
      else
        render(action)
      end
    end

    # Responsible for responding to request.
    def self.action(action, routing_params = {})
      proc { |env| self.new(env).dispatch(action, routing_params) }
    end

    # Renders correct template.
    def render(view_name, status = 200, headers = { 'Content-Type' => 'text/html' }, *args)
      response render_template(view_name, *args), status, headers
    end

    # Returns Rack::Request object.
    def request
      @request ||= Rack::Request.new(env)
    end

    # Returns request params merged with routing params.
    def params
      request.params.merge routing_params
    end

    private

    def response(text, status = 200, headers = {})
      raise 'Already responded!' if @response
      content = [text].flatten
      @response = Rack::Response.new(content, status, headers)
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

    def get_response
      @response
    end

  end

end