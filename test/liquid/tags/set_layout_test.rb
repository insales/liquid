require 'test_helper'

class SetLayoutTest < Test::Unit::TestCase
  include Liquid

  def test_set_layout
    tmpl = Liquid::Template.parse '{% set_layout test %}'
    context = Liquid::Context.new
    assert_equal context.layout, nil
    body = tmpl.render context
    assert_equal '', body
    assert_equal context.layout, 'test'
  end
end
