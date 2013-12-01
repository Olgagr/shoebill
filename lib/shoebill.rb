require 'shoebill/version'
require 'shoebill/routing'
require 'shoebill/controller'
require 'shoebill/utils'

module Shoebill

  class Application

    def call(env)
      klass, action = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(action)

      [200, { 'Content-Type' => 'text/html' }, [text]]
    end

  end

end
