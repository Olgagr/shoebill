require 'shoebill/version'
require 'shoebill/utils'
require 'shoebill/routing'
require 'shoebill/file_model'
require 'shoebill/sql_model'
require 'shoebill/controller'
require 'shoebill/dependencies'

# The main namespace of the framework.
module Shoebill

  # The main class of the framework.
  class Application

    # The main method responsible for request responding.
    def call(env)
      klass, action = get_controller_and_action(env)
      controller = klass.new(env)
      controller.send(action)

      if controller.get_response
        st, hd, rs = controller.get_response.to_a
        [st, hd, [rs.body].flatten]
      else
        controller.render(action)
      end
    end

  end

end
