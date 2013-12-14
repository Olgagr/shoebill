require 'shoebill/version'
require 'shoebill/utils'
require 'shoebill/routing'
require 'shoebill/file_model'
require 'shoebill/controller'
require 'shoebill/dependencies'

module Shoebill

  class Application

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
