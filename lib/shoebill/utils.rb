module Shoebill

  # It contains helper method used in framework
  class Utils

    # Changes CameCase string into underscore string.
    # Additionally, it changes '::' into '/', to find diretory to the file.
    def self.to_underscore(string)
      string.gsub('::', '/').
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr('-', '_').
      downcase
    end

    # Gets underscore name from CamelCase controller name.
    def self.get_controller_name(name)
      klass = name.to_s.match(/^(.+)Controller/).captures[0]
      to_underscore klass
    end

  end

end