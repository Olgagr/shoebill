module Shoebill

  # It contains helper method used in framework
  class Utils

    # Changes CameCase string into underscore string.
    # Additionally, it changes '::' into '/', to return diretory to the file.
    # === Example
    #   Utils.to_underscore(Example::CamelCase) # returns example/camel_case
    def self.to_underscore(string)
      string.gsub('::', '/').
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr('-', '_').
      downcase
    end

    # Gets underscore name controller without 'Controller' word from CamelCase controller name.
    # It is used, for example, to get views folder.
    # === Example
    #   Utils.get_controller_name(MyCustomController) # returns my_custom
    def self.get_controller_name(name)
      klass = name.to_s.match(/^(.+)Controller/).captures[0]
      to_underscore klass
    end

  end

end