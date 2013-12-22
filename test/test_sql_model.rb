require_relative 'test_helper'

class TestModelSQL < Shoebill::Model::SQLite
end

class ShoebillTestModel < Test::Unit::TestCase

  def setup
    @model = TestModelSQL.new
  end

  def test_table
    assert_equal TestModelSQL.table, 'test_model_sql'
  end


end