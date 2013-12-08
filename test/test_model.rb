require_relative 'test_helper'

class TestModel < Shoebill::Model::FileModel
end

class ShoebillTestModel < Test::Unit::TestCase

  def setup
    @model = TestModel.new('test/files/1.json')
  end

  def test_initialize
    assert_equal @model.hash, {
        'submitter' => 'Olga',
        'link' => 'http://www.rubytapas.com',
        'description' => 'The best screencasts about Ruby',
    }
  end

  def test_setting_value_on_hash
    @model.hash['description'] = 'The best screencasts about Ruby. I must watch it regularly.'
    assert_equal @model.hash['description'], 'The best screencasts about Ruby. I must watch it regularly.'
  end

  def test_getting_value_from_hash
    assert_equal @model.hash['submitter'], 'Olga'
  end

  def test_finding_file
    Shoebill::Model::FileModel.expects(:new).returns(@model)
    assert_kind_of Shoebill::Model::FileModel, TestModel.find(1)
  end

  def test_not_finding_file
    Shoebill::Model::FileModel.expects(:new).returns(nil)
    assert_equal TestModel.find(2), nil
  end

end