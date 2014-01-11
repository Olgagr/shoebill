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

  def test_extract_url_parts
    assert_equal @route.send(:extract_url_parts, ':controller/:id/:action'), %w(:controller :id :action)
  end

  def test_combine_regexp
    assert_equal @route.send(:combine_regexp, %w(:controller :id :action), []), %w(([a-zA-Z0-9]+) ([a-zA-Z0-9]+) ([a-zA-Z0-9]+))
  end

  def test_combine_regexp_splat
    assert_equal @route.send(:combine_regexp, %w(:controller :show *), []), %w(([a-zA-Z0-9]+) ([a-zA-Z0-9]+) (.*))
  end

  def test_combine_regexp_returns_vars
    vars = []
    @route.send(:combine_regexp, %w(:controller :id :action), vars)
    assert_equal vars, %w(controller id action)
  end



end
