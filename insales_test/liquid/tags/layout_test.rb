require 'test_helper'

class LayoutTest < Minitest::Test
  include Liquid

  def test_set_layout
    tmpl = Liquid::Template.parse '{% layout "test" %}'
    context = Liquid::Context.new
    assert_equal context.layout, nil
    assert_equal '', tmpl.render(context)
    assert_equal context.layout, 'test'
  end

  def test_set_layout_with_variable
    tmpl = Liquid::Template.parse '{% layout var %}'
    context = Liquid::Context.new
    context['var'] = 'test'
    assert_equal context.layout, nil
    assert_equal '', tmpl.render(context)
    assert_equal context.layout, 'test'
  end
end
