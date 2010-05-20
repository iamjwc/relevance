# Autogenerated from a Treetop grammar. Edits may be lost.


module Relevance
  include Treetop::Runtime

  def root
    @root ||= :stmt
  end

  module Stmt0
    def i
      elements[0]
    end

    def op
      elements[1]
    end

    def s
      elements[2]
    end
  end

  module Stmt1
    def tree
      [i.tree, op.tree, s.tree]
    end
  end

  def _nt_stmt
    start_index = index
    if node_cache[:stmt].has_key?(index)
      cached = node_cache[:stmt][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_item
    s1 << r2
    if r2
      r3 = _nt_operator
      s1 << r3
      if r3
        r4 = _nt_stmt
        s1 << r4
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Stmt0)
      r1.extend(Stmt1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r5 = _nt_item
      if r5
        r0 = r5
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:stmt][start_index] = r0

    r0
  end

  module StmtParens0
    def ws1
      elements[1]
    end

    def s
      elements[2]
    end

    def ws2
      elements[3]
    end

  end

  module StmtParens1
    def tree
      s.tree
    end
  end

  def _nt_stmt_parens
    start_index = index
    if node_cache[:stmt_parens].has_key?(index)
      cached = node_cache[:stmt_parens][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('(', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('(')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_ws
      s0 << r2
      if r2
        r3 = _nt_stmt
        s0 << r3
        if r3
          r4 = _nt_ws
          s0 << r4
          if r4
            if has_terminal?(')', false, index)
              r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(')')
              r5 = nil
            end
            s0 << r5
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(StmtParens0)
      r0.extend(StmtParens1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:stmt_parens][start_index] = r0

    r0
  end

  module Operator0
    def ws1
      elements[0]
    end

    def op
      elements[1]
    end

    def ws2
      elements[2]
    end
  end

  module Operator1
    def tree
      op.text_value
    end
  end

  def _nt_operator
    start_index = index
    if node_cache[:operator].has_key?(index)
      cached = node_cache[:operator][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_ws
    s0 << r1
    if r1
      r2 = _nt_op
      s0 << r2
      if r2
        r3 = _nt_ws
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Operator0)
      r0.extend(Operator1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:operator][start_index] = r0

    r0
  end

  module Item0
    def tree
      text_value.to_sym
    end
  end

  def _nt_item
    start_index = index
    if node_cache[:item].has_key?(index)
      cached = node_cache[:item][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_identifier
    r1.extend(Item0)
    if r1
      r0 = r1
    else
      r2 = _nt_constant
      if r2
        r0 = r2
      else
        r3 = _nt_stmt_parens
        if r3
          r0 = r3
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:item][start_index] = r0

    r0
  end

  def _nt_op
    start_index = index
    if node_cache[:op].has_key?(index)
      cached = node_cache[:op][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    if has_terminal?('==', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('==')
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if has_terminal?('!=', false, index)
        r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure('!=')
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if has_terminal?('>=', false, index)
          r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('>=')
          r3 = nil
        end
        if r3
          r0 = r3
        else
          if has_terminal?('<=', false, index)
            r4 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('<=')
            r4 = nil
          end
          if r4
            r0 = r4
          else
            if has_terminal?('>', false, index)
              r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('>')
              r5 = nil
            end
            if r5
              r0 = r5
            else
              if has_terminal?('<', false, index)
                r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('<')
                r6 = nil
              end
              if r6
                r0 = r6
              else
                if has_terminal?('&&', false, index)
                  r7 = instantiate_node(SyntaxNode,input, index...(index + 2))
                  @index += 2
                else
                  terminal_parse_failure('&&')
                  r7 = nil
                end
                if r7
                  r0 = r7
                else
                  if has_terminal?('||', false, index)
                    r8 = instantiate_node(SyntaxNode,input, index...(index + 2))
                    @index += 2
                  else
                    terminal_parse_failure('||')
                    r8 = nil
                  end
                  if r8
                    r0 = r8
                  else
                    @index = i0
                    r0 = nil
                  end
                end
              end
            end
          end
        end
      end
    end

    node_cache[:op][start_index] = r0

    r0
  end

  module Identifier0
  end

  def _nt_identifier
    start_index = index
    if node_cache[:identifier].has_key?(index)
      cached = node_cache[:identifier][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('\G[a-zA-Z]', true, index)
      r1 = true
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[a-zA-Z0-9_\\[\\]]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Identifier0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:identifier][start_index] = r0

    r0
  end

  module Constant0
    def tree
      text_value.to_i
    end
  end

  module Constant1
    def tree
      text_value
    end
  end

  def _nt_constant
    start_index = index
    if node_cache[:constant].has_key?(index)
      cached = node_cache[:constant][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_number
    r1.extend(Constant0)
    if r1
      r0 = r1
    else
      r2 = _nt_string
      r2.extend(Constant1)
      if r2
        r0 = r2
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:constant][start_index] = r0

    r0
  end

  module Number0
  end

  def _nt_number
    start_index = index
    if node_cache[:number].has_key?(index)
      cached = node_cache[:number][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('\G[1-9]', true, index)
      r1 = true
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[0-9]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Number0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:number][start_index] = r0

    r0
  end

  def _nt_string
    start_index = index
    if node_cache[:string].has_key?(index)
      cached = node_cache[:string][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_double_quoted_string
    if r1
      r0 = r1
    else
      r2 = _nt_single_quoted_string
      if r2
        r0 = r2
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:string][start_index] = r0

    r0
  end

  module SingleQuotedString0
  end

  module SingleQuotedString1
  end

  def _nt_single_quoted_string
    start_index = index
    if node_cache[:single_quoted_string].has_key?(index)
      cached = node_cache[:single_quoted_string][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?("'", false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("'")
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        i4 = index
        if has_terminal?("'", false, index)
          r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("'")
          r5 = nil
        end
        if r5
          r4 = nil
        else
          @index = i4
          r4 = instantiate_node(SyntaxNode,input, index...index)
        end
        s3 << r4
        if r4
          if index < input_length
            r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r6 = nil
          end
          s3 << r6
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(SingleQuotedString0)
        else
          @index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
      if r2
        if has_terminal?("'", false, index)
          r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("'")
          r7 = nil
        end
        s0 << r7
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(SingleQuotedString1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:single_quoted_string][start_index] = r0

    r0
  end

  module DoubleQuotedString0
  end

  module DoubleQuotedString1
  end

  def _nt_double_quoted_string
    start_index = index
    if node_cache[:double_quoted_string].has_key?(index)
      cached = node_cache[:double_quoted_string][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('"', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3 = index
        i4, s4 = index, []
        i5 = index
        if has_terminal?('"', false, index)
          r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r6 = nil
        end
        if r6
          r5 = nil
        else
          @index = i5
          r5 = instantiate_node(SyntaxNode,input, index...index)
        end
        s4 << r5
        if r5
          if index < input_length
            r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r7 = nil
          end
          s4 << r7
        end
        if s4.last
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          r4.extend(DoubleQuotedString0)
        else
          @index = i4
          r4 = nil
        end
        if r4
          r3 = r4
        else
          if has_terminal?('\"', false, index)
            r8 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('\"')
            r8 = nil
          end
          if r8
            r3 = r8
          else
            @index = i3
            r3 = nil
          end
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
      if r2
        if has_terminal?('"', false, index)
          r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r9 = nil
        end
        s0 << r9
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(DoubleQuotedString1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:double_quoted_string][start_index] = r0

    r0
  end

  def _nt_ws
    start_index = index
    if node_cache[:ws].has_key?(index)
      cached = node_cache[:ws][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('\G[\\s]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:ws][start_index] = r0

    r0
  end

end

class RelevanceParser < Treetop::Runtime::CompiledParser
  include Relevance
end


