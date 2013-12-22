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

  def test_schema
    conn = SQLite3::Database::new 'development.db'

    conn.execute <<SQL
create table test_model_sql (
  id INTEGER PRIMARY KEY,
  posted INTEGER,
  submitter VARCHAR(50),
  link VARCHAR(100),
  description VARCHAR(32000)
);
SQL
    assert_equal TestModelSQL.schema, {
        'id' => 'INTEGER',
        'posted' => 'INTEGER',
        'submitter' => 'VARCHAR(50)',
        'link' => 'VARCHAR(100)',
        'description' => 'VARCHAR(32000)'
    }

    conn.execute <<SQL
DROP TABLE test_model_sql;
SQL
    File.delete('development.db')
  end


end