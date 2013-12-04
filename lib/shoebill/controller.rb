require 'erubis'

module Shoebill

  class Controller

    attr_reader :env

    def initialize(env)
      @env = env
    end

    def render(view_name, locals = {})
      file_name = File.join 'app', 'views', "#{view_name}.html.erb"
      template = File.read file_name
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(env: env)
    end

  end

end