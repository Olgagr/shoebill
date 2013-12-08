require 'multi_json'

module Shoebill

  module Model

    class FileModel

      attr_accessor :hash

      def initialize(filename)
        @filename = filename
        @id = File.basename(filename, '.json').to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        hash[name.to_s]
      end

      def []=(name, value)
        hash[name.to_s] = value
      end

      def self.find(id)
        FileModel.new("db/links/#{id}.json") rescue nil
      end

    end

  end

end