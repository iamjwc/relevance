# XXX: It blows my mind knowing that this even works. This code is awful.
# Could be rewritten to be much cleaner.
class RelevanceInterpreter
  def initialize(expression)
    @expr = expression
  end

  def relevant?(values)
    @values = values || {}
    ret_val = eval(@expr)

    # If @expr is empty, then ret_val will be nil, which means that the field
    # is relevant, but nil is a falsy statement.
    ret_val.nil? ? true : ret_val
  end

  def field(name)
    v = @values
    parse_field_name(name).each do |f|
      if v.has_key?(f)
        v = v[f]
      else
        v = nil
        break
      end
    end

    v ||= ""

    modify_equal_op(v)

    v
  end

  def parse_field_name(name)
    name.gsub("]","").gsub("["," ").split
  end

  def modify_equal_op(value)
    unless value.respond_to? :_eq_copy
      class << value
        alias _eq_copy ==

        def ==(rhs)
          case self
          when Array
            case rhs
            when Array
              self.each do |item|
                return true if rhs.include?(item)
              end
            else
              return self.include?(rhs)
            end
          else
            return self._eq_copy(rhs)
          end

          false
        end

        def <(rhs)
          case self
          when Array
            case rhs
            when Array
              self.each do |item|
                rhs.each do |rhs_item|
                  return true if item.to_f < rhs_item.to_f
                end
              end
            else
              self.each do |item|
                return true if item.to_f < rhs.to_f
              end
            end
          else
            return self.to_f < rhs.to_f
          end

          false
        end

        def <=(rhs)
          case self
          when Array
            case rhs
            when Array
              self.each do |item|
                rhs.each do |rhs_item|
                  return true if item.to_f <= rhs_item.to_f
                end
              end
            else
              self.each do |item|
                return true if item.to_f <= rhs.to_f
              end
            end
          else
            return self.to_f <= rhs.to_f
          end

          false
        end

        def >(rhs)
          case self
          when Array
            case rhs
            when Array
              self.each do |item|
                rhs.each do |rhs_item|
                  return true if item.to_f > rhs_item.to_f
                end
              end
            else
              self.each do |item|
                return true if item.to_f > rhs.to_f
              end
            end
          else
            return self.to_f > rhs.to_f
          end

          false
        end

        def >=(rhs)
          case self
          when Array
            case rhs
            when Array
              self.each do |item|
                rhs.each do |rhs_item|
                  return true if item.to_f >= rhs_item.to_f
                end
              end
            else
              self.each do |item|
                return true if item.to_f >= rhs.to_f
              end
            end
          else
            return self.to_f >= rhs.to_f
          end

          false
        end
      end
    end
  end
end

