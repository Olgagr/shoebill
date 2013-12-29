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
            "#{val}"
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
          values[key] ? to_sql(values[key]) : 'null'
        end

        DB.execute <<SQL
INSERT INTO #{table} (#{keys.join(',')})
VALUES (#{vals.join(',')});
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

      # Find row by id.
      # * *Returns* :
      #   - new Shoebill::Model::SQLite object with given id
      def self.find(id)
        keys = schema.keys
        sql = "SELECT * FROM #{table} WHERE id = #{id};"
        vals = DB.execute(sql)[0]
        data = Hash[keys.zip vals]
        self.new data
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

    end
  end

end