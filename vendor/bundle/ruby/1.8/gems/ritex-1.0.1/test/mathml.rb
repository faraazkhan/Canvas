## test/mathml.rb -- contains Ritex::Test::MathML
## Author::    William Morgan (mailto: wmorgan-ritex@masanjin.net)
## Copyright:: Copyright 2005--2010 William Morgan
## License::   GNU GPL version 2

require 'test/unit'
require 'yaml'
require 'ritex'

module Ritex

## Module for all Ritex unit tests.
module Test

## Ritex unit tests for WebTeX->MathML conversion.
##
## Tests are run with a simple call to #cmp, e.g.:
##   cmp '\int_{x=0}^1 \alpha(x)' 
##
## Test answers are loaded from the KEY file.
##
## If an answer is not in the KEY file (e.g. you've just added a test, this
## package will attempt to call the BIN program below to find the "correct"
## answer. This answer will be placed in the KEY file, which you can then edit
## as necessary.
class MathML < ::Test::Unit::TestCase
  KEY = "test/answer-key.yaml"
  BIN = "./itex2MML --inline" # for quickly generating possible answers to new tests

  def setup #:nodoc:
    @p = Ritex::Parser.new :mathml
    @key = if File.exists?(KEY)
      YAML::load_file(KEY).inject({}) { |h, (k, v)| h[k] = v; h }
    else
      {}
    end
    @key_dirty = false
  end

  def teardown #:nodoc:
    if @key_dirty
      File.open(KEY, "wb") { |f| f.puts @key.sort_by { |a, b| [a, b] }.to_yaml }
      @key_dirty = false
    end
  end

  ## Tests whether a webtex string is converted correctly.
  ##
  ## If _same_as_ is given, it means the conversion of _s_ should be the same
  ## as _same_as_. This is useful for macros and other features unsupported
  ## by the binary answer-key generator.
  def cmp s, same_as=nil
    gold = gold_standard(same_as || s)
    test = @p.parse s, :nowrap => true

    assert_equal gold.gsub('"', "'"), test.gsub('"', "'"), "Difference in MathML output of #{s.inspect}"
  end

  ## compare in raw mode
  def cmp_raw s, gold
    @raw_parser ||= Ritex::Parser.new :raw
    x = @raw_parser.parse s
    assert_equal gold, x
  end

  ## fix up itex2MML's common known errors
  def fix_itex2mml_output l
    l.gsub(/<mi>&(lt|gt);<\/mi>/, "<mo>&\\1;</mo>").
      gsub("<merror><mtext>Unknown character</mtext></merror>", "<mspace width='mediummathspace'/>")
  end

  ## normalize itex2MML output to make it more like mine, for comparison purposes
  def normalize_itex2mml_output l
    l.gsub("-", "&minus;").
      gsub(/>[\s\n]+</, "><").
      gsub(/>(\d+)\s+/, ">\\1").
      gsub(%r!<mspace (.*?)></mspace>!, "<mspace \\1/>")
  end

  ##### and now, the tests! #####

  def test_grouping
    cmp 'x'
    cmp '{x}'
  end

  def test_environments
    cmp 'if'
    cmp '\text{if}'
    cmp '\text{ if }'
    cmp '\text{if \alpha}'
    cmp '\mathbb{Hello}'
    cmp '\mathcal{Hello}'
  end

  def test_vars
    cmp '\alpha'
    cmp 'a+3'
    cmp '\alpha + b + c'
  end

  def test_funcs
    cmp '\sqrt{i}'
    cmp '\frac{1}{2}'
    cmp '\binom{x}{2}'
    cmp '\root{3}{x+y}'
  end

  def test_scripts
    cmp 'a^b'
    cmp 'a_b'
    cmp 'a^b_c'
  end

  def test_ops
    cmp 'a\in S'
  end

  def test_lim
    cmp '\lim_3'
    cmp '\lim_{x\to\infty}f(x)=0'
  end

  def test_displaystyle
    cmp 'x\textstyle{\int_0^1}\displaystyle{\int_0^1}y'
  end

  def test_spacing
    cmp 'a ^ b'
    cmp '\define   { \goat  }{3+4}', ''
    cmp 'a\text{if}b'
    cmp 'a\text{if }b'
    cmp 'a\text{ if}b'
    cmp 'a\text{ if }b'
    cmp 'a\text{ if a fd ew s }b'
    cmp ' a'
    cmp '  a'
    cmp '\forall x\,x<0'
    cmp '\int_x f(x)\ dx'
    cmp ','
    cmp '\,'
    cmp ',\,\,,,\,'
  end
  
  def test_escaping
    cmp 'a < b'
  end

  def test_larger
    cmp 'a^{b_c} < a^b_c'
  end

  def test_fonts
    cmp 'a\mathbb{GOAT}'
  end

  def test_leftright
    cmp '\left ( \binom{2}{3} \right )'
  end

  def test_misc
    cmp '\ln x'
    cmp "100!"
  end

  def test_multiline
    cmp '\mathop{monkey}
         <
         b'
  end

  def test_delimiters
    cmp '(\hat{x}) = {(\hat{x}})'
    cmp '\left ( x \right )'
    cmp '\left \{ x \right \}'
    cmp '\left ( \frac{2}{4+x} \right )^3'
    cmp '\left \frac{x}{y} \right|_{x=0}'
  end

  def test_elided_delimiters
    cmp '\left ( x \right', '\left ( x \right'
    cmp '\left ( x \right + 3', '\left ( x \right + 3'
  end

  def test_arrays
    cmp '\array{1}'
    cmp '\array{1 & 0}'
    cmp '\array{1 & 0 \\\\ 0 & 1}'
    cmp '\array{1 & 0 \\\\
                0 & 1}'
  end

  def test_real_life
    cmp 'a = -3'
    cmp '\Pr(a < X \leq b) = \int_a^b f(x)\ dx'
    cmp '\int_{-\infinity}^\infinity f(x)\ dx = 1'
    cmp 'F(x) = \Pr(X \leq x)\ \text{for}\ -\infinity < x < \infinity'
    cmp 'G^{-1}(x) = -\log(1 - x)/\lambda\text{ if } 0 < x < 1.'
    cmp '-\log(1 - X)/\lambda'
    cmp 'P(x) = P^*(x)/Z'
    cmp '\sum_{n=1}^\infty \frac{(-1)^n}{n} = \ln 2'
    cmp '\sum_{n=1}^\infty \frac{1}{n} \text{ is divergent, but } \lim_{n \to \infty} \sum_{i=1}^n \frac{1}{i} - \ln n \text{ exists.}'
    cmp 'G(y) = \left\{\array{ 1 - e^{-\lambda y} & \text{ if } y \geq 0 \\\\
                               0                  & \text{ if } y < 0 }\right.'
    cmp '\define{\sampx}{x^{(r)}}
         \frac{1}{N} \sum_r \phi(\sampx)', '\frac{1}{N} \sum_r \phi({x^{(r)}})'
    cmp '\frac{\sum_r w_r \phi(\sampx)}{\sum_r w_r}', '\frac{\sum_r w_r \phi({x^{(r)}})}{\sum_r w_r}'
    cmp 'w_r \equiv \frac{P^*(\sampx)}{Q^*(\sampx)}.', 'w_r \equiv \frac{P^*({x^{(r)}})}{Q^*({x^{(r)}})}.'
  end

  def test_overs
    %w(hat bar dot ddot vec check).each { |x| cmp "\\#{x}{x}" }
    cmp '\overset{\text{n terms}}{\overbrace{1+2+\cdots+n}}'
    cmp '\underoverset{S}{\alpha}{x=\infty}'
  end
  
  def test_macros
    cmp '\define{\goat}{\mathbb{GOAT}}', ''
    cmp '\goat_3', '{\mathbb{GOAT}}_3'
    cmp '\define{\boat}[1]{#1-x}', ''
    cmp '\boat{y}', '{y-x}'
    cmp '\boat{\boat{N}}', '{{N-x}-x}'
    cmp '\boat{\boat{\boat{N}}}', '{{{N-x}-x}-x}'
    cmp '\frac{\boat{N}}{2}', '\frac{{N-x}}{2}'
    cmp '\define{\float}[2]{\frac{\alpha-#1}{\beta-#2}}', ''
    cmp '\float{\delta}{\gamma}', '{\frac{\alpha-\delta}{\beta-\gamma}}'
    cmp '\float{\goat}{\boat{\goat}}', '{\frac{\alpha-{\mathbb{GOAT}}}{\beta-{{\mathbb{GOAT}}-x}}}'
  end

  def test_macros_in_raw_mode
    cmp_raw '\define{\goat}{\mathbb{GOAT}}', ''
    cmp_raw '\goat_3', '{\mathbb{GOAT}}_3'
    cmp_raw '\define{\boat}[1]{#1-x}', ''
    cmp_raw '\boat{y}', '{y-x}'
    cmp_raw '\boat{\boat{N}}', '{{N-x}-x}'
    cmp_raw '\boat{\boat{\boat{N}}}', '{{{N-x}-x}-x}'
    cmp_raw '\frac{\boat{N}}{2}', '\frac{{N-x}}{2}'
    cmp_raw '\define{\float}[2]{\frac{\alpha-#1}{\beta-#2}}', ''
    cmp_raw '\float{\delta}{\gamma}', '{\frac{\alpha-\delta}{\beta-\gamma}}'
    cmp_raw '\float{\goat}{\boat{\goat}}', '{\frac{\alpha-{\mathbb{GOAT}}}{\beta-{{\mathbb{GOAT}}-x}}}'
  end

  def test_more_macros
    cmp '\define{\exp}[1]{E_\theta\left[#1\right]} \exp{\hat{\theta}}', '{E_\theta\left[\hat{\theta}\right]}'
  end

  def test_unary_minus
    cmp '-x'
    cmp 'x - x'
    cmp 'x--x'
    cmp 'x + - x'
    cmp '\alpha - x'
    cmp '-1'
    cmp "a-b"
    cmp "a=-b"

    cmp '-\infty'
    cmp '\ -\infty'
    cmp '\text{for}\ -\infty'
  end

  def test_arrayopts
    cmp '\array{ \arrayopts{\colalign{left center right}} a & b & c \\\\ 100000 & 100000 & 10000}'
    cmp '\array{ \arrayopts{\colalign{left}} a & b & c \\\\ 100000 & 100000 & 10000}'
    cmp '\array{ \arrayopts{\rowalign{top center bottom}} \binom{\alpha}{\omega} & a & b \\\\ \frac{3}{4} & c & d \\\\ \int_0^1 & e & f}'
    cmp '\array{ \arrayopts{\rowalign{top}} \binom{\alpha}{\omega} & a & b \\\\ \frac{3}{4} & c & d \\\\ \int_0^1 & e & f}'
    cmp '\array{\arrayopts{\frame{solid}} a}'
    cmp '\array{\arrayopts{\padding{20}} a & b & c \\\\ d & e & f \\\\ \alpha & \beta & \gamma}'
    cmp '\array{\arrayopts{\equalrows{true}} a}'
    cmp '\array{\arrayopts{\equalcols{true}} a}'
    cmp '\array{\arrayopts{\rowlines{solid}} a}'
    cmp '\array{\arrayopts{\collines{solid}} a}'
    cmp '\array{\cellopts{\rowspan{2}} a & b \\\\ c}'
    cmp '\array{\rowspan{2} a & b \\\\ c}'
    cmp '\array{\cellopts{\colspan{2}} a \\\\ b & c}'
    cmp '\array{\colspan{2} a \\\\ b & c}'

    cmp '\array{ (1,1) & \rowspan{2} \int dx & (1,3) \\\\
                 (2,1) &                       (2,3) \\\\
                 (3,1) & (3,2)               & (3,3) }'

    cmp '\array{  \colspan{3} (1,1) \text{ to } (1,3) & (1,4) \\\\
                     (2,1)  &   (2,2)   &   (2,3)    & (2,4)  }'
  end

private

  ## Returns the correct translation of _s_, by looking in the key
  ## file or, if that fails, by calling itex2mml directly.
  def gold_standard s
    return @key[s] if @key.member? s

    ## not in key; try and run BIN to generate the answer
    ret = IO.popen(BIN, "wb+") do |io|
      io.puts s.gsub(/&/, "&amp;").gsub(/</, "&lt;").gsub(/>/, "&gt;")
      io.close_write
      io.readlines.join
    end
    ret = ret.chomp.gsub(%r!^<math xmlns='http://www.w3.org/1998/Math/MathML'.*?>!, "").gsub(%r!</math>$!, "")
    ret = normalize_itex2mml_output(fix_itex2mml_output(ret))

    if ENV["ALLOW_OVERRIDE"]
      test = Ritex::Parser.new.parse s, :nowrap => true

      if ret.gsub('"', "'") != test.gsub('"', "'")
        puts
        puts " input: #{s}"
        puts "output: #{test}"
        puts "answer: #{ret}"
        print "correct? "
        if gets =~ /y/i
          ret = test
        end
      end
    end

    @key_dirty = true
    @key[s] = ret
  end
end
end
end
