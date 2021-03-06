require 'sqlite3'
require 'shoebill/utils'

DB = SQLite3::Database.new 'development.db'

module Shoebill

  # Namespace for module.
  module Model

    # Main class for SQLite model.
    class SQLite

      attr_accessor :hash

      def initialize(data = nil)
        @hash = data
      end

      # Parses given values to string. If value is neither Numeric nor String, it raises an exception.
      def self.to_sql(val)
        case val
          when Numeric
            val.to_s
          when String
            "'#{val}'"
          else
            raise "Can't change #{val.class} to SQL"
        end
      end

      # Creates new record from hash of values.
      # * *Returns* :
      #   - new Shoebill::Model::SQLite object
      def self.create(values)
        values.delete 'id'
        keys = schema.keys - ['id']
        vals = keys.map do |key|
          values[key.to_sym] ? values[key.to_sym] : 'null'
        end

        DB.execute <<SQL
INSERT INTO #{table} (#{keys.join(',')})
VALUES (#{vals.map {|val| to_sql val}.join(',')});
SQL

        data = Hash[keys.zip vals]
        sql = "SELECT last_insert_rowid();"
        data['id'] = DB.execute(sql)[0][0]
        self.new data
      end

      # Returns the number of rows in table.
      def self.count
        DB.execute(<<SQL)[0][0]
SELECT COUNT(*) FROM #{table};
SQL
      end

      # Finds row by id.
      # * *Returns* :
      #   - new Shoebill::Model::SQLite object with given id
      def self.find(id)
        keys = schema.keys
        sql = "SELECT * FROM #{table} WHERE id = #{id};"
        vals = DB.execute(sql)[0]
        self.new Hash[keys.zip vals]
      end

      # Finds all models in the database.
      # * *Returns* :
      #   - array of Shoebill::Model::SQLite object
      def self.all
        keys = schema.keys
        sql = "SELECT * FROM #{table}"
        rows = DB.execute(sql)
        rows.each_with_object([]) do |r, results|
          results << self.new(Hash[keys.zip r])
        end
      end

      # Finds all models in the database by given conditions.
      # * *Returns* :
      #   - array of Shoebill::Model::SQLite object
      def self.where(conditions)
        keys = schema.keys
        sql_conditions = conditions.each_with_object([]) do |(k,v), results|
          results << "#{k} = #{to_sql v}"
        end.join(' AND ')
        sql = "SELECT * FROM #{table} WHERE #{sql_conditions}"
        rows = DB.execute(sql)

        rows.each_with_object([]) do |r, results|
          results << self.new(Hash[keys.zip r])
        end
      end

      # Allows to get and set attribute on model in Rails way.
      # === Example
      #   class Post < SQLite
      #   end
      #
      #   post = Post.find 1
      #   post.title
      #   post.title = 'Lorem ipsum'
      def method_missing(m, *args, &block)
        method_name = m.to_s.gsub(/=$/, '')
        if self.class.schema.keys.include?(method_name)
          m.to_s.match(/=$/) ? @hash[method_name] = args[0] : @hash[method_name]
        else
          super
        end
      end

      # Returns true if object responds to the given method.
      def respond_to?(m)
        if self.class.schema.keys.include?(m.to_s)
          true
        else
          super
        end
      end

      # Allows to get model by attribute.
      # === Example
      #   class Post < SQLite
      #   end
      #
      #   Post.find_by_title('Lorem ipsum')
      def self.method_missing(m, *args, &block)
        find_by_matches = /find_by_(.+)/.match m.to_s
        if find_by_matches
          find_by_attribute(find_by_matches.captures[0], args[0])
        else
          super
        end
      end

      # Returns true if class responds to the given method.
      def self.respond_to?(m)
        find_by_matches = /find_by_(.+)/.match m.to_s
        if find_by_matches && schema.keys.include?(find_by_matches.captures[0])
          true
        else
          super
        end
      end

      # Returns class underscore name.
      # === Example
      #   class MyModel < SQLite
      #   end
      #
      #   MyModel.table  # returns my_model
      def self.table
        Shoebill::Utils.to_underscore name
      end

      # Returns database schema.
      def self.schema
        return @schema if @schema
        @schema = {}
        DB.table_info(table) do |row|
          @schema[row['name']] = row['type']
        end
        @schema
      end

      # Saves model in database.
      # Throw exception if there is an error
      def save!
        unless @hash['id']
          self.class.create @hash
          return true
        end
        values_to_set = @hash.each_with_object([]) { |(k, v), result| result << "#{k} = '#{v}'" }.join(',')
        DB.execute <<SQL
UPDATE #{self.class.table}
SET #{values_to_set}
WHERE id = #{@hash['id']}
SQL
      end

      # Saves model in database.
      # Returns false if there is an error.
      def save
        self.save! rescue false
      end

      # Removes model from database.
      def destroy
        DB.execute <<SQL
DELETE FROM #{self.class.table}
WHERE id = #{@hash['id']}
SQL
      end

      private

      def self.find_by_attribute(attr, value)
        keys = schema.keys
        sql = "SELECT * FROM #{table} WHERE #{attr} = '#{value}'"
        vals = DB.execute(sql)[0]
        vals.nil? ? [] : self.new(Hash[keys.zip vals])
      end

    end
  end

end