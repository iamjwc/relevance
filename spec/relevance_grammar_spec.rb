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

  it "should not be able to parse these" do
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
    @parser.parse('1').tree.should == 1
    @parser.parse('"a"').tree.should == 'a'
    @parser.parse('a').tree.should == :a
    @parser.parse("blah == 1").tree.should == [:blah, :==, 1]
  end

  it "should be able to parse an empty string" do
    @parser.parse('a == ""').tree.should == [:a, :==, ""]
  end

  it "should be able to parse complex statements" do
    @parser.parse("a == 1").tree.should == [:a, :==, 1]
    @parser.parse("a == 1 && b == 2").tree.should == [[:a, :==, 1], :"&&", [:b, :==, 2]]
    @parser.parse("a == 1 && b == 2 && c == 3").tree.should == [[:a, :==, 1], :"&&", [[:b, :==, 2], :"&&", [:c, :==, 3]]]
  end
end
