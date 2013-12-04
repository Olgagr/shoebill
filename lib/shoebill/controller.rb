require 'erubis'

module Shoebill

  class Controller

    attr_reader :env

    def initialize(env)
      @env = env
    end

    def render(view_name, locals = {})
      file_name = File.join 'app', 'views', "#{Shoebill::Utils.get_controller_name(self.class)}", "#{view_name.to_s}.html.erb"
      template = File.read file_name
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(env: env)
    end

  end

end