require_relative 'test_helper'

class RouteObjectTest < RouteObject
end

class ShoebillTestRouteObject < Test::Unit::TestCase

  def setup
    @route = RouteObjectTest.new
  end

  def test_extract_options_with_hash
    assert_equal @route.send(:extract_options, {:default => [:action => 'show']}), { default: [action: 'show'] }
  end

  def test_extract_options_without_hash
    assert_equal @route.send(:extract_options), { default: {} }
  end

  def test_extract_destination
    p = proc { puts 'hello' }
    assert_equal @route.send(:extract_destination, p), p
  end

  def test_extract_destination_no_args
    assert_equal @route.send(:extract_destination), nil
  end



end
