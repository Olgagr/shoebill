class RouteObject

  def initialize
    @rules = []
  end

  def match(url, *args)
    options = {}
    options = args.pop if args[-1].is_a? Hash
    options[:default] ||= {}

    dest = nil
    dest = args.pop if args.size > 0
    raise 'Too many args' if args.size > 0


  end

  def check_url(url)

  end

end

module Shoebill

  class Application

    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval &block
    end

    def get_rack_app(env)
      raise 'No routes!' unless @route_obj
      @route_obj.check_url env['PATH_INFO']
    end

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