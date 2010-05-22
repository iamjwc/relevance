# XXX: It blows my mind knowing that this even works. This code is awful.
# Could be rewritten to be much cleaner.
class RelevanceInterpreter
  def initialize(source)
    @tree = RelevanceParser.new.parse(source).tree
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

  def relevant?(env)
    p @tree
    !![evaluate(@tree, env)].flatten.first
  end

  protected

  def evaluate(tree, env)
    a,op,b,*rest = tree

    if op.nil?
      # Only one item in the stack.
      if a.is_a? Array
        # 'a' is an expression
        evaluate(a, env)
      elsif a.is_a? Symbol
        # 'a' is a variable name
        env[a]
      else
        # 'a' is a value
        a
      end
    else
      o = op_predicate(op)
      # Pass in lambda's for each value to be lazy.
      # This allows || to short circuit.
      rest.unshift o.call( lambda { evaluate(a, env) }, lambda { evaluate(b, env) })
    end
  end
end

