require "shoebill/version"

module Shoebill

  class Application

    def call(env)
      [200, { 'Content-Type' => 'text/html' }, ['Hello World from Shoebill']]
    end

  end

end
