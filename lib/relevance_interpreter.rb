class RelevanceInterpreter
  class << self
    def eq?(a,b)
      # Give a and b default values.
      a = "" if a.nil?
      b = "" if b.nil?

      # Hack because [*""] # => [], which causes eq? to
      # always return true.
      a = [a] if a == ""
      b = [b] if b == ""

      a = [*a].map {|i| i.is_a?(Numeric) ? i.to_s : i }
      b = [*b].map {|i| i.is_a?(Numeric) ? i.to_s : i }

      b.inject(true) {|result, i| result && a.include?(i) }
    end

    def neq?(a,b)
      !self.eq?(a,b)
    end

    def lt?(a,b)
      self._ordered_inequality(a,b,:<)
    end

    def gt?(a,b)
      self._ordered_inequality(a,b,:>)
    end

    def lte?(a,b)
      self._ordered_inequality(a,b,:<=)
    end

    def gte?(a,b)
      self._ordered_inequality(a,b,:>=)
    end

    def _ordered_inequality(a,b,op)
      # Try If there is a slash, it must be a date
      if a.to_s =~ /\//
        a = Date.parse(a)
        b = Date.parse(b)
      elsif a.to_s =~ /am|pm/i && b.to_s =~ /am|pm/i
        a = self._time_to_i(a)
        b = self._time_to_i(b)
      elsif a.to_s =~ /:/ && b.to_s =~ /:/ && (a.to_s + b.to_s) !~ /am|pm/
        a = self._time_to_i(a)
        b = self._time_to_i(b)
      else
        a = Integer(a)
        b = Integer(b)
      end

      a.send(op, b)
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
    if !source.blank?
      @tree = RelevanceParser.new.parse(source).tree
    else
      @tree = true
    end
  end

  def op_predicate(op)
    case op
      when :'==' then lambda {|a,b| self.class.eq?  a.call(), b.call() }
      when :'!=' then lambda {|a,b| self.class.neq? a.call(), b.call() }
      when :'>=' then lambda {|a,b| self.class.gte? a.call(), b.call() }
      when :'<=' then lambda {|a,b| self.class.lte? a.call(), b.call() }
      when :'>'  then lambda {|a,b| self.class.gt?  a.call(), b.call() }
      when :'<'  then lambda {|a,b| self.class.lt?  a.call(), b.call() }
      when :'&&' then lambda {|a,b| a.call() && b.call() }
      when :'||' then lambda {|a,b| a.call() || b.call() }
    end
  end

  def relevant?(env)
    !![evaluate(@tree, env)].flatten.first
  end

  protected

  def evaluate(tree, env)
    a,op,b,*rest = tree

    if op.is_a? Symbol
      o = op_predicate(op)
      # Pass in lambda's for each value to be lazy.
      # This allows || to short circuit.
      rest.unshift o.call( lambda { evaluate(a, env) }, lambda { evaluate(b, env) })
    else
      # Only one item in the stack.
      if a.is_a? Symbol
        # 'a' is a variable name
        env[a]
      else
        # 'a' is a value
        a
      end
    end
  end
end

