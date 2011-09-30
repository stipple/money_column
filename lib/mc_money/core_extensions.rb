# Allows Writing of 100.to_money for +Numeric+ types
#   100.to_money => #<McMoney @cents=10000>
#   100.37.to_money => #<McMoney @cents=10037>
class Numeric
  def to_money(decimal_places = 2)
    McMoney.new(self, :decimal_places => decimal_places)
  end
end

# Allows Writing of '100'.to_money for +String+ types
# Excess characters will be discarded
#   '100'.to_money => #<McMoney @cents=10000>
#   '100.37'.to_money => #<McMoney @cents=10037>
class String
  def to_money(decimal_places = 2)
    empty? ? McMoney.empty : McMoney.parse(self, :decimal_places => decimal_places)
  end
end
