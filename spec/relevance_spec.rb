require 'rubygems'
require File.dirname(__FILE__) + '/../lib/relevance'

describe RelevanceInterpreter do
  describe "single statement" do
    before(:each) do
      @r = RelevanceInterpreter.new "field1 == 'field1Value'"
    end

    it "should match the exact value" do
      @r.should be_relevant(:field1 => "field1Value")
    end

    it "should not match any partial values" do
      @r.should_not be_relevant(:field1 => "field1Val")
      @r.should_not be_relevant(:field1 => "ld1Value")
      @r.should_not be_relevant(:field1 => "ld1Val")
    end

    it "should match the item in an array of values" do
      @r.should be_relevant(:field1 => ["field2Value", "field1Value"])
      @r.should be_relevant(:field1 => ["field1Value"])
    end

    it "should not match empty array" do
      @r.should_not be_relevant(:field1 => [])
    end

    it "should not match an array without the correct value" do
      @r.should_not be_relevant(:field1 => ["field2Value"])
      @r.should_not be_relevant(:field1 => ["field2Value", "field3Value"])
    end
  end

  describe "comparing two fields" do
    before(:each) do
      @r = RelevanceInterpreter.new "field1 == field2"
    end

    it "should match like values" do
      @r.should be_relevant(:field1 => "fieldValue", :field2 => "fieldValue")
    end

    it "should not match unlike values" do
      @r.should_not be_relevant(:field1 => "fieldValue", :field2 => "otherValue")
    end

    it "should match the item in an array of values" do
      @r.should be_relevant(:field1 => ["field2Value", "field1Value"], :field2 => "field2Value")
      @r.should be_relevant(:field1 => ["field2Value"], :field2 => "field2Value")
    end

    it "should not match empty array" do
      @r.should_not be_relevant(:field1 => [], :field2 => "")
      @r.should_not be_relevant(:field1 => "", :field2 => [])
      @r.should_not be_relevant(:field1 => [], :field2 => [])
    end

    it "should not match an array without the correct value" do
      @r.should_not be_relevant(:field1 => ["field1Value"], :field2 => "field2Value")
      @r.should_not be_relevant(:field1 => ["field1Value", "field3Value"], :field2 => ["field2Value", "field4Value"])
    end
  end

  describe "singular fields" do
    before(:each) do
      @r = RelevanceInterpreter.new "field1"
    end

    it "should always be relevant" do
      @r.should be_relevant(:field1 => "")
      @r.should be_relevant(:field1 => "testing")
      @r.should be_relevant({})
    end
  end

  describe "constants" do
    before(:each) do
      @r = RelevanceInterpreter.new "'field1'"
    end

    it "should always be relevant" do
      @r.should be_relevant(:field1 => "")
      @r.should be_relevant(:field1 => "testing")
      @r.should be_relevant({})
    end
  end

  describe "boolean operators" do
    before(:each) do
      @or  = RelevanceInterpreter.new "a || b"
      @and = RelevanceInterpreter.new "a && b"
      @not = RelevanceInterpreter.new "a != b"
    end

    it 'not should work as expected' do
      @not.should_not be_relevant(:a => "hey", :b => "hey")
      @not.should be_relevant(:a => "he", :b => "hey")
      @not.should be_relevant(:a => "hey", :b => "he")
    end

    it "or should work as expected" do
      @or.should be_relevant(:a => "hey", :b => "hey")
    end

    it "and should work as expected" do
      @and.should be_relevant(:a => "hey", :b => "hey")
    end
  end

  describe "relational operators" do
    before(:each) do
      @lt = RelevanceInterpreter.new "a < b"
      @gt = RelevanceInterpreter.new "a > b"
      @lte = RelevanceInterpreter.new "a <= b"
      @gte = RelevanceInterpreter.new "a >= b"
    end

    it "< should work as expected" do
      @lt.should be_relevant(:a => "10", :b => "100")
      @lt.should be_relevant(:a => "9", :b => "10")
      @lt.should_not be_relevant(:a => "90", :b => "1")
    end

    it "> should work as expected" do
      @gt.should_not be_relevant(:a => "10", :b => "100")
      @gt.should_not be_relevant(:a => "9", :b => "10")
      @gt.should be_relevant(:a => "90", :b => "1")
    end

    it "<= should work as expected" do
      @lte.should be_relevant(:a => "10", :b => "100")
      @lte.should be_relevant(:a => "9", :b => "10")
      @lte.should_not be_relevant(:a => "90", :b => "1")
    end

    it ">= should work as expected" do
      @gte.should_not be_relevant(:a => "10", :b => "100")
      @gte.should_not be_relevant(:a => "9", :b => "10")
      @gte.should be_relevant(:a => "90", :b => "1")
    end
  end
end
