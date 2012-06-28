require File.dirname(__FILE__) + '/spec_helper'

describe MoneyParser do
  describe "parsing of amounts with period decimal separator" do
    before(:each) do
      @parser = MoneyParser.new
    end

    it "should parse an empty string to $0" do
      @parser.parse("").should == McMoney.new
    end

    it "should parse an invalid string to $0" do
      @parser.parse("no money").should == McMoney.new
    end

    it "should parse a single digit integer string" do
      @parser.parse("1").should == McMoney.new(1.00)
    end

    it "should parse a double digit integer string" do
      @parser.parse("10").should == McMoney.new(10.00)
    end

    it "should parse an integer string amount with a leading $" do
      @parser.parse("$1").should == McMoney.new(1.00)
    end

    it "should parse a float string amount" do
      @parser.parse("1.37").should == McMoney.new(1.37)
    end

    it "should parse a float string amount with a leading $" do
      @parser.parse("$1.37").should == McMoney.new(1.37)
    end

    it "should parse a float string with a single digit after the decimal" do
      @parser.parse("10.0").should == McMoney.new(10.00)
    end

    it "should parse a float string with two digits after the decimal" do
      @parser.parse("10.00").should == McMoney.new(10.00)
    end

    it "should parse a float string with three digits after the decimal" do
      @parser.decimal_places = 3
      @parser.parse("10.001", :decimal_places => 3).should == McMoney.new(10.001, :decimal_places => 3)
    end

    it "should parse a float string with four digits after the decimal" do
      @parser.decimal_places = 4
      @parser.parse("10.0017").should == McMoney.new(10.0017)
    end

    it "should parse a float string with five digits after the decimal" do
      @parser.decimal_places = 5
      @parser.parse("10.00172").should == McMoney.new(10.00172)
    end

    it "should parse the amount from an amount surrounded by whitespace and garbage" do
      @parser.parse("Rubbish $1.00 Rubbish").should == McMoney.new(1.00)
    end

    it "should parse the amount from an amount surrounded by garbage" do
      @parser.parse("Rubbish$1.00Rubbish").should == McMoney.new(1.00)
    end

    it "should parse a negative integer amount in the hundreds" do
      @parser.parse("-100").should == McMoney.new(-100.00)
    end

    it "should parse an integer amount in the hundreds" do
      @parser.parse("410").should == McMoney.new(410.00)
    end

    it "should parse a positive amount with a thousands separator" do
      @parser.parse("100,000.00").should == McMoney.new(100_000.00)
    end

    it "should parse a negative amount with a thousands separator" do
      @parser.parse("-100,000.00").should == McMoney.new(-100_000.00)
    end

    it "should parse negative $1.00" do
      @parser.parse("-1.00").should == McMoney.new(-1.00)
    end

    it "should parse a negative cents amount" do
      @parser.parse("-0.90").should == McMoney.new(-0.90)
    end

    it "should parse amount with 3 decimals and 0 dollar amount" do
      @parser.parse("0.123").should == McMoney.new(0.12)
    end

    it "should parse negative amount with 3 decimals and 0 dollar amount" do
      @parser.parse("-0.123").should == McMoney.new(-0.12)
    end

    it "should parse negative amount with multiple leading - signs" do
      @parser.parse("--0.123").should == McMoney.new(-0.12)
    end

    it "should parse negative amount with multiple - signs" do
      @parser.parse("--0.123--").should == McMoney.new(-0.12)
    end
  end

  describe "parsing of amounts with comma decimal separator" do
    before(:each) do
      @parser = MoneyParser.new
    end

    it "should parse dollar amount $1,00 with leading $" do
      @parser.parse("$1,00").should == McMoney.new(1.00)
    end

    it "should parse dollar amount $1,37 with leading $, and non-zero cents" do
      @parser.parse("$1,37").should == McMoney.new(1.37)
    end

    it "should parse the amount from an amount surrounded by whitespace and garbage" do
      @parser.parse("Rubbish $1,00 Rubbish").should == McMoney.new(1.00)
    end

    it "should parse the amount from an amount surrounded by garbage" do
      @parser.parse("Rubbish$1,00Rubbish").should == McMoney.new(1.00)
    end

    it "should parse thousands amount" do
      @parser.parse("1.000").should == McMoney.new(1000.00)
    end

    it "should parse negative hundreds amount" do
      @parser.parse("-100,00").should == McMoney.new(-100.00)
    end

    it "should parse positive hundreds amount" do
      @parser.parse("410,00").should == McMoney.new(410.00)
    end

    it "should parse a positive amount with a thousands separator" do
      @parser.parse("100.000,00").should == McMoney.new(100_000.00)
    end

    it "should parse a negative amount with a thousands separator" do
      @parser.parse("-100.000,00").should == McMoney.new(-100_000.00)
    end

    it "should parse amount with 3 decimals and 0 dollar amount" do
      @parser.parse("0,123").should == McMoney.new(0.12)
    end

    it "should parse negative amount with 3 decimals and 0 dollar amount" do
      @parser.parse("-0,123").should == McMoney.new(-0.12)
    end
  end

  describe "parsing of decimal cents amounts from 0 to 10" do
    before(:each) do
      @parser = MoneyParser.new
    end

    it "should parse 50.0" do
      @parser.parse("50.0").should == McMoney.new(50.00)
    end

    it "should parse 50.1" do
      @parser.parse("50.1").should == McMoney.new(50.10)
    end

    it "should parse 50.2" do
      @parser.parse("50.2").should == McMoney.new(50.20)
    end

    it "should parse 50.3" do
      @parser.parse("50.3").should == McMoney.new(50.30)
    end

    it "should parse 50.4" do
      @parser.parse("50.4").should == McMoney.new(50.40)
    end

    it "should parse 50.5" do
      @parser.parse("50.5").should == McMoney.new(50.50)
    end

    it "should parse 50.6" do
      @parser.parse("50.6").should == McMoney.new(50.60)
    end

    it "should parse 50.7" do
      @parser.parse("50.7").should == McMoney.new(50.70)
    end

    it "should parse 50.8" do
      @parser.parse("50.8").should == McMoney.new(50.80)
    end

    it "should parse 50.9" do
      @parser.parse("50.9").should == McMoney.new(50.90)
    end

    it "should parse 50.10" do
      @parser.parse("50.10").should == McMoney.new(50.10)
    end
  end
end
