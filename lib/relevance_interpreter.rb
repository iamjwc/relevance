# XXX: It blows my mind knowing that this even works. This code is awful.
# Could be rewritten to be much cleaner.
class RelevanceInterpreter
  class << self
    def eq?(a,b)
      a = [*a].map {|i| i.is_a?(Numeric) ? i.to_s : i }
      b = [*b].map {|i| i.is_a?(Numeric) ? i.to_s : i }

      a.inject(true) {|result, i| result && b.include?(i) }
    end

    def neq?(a,b)
      !self.eq?(a,b)
    end

    def lt?(a,b)
      # Try If there is a slash, it must be a date
      if a.to_s =~ /\//
        return Date.parse(a) < Date.parse(b)
      elsif a.to_s =~ /am|pm/i && b.to_s =~ /am|pm/i
        self._time_to_i(a) < self._time_to_i(b)
      elsif a.to_s =~ /:/ && b.to_s =~ /:/ && (a.to_s + b.to_s) !~ /am|pm/
        self._time_to_i(a) < self._time_to_i(b)
      else
        return Integer(a) < Integer(b)
      end
    rescue
      # Always return false if the inputs aren't
      # integers
      return false
    end

    def gt?(a,b)
      # Try If there is a slash, it must be a date
      if a.to_s =~ /\//
        return Date.parse(a) > Date.parse(b)
      elsif a.to_s =~ /am|pm/i && b.to_s =~ /am|pm/i
        self._time_to_i(a) > self._time_to_i(b)
      elsif a.to_s =~ /:/ && b.to_s =~ /:/ && (a.to_s + b.to_s) !~ /am|pm/
        self._time_to_i(a) > self._time_to_i(b)
      else
        return Integer(a) > Integer(b)
      end
    rescue
      # Always return false if the inputs aren't
      # integers
      return false
    end

    def _time_to_i(t)
      pm = t =~ /pm/

      t = t.split(":")
      t[0] = t[0].to_i + (pm ? 12 : 0)
      t[1] = t[1].to_i
      t = t[0] * 100 + t[1]
    end
  end

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

