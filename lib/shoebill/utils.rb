module Shoebill

  class Utils

    def self.to_underscore(string)
      string.gsub('::', '/').
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr('-', '_').
      downcase
    end

    def self.get_controller_name(name)
      name.to_s.match(/^(.+)Controller/).captures[0].downcase
    end

  end

end