require File.dirname(__FILE__) + '/spec_helper'

describe McMoney do

  before(:each) do
    @money = McMoney.new
  end

  it "should be contructable with empty class method" do
    McMoney.empty.should == @money
  end

  it "should return itself with to_money" do
    @money.to_money.should equal(@money)
  end

  it "should default to 0 when constructed with no arguments" do
    @money.should == McMoney.new(0.00)
  end

  it "should to_s as a float with 2 decimal places" do
    @money.to_s.should == "0.00"
  end

  it "should be constructable with a BigDecimal" do
    McMoney.new(BigDecimal.new("1.23")).should == McMoney.new(1.23)
  end

  it "should be constructable with a Fixnum" do
    McMoney.new(3).should == McMoney.new(3.00)
  end

  it "should be construcatable with a Float" do
    McMoney.new(3.00).should == McMoney.new(3.00)
  end

  it "should be addable" do
    (McMoney.new(1.51) + McMoney.new(3.49)).should == McMoney.new(5.00)
  end

  it "should be able to add $0 + $0" do
    (McMoney.new + McMoney.new).should == McMoney.new
  end

  it "should be subtractable" do
    (McMoney.new(5.00) - McMoney.new(3.49)).should == McMoney.new(1.51)
  end

  it "should be subtractable to $0" do
    (McMoney.new(5.00) - McMoney.new(5.00)).should == McMoney.new
  end

  it "should be substractable to a negative amount" do
    (McMoney.new(0.00) - McMoney.new(1.00)).should == McMoney.new("-1.00")
  end

  it "should be addable with money with multiple decimal places" do
    m = McMoney.new(1.225, :decimal_places => 5)
    n = McMoney.new(1.224, :decimal_places => 5)
    (m - n).should == McMoney.new(0.001, :decimal_places => 5)
  end

  it "should inspect to a presentable string" do
    @money.inspect.should == "#<McMoney value:0.00>"
  end

  it "should be inspectable within an array" do
    [@money].inspect.should == "[#<McMoney value:0.00>]"
  end

  it "should correctly support eql? as a value object" do
    @money.should eql(McMoney.new)
  end

  it "should be addable with integer" do
    (McMoney.new(1.33) + 1).should == McMoney.new(2.33)
  end

  it "should be addable with float" do
    (McMoney.new(1.33) + 1.50).should == McMoney.new(2.83)
  end

  it "should be addable with money" do
    (McMoney.new(1.33) + McMoney.new(1.50)).should == McMoney.new(2.83)
  end

  it "should be addable with money with multiple decimal places" do
    m = McMoney.new(1.225, :decimal_places => 5)
    n = McMoney.new(1.224, :decimal_places => 5)
    (m + n).should == McMoney.new(2.449, :decimal_places => 5)
  end

  it "should be multipliable with an integer" do
    (McMoney.new(1.00) * 55).should == McMoney.new(55.00)
  end

  it "should be multiplable with a float" do
    (McMoney.new(1.00) * 1.50).should == McMoney.new(1.50)
  end

  it "should be multipliable by a cents amount" do
    (McMoney.new(1.00) * 0.50).should == McMoney.new(0.50)
  end

  it "should be multipliable by a repeatable floating point number" do
    (McMoney.new(24.00) * (1 / 30.0)).should == McMoney.new(0.80)
  end

  it "should be multipliable without loss of precision for multiple decimal places" do
    (McMoney.new(1.2225, :decimal_places => 5) * 2).should == McMoney.new(2.445, :decimal_places => 5)
  end

  it "should round multiplication result with fractional penny of 5 or higher up" do
    (McMoney.new(0.03) * 0.5).should == McMoney.new(0.02)
  end

  it "should round multiplication result with fractional penny of 4 or lower down" do
    (McMoney.new(0.10) * 0.33).should == McMoney.new(0.03)
  end

  it "should be divisible by a fixnum" do
    (McMoney.new(55.00) / 55).should == McMoney.new(1.00)
  end

  it "should be divisible by an integer" do
    (McMoney.new(2.00) / 2).should == McMoney.new(1.00)
  end

  it "should be divisiable with multiple decimal places" do
    (McMoney.new(2.225, :decimal_places => 5) / 10).should == McMoney.new(0.2225, :decimal_places => 5)
  end

  it "should round to the lowest cent value during division" do
    (McMoney.new(2.00) / 3).should == McMoney.new(0.67)
  end

  it "should return cents in to_liquid" do
    McMoney.new(1.00).to_liquid.should == 100
  end

  it "should return cents in to_json" do
    McMoney.new(1.00).to_liquid.should == 100
  end

  it "should support absolute value" do
    McMoney.new(-1.00).abs.should == McMoney.new(1.00)
  end

  it "should support to_i" do
    McMoney.new(1.50).to_i.should == 1
  end

  it "should support to_f" do
    McMoney.new(1.50).to_f.to_s.should == "1.5"
  end

  it "should be creatable from an integer value in cents" do
    McMoney.from_cents(1950).should == McMoney.new(19.50)
  end

  it "should be creatable from an integer value of 0 in cents" do
    McMoney.from_cents(0).should == McMoney.new
  end

  it "should be creatable from a float cents amount" do
    McMoney.from_cents(1950.5).should == McMoney.new(19.51)
  end

  it "should raise when constructed with a NaN value" do
    lambda{ McMoney.new( 0.0 / 0) }.should raise_error
  end

  it "should be comparable with non-money objects" do
    (McMoney.new(1) > 0).should be_true
  end

  describe "frozen with amount of $1" do
    before(:each) do
      @money = McMoney.new(1.00).freeze
    end

    it "should == $1" do
      @money.should == McMoney.new(1.00)
    end

    it "should not == $2" do
      @money.should_not == McMoney.new(2.00)
    end

    it "<=> $1 should be 0" do
      (@money <=> McMoney.new(1.00)).should == 0
    end

    it "<=> $2 should be -1" do
      (@money <=> McMoney.new(2.00)).should == -1
    end

    it "<=> $0.50 should equal 1" do
      (@money <=> McMoney.new(0.50)).should == 1
    end

    it "should have the same hash value as $1" do
      @money.hash.should == McMoney.new(1.00).hash
    end

    it "should not have the same hash value as $2" do
      @money.hash.should == McMoney.new(1.00).hash
    end

  end

  describe "with amount of $0" do
    before(:each) do
      @money = McMoney.new
    end

    it "should be zero" do
      @money.should be_zero
    end

    it "should be greater than -$1" do
      @money.should be > McMoney.new("-1.00")
    end

    it "should be greater than or equal to $0" do
      @money.should be >= McMoney.new
    end

    it "should be less than or equal to $0" do
      @money.should be <= McMoney.new
    end

    it "should be less than $1" do
      @money.should be < McMoney.new(1.00)
    end
  end

  describe "with amount of $1" do
    before(:each) do
      @money = McMoney.new(1.00)
    end

    it "should not be zero" do
      @money.should_not be_zero
    end

    it "should have a decimal value = 1.00" do
      @money.value.should == BigDecimal.new("1.00")
    end

    it "should have 100 cents" do
      @money.cents.should == 100
    end

    it "should return cents as a Fixnum" do
      @money.cents.should be_an_instance_of(Fixnum)
    end

    it "should be greater than $0" do
      @money.should be > McMoney.new(0.00)
    end

    it "should be less than $2" do
      @money.should be < McMoney.new(2.00)
    end

    it "should be equal to $1" do
      @money.should == McMoney.new(1.00)
    end
  end

  describe "with amount of $1 with created with 3 decimal places" do
    before(:each) do
      @money = McMoney.new(1.125)
    end

    it "should round 3rd decimal place" do
      @money.value.should == BigDecimal.new("1.13")
    end
  end
end
