require "shoebill/version"

module Shoebill

  class Application

    def call(env)
      STDERR.puts env
      [200, { 'Content-Type' => 'text/html' }, ['Hello World from Shoebill']]
    end

  end

end
