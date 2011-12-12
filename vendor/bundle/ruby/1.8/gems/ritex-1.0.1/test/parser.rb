## test/parser.rb -- contains Ritex::Test::Parser
## Author::    William Morgan (mailto: wmorgan-ritex@masanjin.net)
## Copyright:: Copyright 2005 William Morgan
## License::   GNU GPL version 2

require 'test/unit'
require 'ritex'

module Ritex
module Test

## Ritex unit tests for general parser behavior (i.e. those not
## directly tied to MathML output).
class Parser < ::Test::Unit::TestCase
  def setup #:nodoc:
    @p = Ritex::Parser.new :mathml
  end

  def test_invalid
    assert_raises(Ritex::Error) { @p.parse '\goaasdfdsat' }
    assert_raises(Racc::ParseError) { @p.parse '&' }
    assert_raises(Ritex::LexError) { @p.parse '$' } # lex error
  end

  def test_merror
    @p.merror = false
    assert_raises(Ritex::Error) { @p.parse '\goaasdfdsat' }
    @p.merror = true
    assert_nothing_raised(Ritex::Error) { @p.parse '\goaasdfdsat' }
    @p.merror = false
    assert_raises(Ritex::Error) { @p.parse '\goaasdfdsat' }
  end   
end

end
end
