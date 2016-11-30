require 'test_helper'

class YieldTest < Minitest::Test
  include Liquid

  def setup
    @context = Liquid::Context.new
  end

  # yield tag should just use values from Context#content_for hash
  def test_basic_behavior
    @context.content_for['header'] = header = 'My header'
    @context.content_for_layout = content = 'TROLOLO'

    assert_template_result "#{header}CONTENT:#{content}",
                           '{% yield "header" %}CONTENT:{% yield %}{% yield "undefined" %}',
                           @context
  end

  def test_that_tag_renders_nothing_when_value_for_key_not_set
    @context.content_for['defined'] = defined = 'boom'

    assert_template_result "defined: #{defined} undefined: ",
                           'defined: {% yield "defined" %} undefined: {% yield "not_defined" %}',
                           @context
  end

  def test_that_empty_yield_renders_context_content_for_layout
    @context.content_for_layout = 'CONTENT'
    assert_template_result('CONTENT', '{% yield %}', @context)
  end

  def test_that_tag_accepts_expressions_as_arguments
    key = 'some_key'
    value = 'SOME VALUE'
    @context['var'] = key
    @context.content_for[key] = value

    assert_template_result value, '{% yield var %}', @context
    assert_template_result value, "{% yield '#{key}' %}", @context
  end
end
