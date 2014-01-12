require 'shoebill/version'
require 'shoebill/utils'
require 'shoebill/routing'
require 'shoebill/sql_model'
require 'shoebill/controller'
require 'shoebill/dependencies'

# The main namespace of the framework.
module Shoebill

  # The main class of the framework.
  class Application

    # The main method responsible for request responding.
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      rack_app = get_rack_app(env)
      rack_app.call(env)

    end

  end

end
