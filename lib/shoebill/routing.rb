module Shoebill

  class Application

    # Takes controller and action name from env variable.
    # Returns array with controller object and action name.
    def get_controller_and_action(env)
      _, controller, action, the_rest = env['PATH_INFO'].split('/', 4)
      controller = controller.capitalize
      controller += 'Controller'

      [Object.const_get(controller), action]
    end

  end

end