require_relative 'test_helper'

class ShoebillDependeciesTest < Test::Unit::TestCase

  def test_const_missing
    Kernel.expects(:require).with('dep_me').returns(File.open('test/files/dep_me.rb'))
    obj = Object.const_missing('DepMe')
    assert_kind_of TestController, obj
  end

end