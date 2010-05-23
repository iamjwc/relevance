require 'rubygems'; require 'treetop'; require 'lib/relevance_grammar'; require 'lib/relevance_interpreter'; require 'ruby-debug'


# input = <<-INPUT.split("\n")
# a
# 1
# "yo"
# "a" == "b"
# a == b
# 1 == 2
# (1 == 2)
# (1 == 2) && (2 == 3)
# ((1 == 2) && (2 == 3))
# ((1 == 2) && (2 || 3)) == a
# a == ((1 == 2) && (2 || 3))
# a || b || c
# d && e || (f && g)
# d &&    e || (   f && g   )
# (((1 == 2)))
# INPUT
# 
# 
# input.each do |s|
#   st = RelevanceInterpreter.new(s)
#   p st.relevant?({:a => true, :b => false, :c => true, :d => true, :e => true, :f => true, :g => true})
#   puts
# end

