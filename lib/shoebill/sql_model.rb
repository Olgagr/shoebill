require 'sqlite3'
require 'shoebill/utils'

DB = SQLite3::Database.new 'development.rb'

module Shoebill

  module Model
    class SQLite

      def self.table
        Shoebill::Utils.to_underscore name
      end

    end
  end

end