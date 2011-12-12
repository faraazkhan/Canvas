## lib/ritex/mathml/functions.rb -- MathML conversions of TeX markup
## "functions". See Ritex::MathML
##
## Author::    William Morgan (mailto: wmorgan-ritex@masanjin.net)
## Copyright:: Copyright 2005 William Morgan
## License::   GNU GPL version 2

class String
  ## map over the characters in a string
  def map_chars
    ret = ""
    each_byte { |b| ret += yield b.chr }
    ret
  end
end

module Ritex
module MathML

def markup *a; [:markup, a] end
def lookup *a; [:lookup, a] end
module_function :markup, :lookup

FUNCTIONS = {
  "frac" => lambda { |a, b| markup a + b, "mfrac" },
  "binom" => lambda { |a, b| markup a + b, "mfrac", 'linethickness="0"' },
  "textstyle" => lambda { |x| markup x, "mstyle", 'displaystyle="false"' },
  "displaystyle" => lambda { |x| markup x, "mstyle", 'displaystyle="true"' },
  "underset" => lambda { |a, b| markup b + a, "munder" },
  "overset" => lambda { |a, b| markup b + a, "mover" },
  "root" => lambda { |a, b| markup b + a, "mroot" },
  "sqrt" => lambda { |x| markup x, "msqrt" },
  "phantom" => lambda { |x| markup x, "mphantom" },
  "underoverset" => lambda { |a, b, c| markup c + a + b, "munderover" },
  "scriptsize" => lambda { markup x, "mstyle", 'scriptlevel="1"' },
  "scriptscriptsize" => lambda { markup x, "mstyle", 'scriptlevel="2"' },
  "textsize" => lambda { markup x, "mstyle", 'scriptlevel="0"' },

  ## not implemented stuff--just pass through for now
  "toggle" => lambda { |x| x },
  "fghighlight" => lambda { |x| x },
  "bghighlight" => lambda { |x| x },
  "tensor" => lambda { |x| x },
  "multiscripts" => lambda { |x| x },
  "statusline" => lambda { |x| x },
  "ulap" => lambda { |x| x },
  "llap" => lambda { |x| x },
  "rlap" => lambda { |x| x },
  "dlap" => lambda { |x| x },
}

{
  "vec" => "RightVector",
  "dot" => "dot",
  "ddot" => "Dot",
  "tilde" => "tilde",
  "check" => "macr",
  "hat" => "Hat",
  "bar" => "OverBar",
  "overbrace" => "OverBrace",
}.each { |k, v| FUNCTIONS[k] = lambda { |x| markup x + "<mo>&#{v};</mo>", "mover" } }

{ 
  "underbrace" => "UnderBrace"
}.each { |k, v| FUNCTIONS[k] = lambda { |x| markup x + "<mo>&#{v};</mo>", "munder" } }

%w(closure overline widebar).each { |x| FUNCTIONS[x] = FUNCTIONS["bar"] }
%w(vec tilde check hat).each { |x| FUNCTIONS["wide#{x}"] = FUNCTIONS[x] }

## "environments"--things that require strings, i.e. where spaces matter.
ENVS = {
  "text" => lambda { |x| markup x, "mtext" },
  "mathcal" => lambda { |x| markup x.map_chars { |c| "&#{c}scr;" }, "mi" },
  "mathfr" => lambda { |x| markup x.map_chars { |c| "&#{c}fr;" }, "mi" },
  "mathop" => lambda { |x| markup x, 'mo', 'lspace="0em" rspace="thinmathspace"' },
  "mathbb" => lambda { |x| markup x.map_chars { |c| "&#{c}opf;" }, "mi" },
  "href" => lambda { |x| "<mrow xlink:type=\"simple\" xlink:show=\"replace\" xlink:href=\"#{x}\">#{x}</mrow>" },
  "mathit" => lambda { |x| markup x, "mstyle", 'fontstyle="italic"' },
  "mathrm" => lambda { |x| markup x, "mstyle", 'fontstyle="normal" fontweight="normal"' },
  "mathbf" => lambda { |x| markup x, "mstyle", 'fontweight="bold"' },
  "space" => lambda { |h, d, w| "<mspace height=\".#{h}ex\"/ depth=\".#{d}ex\" width=\".#{w}em\">" },

  ## these next guys are for array options. we just treat them as environments
  ## that produce xml options for the mtable tag. so minimal checking at parse time.
  "align" => lambda { |x| "align='#{x}'" },
  "colalign" => lambda { |x| "columnalign='#{x}'" },
  "rowalign" => lambda { |x| "rowalign='#{x}'" },
  "padding" => lambda { |x| "rowspacing='#{x}' columnspacing='#{x}'" },
  "equalrows" => lambda { |x| "equalrows='#{x}'" },
  "equalcols" => lambda { |x| "equalcolumns='#{x}'" },
  "collines" => lambda { |x| "columnlines='#{x}'" },
  "rowlines" => lambda { |x| "rowlines='#{x}'" },
  "colspan" => lambda { |x| "columnspan='#{x}'" },
  "rowspan" => lambda { |x| "rowspan='#{x}'" },
  "frame" => lambda { |x| "frame='#{x}'" },

  ## cell options
  "rowspan" => lambda { |x| "rowspan='#{x}'" },
  "colspan" => lambda { |x| "columnspan='#{x}'" },
}

## TODO: collayout align equalrows equalcols rowlines collines frame padding rowopts cellopts rowspan colspan

end
end


