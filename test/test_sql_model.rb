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
    test_model = TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    assert_equal test_model.hash['submitter'], 'Olga'
  end

  def test_to_sql_numeric
    assert_kind_of String, TestModelSQL.to_sql(5)
  end

  def test_to_sql_string
    assert_equal TestModelSQL.to_sql('test'), "'test'"
  end

  def test_to_sql_raising_error
  assert_raise(RuntimeError) { TestModelSQL.to_sql Object.new }
  end

  def test_find
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    assert_equal TestModelSQL.find(1).hash['id'], 1
  end

  def test_self_respond_to
    assert TestModelSQL.respond_to?(:find_by_submitter)
  end

  def test_instance_method_missing_getter
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    model = TestModelSQL.find_by_submitter('Olga')
    assert_equal model.submitter, 'Olga'
  end

  def test_instance_method_missing_setter
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    model = TestModelSQL.find_by_submitter('Olga')
    model.submitter = 'John'
    assert_equal model.submitter, 'John'
  end

  def test_save!
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    model = TestModelSQL.find_by_submitter('Olga')
    model.submitter = 'John'
    model.save!

    model_changed = TestModelSQL.find_by_submitter('John')
    assert_equal model.id, model_changed.id
  end

  def test_destroy
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    assert_equal TestModelSQL.count, 1

    model = TestModelSQL.find 1
    model.destroy
    assert_equal TestModelSQL.count, 0
  end

  def test_all
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    TestModelSQL.create(submitter: 'Anna', link: 'http://google.pl', description: 'Lorem ipsum', posted: 1)

    models = TestModelSQL.all
    assert_equal models.size, 2
  end

  def test_all_models_values
    TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    TestModelSQL.create(submitter: 'Anna', link: 'http://google.pl', description: 'Lorem ipsum', posted: 1)

    models = TestModelSQL.all
    assert_equal models.first.submitter, 'Olga'
  end

  def test_where
    model_1 = TestModelSQL.create(submitter: 'Olga', link: 'http://google.com', description: 'Lorem ipsum', posted: 1)
    models = TestModelSQL.where(submitter: 'Olga')

    assert_equal models[0].hash, model_1.hash
  end

end