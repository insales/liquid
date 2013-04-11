require 'test_helper'

class IfElseTagTest < Test::Unit::TestCase
  include Liquid

  def test_content_for
    tmpl = Liquid::Template.parse <<-LIQUID
main
{% content_for head %}begin{% end_content_for %}
{% content_for footer %}end{% end_content_for %}
    LIQUID
    context = Liquid::Context.new
    body = tmpl.render context
    assert_equal "main\n\n\n", body
    context.content_for[Liquid::Yield::EMPTY_YIELD_KEY] = body
    assert_template_result body, '{% yield %}', context
    assert_template_result '', '{% yield undefined %}', context
    assert_template_result "begin #{body} end", '{% yield head %} {% yield %} {% yield footer %}', context
  end
end
