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

      def self.create(attrs)
        hash = {}
        hash['submitter'] = attrs.fetch(:submitter) { '' }
        hash['link'] = attrs.fetch(:link) { '' }
        hash['description'] = attrs.fetch(:description) { '' }

        files = Dir['db/links/*.json']
        highest = files.map { |file| file.split('/')[-1] }.map { |name| name[0...-5].to_i }.max
        id = highest + 1

        File.open("db/links/#{id}.json", 'w') do |f|
          f.write(MultiJson.dump(hash))
        end

        FileModel.new("db/links/#{id}.json")
      end

      def self.method_missing(m, *args, &block)
        if m.to_s.match(/^find_all_by_.*/)
          attribute = m.to_s.match(/^find_all_by_(.*)/).captures[0]
          STDERR.puts Dir['db/links/*.*']
          files = Dir['db/links/*'].select do |file|
            content = File.read(file)
            hash = MultiJson.load(content)
            hash[attribute] == args[0]
          end
          files.map { |f| FileModel.new(f) }
        end
      end

    end

  end

end