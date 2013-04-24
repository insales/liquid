require 'test_helper'

class IfElseTagTest < Test::Unit::TestCase
  include Liquid

  def test_content_for
    tmpl = Liquid::Template.parse <<-LIQUID
main
{% content_for 'head' %}begin{% end_content_for %}
{% content_for 'footer' %}end{% end_content_for %}
    LIQUID
    context = Liquid::Context.new
    body = tmpl.render context
    assert_equal "main\n\n\n", body
    context.content_for_layout = body
    assert_template_result body, '{% yield %}', context
    assert_template_result '', '{% yield "undefined" %}', context
    assert_template_result "begin #{body} end", '{% yield "head" %} {% yield %} {% yield "footer" %}', context
  end

  def test_external_content_for
    context = Liquid::Context.new
    context.content_for_layout = 'body'
    context.content_for['head']     = 'begin'
    context.content_for['footer']   = 'end'
    assert_template_result "begin body end", '{% yield "head" %} {% yield %} {% yield "footer" %}', context
  end

  def test_expressions
    context = Liquid::Context.new
    context['var'] = 'test'
    assert_template_result '', '{% content_for var %}a{% end_content_for %}', context
    assert_equal context.content_for['test'], 'a'
    assert_template_result 'a', '{% yield var %}', context
  end

  def test_syntax
    assert_raise Liquid::SyntaxError do
      Liquid::Template.parse '{% content_for %}{% end_content_for %}'
    end
  end
end
