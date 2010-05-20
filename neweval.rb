require 'rubygems'; require 'treetop'; require 'lib/relevance_grammar'; require 'ruby-debug'

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

class Rel
  def initialize(tree)
    @tree = tree
  end

  def op_predicate(op)
    case op
      when '==' then lambda {|a,b| a.call() == b.call()}
      when '!=' then lambda {|a,b| a.call() != b.call()}
      when '>=' then lambda {|a,b| a.call() >= b.call()}
      when '<=' then lambda {|a,b| a.call() <= b.call()}
      when '>'  then lambda {|a,b| a.call() >  b.call()}
      when '<'  then lambda {|a,b| a.call() <  b.call()}
      when '&&' then lambda {|a,b| a.call() && b.call()}
      when '||' then lambda {|a,b| a.call() || b.call()}
    end
  end

  def evaluate(env)
    def e(tree, env)
      p tree
      a,op,b,*rest = tree


      if op.nil?
        # Only one item in the stack.
        if a.is_a? Array
          # 'a' is an expression
          e(a, env)
        elsif a.is_a? Symbol
          # 'a' is a variable name
          env[a]
        else
          # 'a' is a value
          a
        end
      else
        o = op_predicate(op)
        rest.unshift o.call( lambda { e(a, env) }, lambda { e(b, env) })
      end
    end

    e(@tree, env)
  end
end

input = <<-INPUT.split("\n")
a
1
"yo"
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
d &&    e || (   f && g   )
(((1 == 2)))
INPUT


input.each do |s|
  st = RelevanceParser.new.parse(s)
  puts s
  if st.respond_to? :tree
    t = st.tree
    p t
    p Rel.new(t).evaluate({:a => true, :b => false, :c => true, :d => true, :e => true, :f => true, :g => true})
    puts
  end
end

input.each do |s|
  #p !!RelevanceParser.new.parse(s)
end
