require_relative 'test_helper'

class ShoebillDependeciesTest < Test::Unit::TestCase

  def const_missing_test
    obj = Object.const_missing('TestController')
    assert_kind_of TestController, obj
  end

end