## lib/ritex/mathml/entities.rb -- MathML conversions of markup used by the parser.
## See Ritex::MathML.
##
## Author::    William Morgan (mailto: wmorgan-ritex@masanjin.net)
## Copyright:: Copyright 2005--2010 William Morgan
## License::   GNU GPL version 2

module Ritex
module MathML

## A simple mapping between markup elements used in parser.y and
## actual MathML elements.
MARKUP = {
  :subsup => "msubsup",
  :sub => "msub",
  :sup => "msup",
  :num => "mn",
  :var => "mi",
  :group => "mrow",
  :op => "mo",
  :unaryminus => ['mo', 'lspace="verythinmathspace" rspace="0em"'],
  :array => "mtable",
  :row => "mtr",
  :cell => "mtd",
  :math => ["math", 'xmlns="http://www.w3.org/1998/Math/MathML" display="inline"'],
  :displaymath => ["math", 'xmlns="http://www.w3.org/1998/Math/MathML" display="block"'],
}

end
end
