require_relative 'test_helper'

class TestModelSQL < Shoebill::Model::SQLite
end

class ShoebillTestModel < Test::Unit::TestCase

  def setup
    @model = TestModelSQL.new

    @conn = SQLite3::Database::new 'development.db'

    @conn.execute <<SQL
create table test_model_sql (
  id INTEGER PRIMARY KEY,
  posted INTEGER,
  submitter VARCHAR(50),
  link VARCHAR(100),
  description VARCHAR(32000)
);
SQL
  end

  def teardown
    @conn.execute <<SQL
DROP TABLE test_model_sql;
SQL
  end

  def test_table
    assert_equal TestModelSQL.table, 'test_model_sql'
  end

  def test_schema
    assert_equal TestModelSQL.schema, {
        'id' => 'INTEGER',
        'posted' => 'INTEGER',
        'submitter' => 'VARCHAR(50)',
        'link' => 'VARCHAR(100)',
        'description' => 'VARCHAR(32000)'
    }
  end

  def test_create
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)

    assert_equal TestModelSQL.count, 2
  end

  def test_to_sql_numeric
    assert_kind_of String, TestModelSQL.to_sql(5)
  end

  def test_to_sql_string
    assert_equal TestModelSQL.to_sql('test'), 'test'
  end

  def test_to_sql_raising_error
   assert_raise(RuntimeError) { TestModelSQL.to_sql Object.new }
  end

  def test_find
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    assert_equal TestModelSQL.find(1).hash['id'], 1
  end

end