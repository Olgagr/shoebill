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

      def self.find_all
        ids = Dir.entries('db/links').select { |f| !File.directory? f }.map { |filename| File.basename(filename, '.json').to_i }
        ids.each_with_object([]) do |id, arr|
          arr << self.find(id)
        end
      end

    end

  end

end