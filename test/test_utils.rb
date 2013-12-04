require_relative 'test_helper'

class TestShoebillUtils < Shoebill::Utils
end

class ShoebillUtilsTest < Test::Unit::TestCase

  def test_to_underscore
    assert_equal Shoebill::Utils.to_underscore('Tests::TestController'), 'tests/test_controller'
  end

  def test_get_controller_name
    assert_equal Shoebill::Utils.get_controller_name('CommentsController'), 'comments'
  end

end