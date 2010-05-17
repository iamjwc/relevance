require 'rubygems'
require File.dirname(__FILE__) + '/../lib/relevance'

describe RelevanceParser do
  before do
    @parser = RelevanceParser.new
  end

  it "should be able to parse these" do
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
      (!!@parser.parse(s)).should be_true
    end
  end

  it "should be able to parse these" do
    input = <<-INPUT.split("\n")
      a = b
      eval a
      eval(a)
      eval("hey")
      eval"hi" && "you"
    INPUT

    input.each do |s|
      (!!@parser.parse(s)).should be_false
    end
  end

  it "should be able to return text values" do
    @parser.parse('1').text_value2.should == '1'
    @parser.parse('"a"').text_value2.should == '"a"'
    @parser.parse('a').text_value2.should == "field('a')"
    @parser.parse("blah == 1").text_value2.should == "field('blah') == 1"
  end
end
