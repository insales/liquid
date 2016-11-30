require 'test_helper'

#
# По факту, тег `content_for` нужен только для мутаций в контексте.
# Аналогично работе тега `assign`, но в отличие от `assign` он проставляет
# значения хешу внутри Context (см. опредление тега `content_for`), которые
# используются потом тегом `yield`.
#
class ContentForTest < Minitest::Test
  include Liquid

  BASIC_CODE = "{% content_for 'head' %}begin{% end_content_for %}\n" \
               "body\n" \
               "{% content_for 'footer' %}end{% end_content_for %}".freeze
  COMPLEX_CODE = "{% content_for 'head' %}{% for i in (1..5) %}{{i}}{% endfor %}{% end_content_for %}\n" \
                 "{% content_for 'footer' %}{{ 'END' | downcase }}{% end_content_for %}".freeze

  def setup
    @context = Liquid::Context.new
  end

  def test_that_tag_renders_no_output
    assert_template_result "outside",
                           "out{% content_for 'test' %}bla-bla{% end_content_for %}side",
                           @context
  end

  def test_that_tag_mutates_context_content_for_hash
    Liquid::Template.parse(BASIC_CODE).render(@context)
    assert_equal('begin', @context.content_for['head'])
    assert_equal('end', @context.content_for['footer'])
  end

  def test_that_tag_renders_body_before_saving_it_in_context
    Liquid::Template.parse(COMPLEX_CODE).render(@context)
    assert_equal('12345', @context.content_for['head'])
    assert_equal('end', @context.content_for['footer'])
  end

  def test_that_tag_accepts_expressions_as_arguments
    @context['var'] = 'test'
    assert_template_result '', '{% content_for var %}VALUE{% end_content_for %}', @context
    assert_equal 'VALUE', @context.content_for[@context['var']]
  end

  def test_syntax
    assert_raises Liquid::SyntaxError do
      Liquid::Template.parse '{% content_for %}{% end_content_for %}'
    end
  end
end
