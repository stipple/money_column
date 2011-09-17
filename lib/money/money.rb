require 'bigdecimal'
require 'bigdecimal/util'

class Money
  include Comparable
  
  attr_reader :value, :cents, :decimal_places

  def initialize(value = 0, options = {})
    @decimal_places = options[:decimal_places] || 2
    raise ArgumentError if value.respond_to?(:nan?) && value.nan?
    
    @value = value_to_decimal(value).round(@decimal_places)
    @cents = (@value * 100).to_i
  end
  
  def <=>(other)
    cents <=> other.to_money.cents
  end
  
  def +(other)
    o = other.to_money
    Money.new(value + o.value, :decimal_places => [decimal_places, o.decimal_places].max)
  end

  def -(other)
    o = other.to_money
    Money.new(value - o.value, :decimal_places => [decimal_places, o.decimal_places].max)
  end
  
  def *(numeric)
    Money.new(value * numeric)
  end
  
  def /(numeric)
    Money.new(value / numeric)
  end
    
  def inspect
    "#<#{self.class} value:#{self.to_s}>"
  end
  
  def ==(other)
    eql?(other)
  end
  
  def eql?(other)
    self.class == other.class && value == other.value
  end
  
  def hash
    value.hash
  end
  
  def self.parse(input, options = {})
    MoneyParser.parse(input, options)
  end
  
  def self.empty
    Money.new
  end
  
  def self.from_cents(cents, options = {})
    Money.new(cents.round.to_f / 100, options)
  end
  
  def to_money(decimal_places = 2)
    self
  end
  
  def zero?
    value.zero?
  end
  
  # dangerous, this *will* shave off all your cents
  def to_i
    value.to_i
  end
  
  def to_f
    value.to_f
  end
  
  def to_s(places = @decimal_places)
    sprintf("%.#{places}f", value.to_f)
  end
  
  def to_liquid
    cents
  end

  def to_json(options = {})
    cents
  end
  
  def abs
    Money.new(value.abs, :decimal_places => @decimal_places)
  end
  
  private
  # poached from Rails
  def value_to_decimal(value)
    # Using .class is faster than .is_a? and
    # subclasses of BigDecimal will be handled
    # in the else clause
    if value.class == BigDecimal
      value
    elsif value.respond_to?(:to_d)
      value.to_d
    else
      value.to_s.to_d
    end
  end
end

