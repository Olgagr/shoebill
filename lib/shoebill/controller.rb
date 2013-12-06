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
      eruby.result get_instance_variables
    end

    def get_instance_variables
      symbols = self.instance_variables
      Hash[symbols.zip(symbols.map { |sym| self.instance_variable_get sym })]
    end

  end

end