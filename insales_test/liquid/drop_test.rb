require 'test_helper'

class EnumerableDrop < Liquid::Drop
  include Enumerable
end

class DropsTest < Minitest::Test
  include Liquid

  def test_enumerable_drop_blacklists_include_method
    refute(EnumerableDrop.invokable?('include?'), 'Expected method :include? to be blacklisted on Drop with Enumerable')
  end
end
