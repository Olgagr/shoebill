require_relative 'test_helper'

class RouteObjectTest < RouteObject
end

class ShoebillTestRouteObject < Test::Unit::TestCase

  def setup
    @route = RouteObjectTest.new
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

  def test_match_rule_with_hash
    rules = @route.match '', 'quotes#index'
    assert_equal rules, [{
                             regexp: /^\/$/,
                             vars: [],
                             dest: 'quotes#index',
                             options: {
                                 default: {}
                             }
                         }]
  end

  def test_match_rule_with_proc
    p = proc { [200, {}, ['Hello, sub-app!']] }
    rules = @route.match 'sub-app', p
    assert_equal rules, [{
                             regexp: /^\/sub-app$/,
                             vars: [],
                             dest: p,
                             options: {
                                 default: {}
                             }
                         }]
  end

  def test_match_rule_with_controller_action
    rules = @route.match ':controller/:action/:id'
    assert_equal rules, [{
                             regexp: /^\/([a-zA-Z0-9]+)\/([a-zA-Z0-9]+)\/([a-zA-Z0-9]+)$/,
                             vars: %w(controller action id),
                             dest: nil,
                             options: {
                                 default: {}
                             }
                         }]
  end

  def test_match_rule_with_options
    rules = @route.match ':controller/:id', :default => [:action => 'show']
    assert_equal rules, [{
                             regexp: /^\/([a-zA-Z0-9]+)\/([a-zA-Z0-9]+)$/,
                             vars: %w(controller id),
                             dest: nil,
                             options: {
                                 default: [:action => 'show']
                             }
                         }]
  end

end
