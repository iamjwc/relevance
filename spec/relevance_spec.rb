require 'rubygems'
require 'ruby-debug'
require File.dirname(__FILE__) + '/../lib/relevance'

describe RelevanceInterpreter do
  describe "operators" do
    it "should test equivalence" do
      RelevanceInterpreter.should be_eq(nil, nil)
      RelevanceInterpreter.should be_eq("a", "a")
      RelevanceInterpreter.should be_eq(["a"], ["a"])
      RelevanceInterpreter.should be_eq(["a"], "a")
      RelevanceInterpreter.should be_eq("a", ["a"])

      RelevanceInterpreter.should_not be_eq(nil, "nil")
      RelevanceInterpreter.should_not be_eq("a", "b")
      RelevanceInterpreter.should_not be_eq("a", ["b"])
      RelevanceInterpreter.should_not be_eq(["a"], ["a", "b"])
      RelevanceInterpreter.should_not be_eq("a", ["a", "b"])
      RelevanceInterpreter.should_not be_eq(["a"], "b")
    end

    it "should test left side is a superset of the right side" do
      RelevanceInterpreter.should be_eq(["a", "b"], ["a"])
      RelevanceInterpreter.should be_eq(["a", "b"], ["a", "b"])
    end

    it "should test equivalence of integers" do
      RelevanceInterpreter.should be_eq(1,1)
      RelevanceInterpreter.should be_eq(1,"1")
      RelevanceInterpreter.should be_eq(1,["1"])
      RelevanceInterpreter.should be_eq(["1"], 1)
    end

    it "should test inequivalence" do
      RelevanceInterpreter.should be_neq(nil, "nil")

      RelevanceInterpreter.should_not be_neq(nil, nil)
      RelevanceInterpreter.should_not be_neq("a", "a")
      RelevanceInterpreter.should_not be_neq(["a"], ["a"])
      RelevanceInterpreter.should_not be_neq(["a"], "a")
      RelevanceInterpreter.should_not be_neq("a", ["a"])
      RelevanceInterpreter.should_not be_neq(["a", "b"], ["a", "b"])
      RelevanceInterpreter.should_not be_neq(["a", "b"], ["a"])

      RelevanceInterpreter.should be_neq("a", "b")
      RelevanceInterpreter.should be_neq("a", ["b"])
      RelevanceInterpreter.should be_neq(["a"], "b")
      RelevanceInterpreter.should be_neq("a", ["a", "b"])
      RelevanceInterpreter.should be_neq(["a"], ["a", "b"])
    end

    it "should test inequivalence of integers" do
      RelevanceInterpreter.should be_neq(1,2)
      RelevanceInterpreter.should be_neq(1,"2")
      RelevanceInterpreter.should be_neq(1,["2"])
      RelevanceInterpreter.should be_neq(["1"], 2)
    end

    it "should test less than on integers" do
      RelevanceInterpreter.should be_lt(1,2)
      RelevanceInterpreter.should be_lt(1,"2")
      RelevanceInterpreter.should be_lt("1",2)
      RelevanceInterpreter.should be_lt("1","2")

      RelevanceInterpreter.should_not be_lt(1,1)
      RelevanceInterpreter.should_not be_lt(2,1)
      RelevanceInterpreter.should_not be_lt("2",1)
      RelevanceInterpreter.should_not be_lt(2,"1")
      RelevanceInterpreter.should_not be_lt("2","1")
    end

    it "should always return false for less than on strings" do
      RelevanceInterpreter.should_not be_lt("b","-1")
      RelevanceInterpreter.should_not be_lt("-1","b")
      RelevanceInterpreter.should_not be_lt("1","b")
      RelevanceInterpreter.should_not be_lt("b","1")
      RelevanceInterpreter.should_not be_lt("b","a")
      RelevanceInterpreter.should_not be_lt("a","b")
      RelevanceInterpreter.should_not be_lt("a","a")
    end

    it "should test less than on dates" do
      RelevanceInterpreter.should be_lt("02/20/2008","02/20/2009")
      RelevanceInterpreter.should be_lt("02/19/2009","02/20/2009")

      RelevanceInterpreter.should_not be_lt("02/20/2009","02/20/2008")
    end

    it "should test less than on times" do
      RelevanceInterpreter.should be_lt("10:30pm","11:00pm")
      RelevanceInterpreter.should be_lt("10am","1pm")

      RelevanceInterpreter.should_not be_lt("10:00pm","12:00am")
    end

    it "should test less than on durations" do
      RelevanceInterpreter.should be_lt("10:30","11:00")
      RelevanceInterpreter.should be_lt("1","10")

      RelevanceInterpreter.should_not be_lt("12:00","10:00")
      RelevanceInterpreter.should_not be_lt("12:00","12:00")
    end

    it "should always return false for less than between types" do
      RelevanceInterpreter.should_not be_lt("02/20/2009","a")
      RelevanceInterpreter.should_not be_lt("a","02/20/2008")
      RelevanceInterpreter.should_not be_lt("1","02/20/2008")
      RelevanceInterpreter.should_not be_lt(1,"02/20/2008")
      RelevanceInterpreter.should_not be_lt("02/20/2009","1")
      RelevanceInterpreter.should_not be_lt("02/20/2009",1)
      RelevanceInterpreter.should_not be_lt("02/20/2009","12:00am")
      RelevanceInterpreter.should_not be_lt("12:00am","02/20/2009")
      RelevanceInterpreter.should_not be_lt("12:00am",1)

      RelevanceInterpreter.should_not be_lt("12:00am","12:00")
      RelevanceInterpreter.should_not be_lt("11:00am","12:00")
      RelevanceInterpreter.should_not be_lt("11:00","12:00am")
    end

    it "should test greater than on integers" do
      RelevanceInterpreter.should be_gt(2  ,1  )
      RelevanceInterpreter.should be_gt("2",1  )
      RelevanceInterpreter.should be_gt(2  ,"1")
      RelevanceInterpreter.should be_gt("2","1")

      RelevanceInterpreter.should_not be_gt(1  ,1  )
      RelevanceInterpreter.should_not be_gt(1  ,2  )
      RelevanceInterpreter.should_not be_gt(1  ,"2")
      RelevanceInterpreter.should_not be_gt("1",2  )
      RelevanceInterpreter.should_not be_gt("1","2")
    end

    it "should always return false for greater than on strings" do
      RelevanceInterpreter.should_not be_gt("-1","b" )
      RelevanceInterpreter.should_not be_gt("b" ,"-1")
      RelevanceInterpreter.should_not be_gt("b" ,"1" )
      RelevanceInterpreter.should_not be_gt("1" ,"b" )
      RelevanceInterpreter.should_not be_gt("a" ,"b" )
      RelevanceInterpreter.should_not be_gt("b" ,"a" )
      RelevanceInterpreter.should_not be_gt("a" ,"a" )
    end

    it "should test greater than on dates" do
      RelevanceInterpreter.should be_gt("02/20/2009","02/20/2008")
      RelevanceInterpreter.should be_gt("02/20/2009","02/19/2009")

      RelevanceInterpreter.should_not be_gt("02/20/2008","02/20/2009")
    end

    it "should test greater than on times" do
      RelevanceInterpreter.should be_gt("11:00pm","10:30pm")
      RelevanceInterpreter.should be_gt("1pm"    ,"10am"   )

      RelevanceInterpreter.should_not be_gt("12:00am","10:00pm")
    end

    it "should test greater than on durations" do
      RelevanceInterpreter.should be_gt("11:00","10:30")
      RelevanceInterpreter.should be_gt("10"   ,"1"    )

      RelevanceInterpreter.should_not be_gt("10:00","12:00")
      RelevanceInterpreter.should_not be_gt("12:00","12:00")
    end

    it "should always return false for greater than between types" do
      RelevanceInterpreter.should_not be_gt("a"         ,"02/20/2009")
      RelevanceInterpreter.should_not be_gt("02/20/2008","a"         )
      RelevanceInterpreter.should_not be_gt("02/20/2008","1"         )
      RelevanceInterpreter.should_not be_gt("02/20/2008",1           )
      RelevanceInterpreter.should_not be_gt("1"         ,"02/20/2009")
      RelevanceInterpreter.should_not be_gt(1           ,"02/20/2009")
      RelevanceInterpreter.should_not be_gt("12:00am"   ,"02/20/2009")
      RelevanceInterpreter.should_not be_gt("02/20/2009","12:00am"   )
      RelevanceInterpreter.should_not be_gt(1           ,"12:00am"   )

      RelevanceInterpreter.should_not be_gt("12:00"  ,"12:00am")
      RelevanceInterpreter.should_not be_gt("12:00"  ,"11:00am")
      RelevanceInterpreter.should_not be_gt("12:00am","11:00"  )
    end

    it "should test less than or equal to on integers" do
      RelevanceInterpreter.should be_lte(1,2)
      RelevanceInterpreter.should be_lte(1,"2")
      RelevanceInterpreter.should be_lte("1",2)
      RelevanceInterpreter.should be_lte("1","2")

      RelevanceInterpreter.should be_lte(1,1)

      RelevanceInterpreter.should_not be_lte(2,1)
      RelevanceInterpreter.should_not be_lte("2",1)
      RelevanceInterpreter.should_not be_lte(2,"1")
      RelevanceInterpreter.should_not be_lte("2","1")
    end

    it "should test greater than or equal to on integers" do
      RelevanceInterpreter.should be_gte(2  ,1  )
      RelevanceInterpreter.should be_gte("2",1  )
      RelevanceInterpreter.should be_gte(2  ,"1")
      RelevanceInterpreter.should be_gte("2","1")

      RelevanceInterpreter.should be_gte(1  ,1  )

      RelevanceInterpreter.should_not be_gte(1  ,2  )
      RelevanceInterpreter.should_not be_gte(1  ,"2")
      RelevanceInterpreter.should_not be_gte("1",2  )
      RelevanceInterpreter.should_not be_gte("1","2")
    end
  end

  describe "empty string" do
    it "should always be relevant" do
      RelevanceInterpreter.new("").should be_relevant({})
    end
  end

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
      puts "We don't need to support this. Remove this feature."
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

    it "should not match an array without the correct value" do
      @r.should_not be_relevant(:field1 => ["field1Value"], :field2 => "field2Value")
      @r.should_not be_relevant(:field1 => ["field1Value", "field3Value"], :field2 => ["field2Value", "field4Value"])
    end
  end

  describe "singular fields" do
    before(:each) do
      @r = RelevanceInterpreter.new "field1"
    end

    it "should always be relevant unless no value was supplied" do
      @r.should be_relevant(:field1 => "")
      @r.should be_relevant(:field1 => "testing")
      @r.should_not be_relevant({})
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

  it "should work with empty strings" do
    ri = RelevanceInterpreter.new("a == ''")
    ri.should be_relevant(:a => "")
    ri.should be_relevant(:a => nil)
    ri.should_not be_relevant(:a => "hey")
  end
end
