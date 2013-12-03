require_relative 'test_helper'

class ShoebillDependeciesTest < Test::Unit::TestCase

  def test_const_missing
    Kernel.expects(:require).with('test_me').returns(File.new(File.join(File.dirname(__FILE__), 'files', 'test_me.rb')))
    obj = Object.const_missing('TestMe')
    assert_kind_of TestController, obj
  end

end