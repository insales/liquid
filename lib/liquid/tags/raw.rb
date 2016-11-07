module Liquid
  class Raw < Block
    Syntax = /\A\s*\z/
    FullTokenPossiblyInvalid = /\A(.*)#{TagStart}\s*(\w+)\s*(.*)?#{TagEnd}\z/om

    def initialize(tag_name, markup, parse_context)
      super

      ensure_valid_markup(tag_name, markup, parse_context)
    end

    def parse(tokens)
      @body = ''
      while token = tokens.shift
        if token =~ FullTokenPossiblyInvalid
          @body << $1 if $1 != "".freeze
          return if block_delimiter == $2
        end
        @body << token unless token.empty?
      end

      raise SyntaxError.new("'#{block_name}' tag was never closed")
    end

    def render(_context)
      @body
    end

    def nodelist
      [@body]
    end

    def blank?
      @body.empty?
    end

    protected

    def ensure_valid_markup(tag_name, markup, parse_context)
      unless markup =~ Syntax
        raise SyntaxError.new("Syntax Error in '#{tag_name}' - Valid syntax: #{tag_name}")
      end
    end
  end

  Template.register_tag('raw'.freeze, Raw)
end
