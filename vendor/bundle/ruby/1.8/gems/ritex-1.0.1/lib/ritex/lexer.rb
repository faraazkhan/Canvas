## lib/ritex/lexer.rb -- contains Ritex::Lexer
## Author::    William Morgan (mailto: wmorgan-ritex@masanjin.net)
## Copyright:: Copyright 2005--2010 William Morgan
## License::   GNU GPL version 2

require 'racc/parser' # just for Racc::ParseError

module Ritex

## Thrown by Lexer upon lexing errors. 
class LexError < StandardError; end

## The lexer splits an input stream into tokens. These are handed to the
## parser. Ritex::Parser takes care of setting up and configuring the
## lexer.
##
## In order to support macros, the lexer maintains a stack of strings.
## Pushing a string onto the stack will cause #lex to yield tokens from
## that string, until it reaches the end, at which point it will discard
## the string and resume yielding tokens from the previous string.
##
## To handle macros, the lexer is stateful. Normally it ignores all
## spacing. After hitting an ENV token it will start returning SPACE
## tokens for each space until it hits a '}'.
class Lexer
  TOKENS = '+-\/\*|\.,;:<>=()#&\[\]^_!?~%\'{} ' # passed as themselves
  OPERATOR_TOKENS = ' ,' # things that can be \'d to become operators
  WORDS = %w(array arrayopts define left right rowopts cellopts colalign rowalign align padding equalcols equalrows rowlines collines
             frame rowspan colspan) # passed as special tokens

  WORDS_SEARCH = WORDS.map { |w| [/\A\\(#{Regexp.escape w})\b/, w.upcase.intern] }

  ## _s_ is an initial string to push on the stack, or nil.
  def initialize parser, s = nil
    @parser = parser
    @s = []
    push s unless s.nil?
  end

  ## push an additional string on to the stack.
  def push s; @s.unshift [s, 0]; end

  ## Yield token and value pairs from the string stack.
  def lex #:yields: token, value
    ## actually this function does nothing right now except call
    ## lex_inner. if we switch to more stateful tokenization this
    ## might do something more.
    lex_inner do |sym, val|
      yield [sym, val]
    end
  end

  ## For debugging purposes.
  def dlex #:nodoc: 
    while true
      lex do |sym, val|
        puts "GOT: #{sym} => #{val.inspect}"
        return unless sym
      end
    end
  end

private

  def lex_inner
    state = :normal

    until @s.empty?
      s, i = @s.first
      if i >= s.length
        @s.shift
        next
      end

      next if WORDS_SEARCH.any? do |regex, token|
        if s[i .. -1] =~ regex
          name = $1
          @s.first[1] += name.length + 1
          yield [token, name]
          state = :env if @parser.envs.member?(name)
          true
        end
      end

      case s[i .. -1]
      when /\A(\s+)/
        @s.first[1] += $1.length
        yield [:SPACE, $1] if state == :env
      when /\A([#{TOKENS}])/
        @s.first[1] += 1
        state = :normal if (state == :env) && ($1 == '}')
        yield [$1, $1]
      when /\A(\\\\)/
        @s.first[1] += $1.length
        yield [:DOUBLEBACK, $1]
      when /\A\\([#{OPERATOR_TOKENS}])/
        @s.first[1] += $1.length + 1
        yield [:OPERATOR, $1]
      when /\A\\([#{TOKENS}\\\\])/
        @s.first[1] += $1.length + 1
        yield [:SYMBOL, $1]
      when /\A\\([a-zA-Z][a-zA-Z*\d]*)/
        name = $1
        type = :SYMBOL
        if @parser.funcs.member? name
          proc = @parser.funcs[name]
          type = [:FUNC0, :FUNC1, :FUNC2, :FUNC3][proc.arity]
          raise LexError, "functions of arity '#{proc.arity}' unsupported" if type.nil?
        elsif @parser.envs.member? name
          type = :ENV
          state = :env
        elsif @parser.macros.member? name
          proc = @parser.macros[name]
          type = [:MACRO0, :MACRO1, :MACRO2, :MACRO3][proc.arity]
          raise LexError, "macro of arity '#{proc.arity}' unsupported" if type.nil?
        end
        @s.first[1] += $1.length + 1
        yield [type, name]
      when /\A(-?(\d+|\d*\.\d+))/
        @s.first[1] += $1.length
        yield [:NUMBER, $1]
      when /\A([a-zA-Z]+)/
        @s.first[1] += $1.length
        yield [:VAR, $1]
      else
        raise LexError, "unlexable at position #{i}: #{s[i .. [s.length, i + 20].min]}"
      end
    end

    yield [false, false] # done!
  end
end
end
