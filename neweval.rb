require 'rubygems'; require 'treetop'; require 'lib/relevance_grammar'




# def realeval(t)
#   def neweval(t, accum)
#     return if t.elements.nil?
#     children_types = t.elements.map {|e| e.extension_modules }.flatten
# 
#     # If it has children types, eval them, otherwise
#     if !children_types.empty?
#       a = []
#       t.elements.map do |e|
#         neweval(e, a)
#       end
#       accum << a
#     else
#       # Trimmed val
#       val = t.text_value.gsub(/^[ ]+|[ ]+$/, "")
# 
#       accum << val unless val.empty?
#     end
# 
#     accum
#   end
#   neweval(t, [])
# end
# 
#   
input = <<-INPUT.split("\n")
"a" == "b"
a == b
1 == 2
(1 == 2)
(1 == 2) && (2 == 3)
((1 == 2) && (2 == 3))
((1 == 2) && (2 || 3)) == a
a == ((1 == 2) && (2 || 3))
a || b || c
d && e || (f && g)
INPUT

input.each do |s|
  p RelevanceParser.new.parse(s)
end
