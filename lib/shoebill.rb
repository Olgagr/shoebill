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
      text = controller.send(action)

      if controller.get_response
        st, hd, rs = controller.get_response.to_a
        [st, hd, [rs.body].flatten]
      else
        [200, { 'Content-Type' => 'text/html' }, [text]]
      end
    end

  end

end
