require 'sqlite3'
require 'shoebill/utils'

DB = SQLite3::Database.new 'development.db'

module Shoebill

  # Namespace for module.
  module Model

    # Man class for SQLite model.
    class SQLite

      def initialize(data = nil)
        @hash = data
      end

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

      def self.count
        DB.execute(<<SQL)[0][0]
SELECT COUNT(*) FROM #{table};
SQL
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