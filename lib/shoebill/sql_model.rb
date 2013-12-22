require 'sqlite3'
require 'shoebill/utils'

DB = SQLite3::Database.new 'development.rb'

module Shoebill

  # Namespace for module.
  module Model

    # Man class for SQLite model.
    class SQLite

      # Returns class underscore name
      # === Example
      #   class MyModel < SQLite
      #   end
      #
      #   MyModel.table  # returns my_model
      def self.table
        Shoebill::Utils.to_underscore name
      end

    end
  end

end