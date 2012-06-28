class MoneyParser
  ZERO_MONEY = "0.00"

  attr_accessor :decimal_places

  def initialize(options = {})
    @decimal_places = options[:decimal_places] || 2
  end

  # parse a amount from a string
  def self.parse(input, options = {})
    new(options).parse(input, options)
  end

  def parse(input, options = {})
    McMoney.new(extract_money(input), options)
  end

  private
  def extract_money(input)
    return ZERO_MONEY if input.to_s.empty?

    amount = input.scan(/\-?[\d\.\,]+/).first

    return ZERO_MONEY if amount.nil?

    # Convert 0.123 or 0,123 into what will be parsed as a decimal amount 0.12 or 0.13
    amount.gsub!(/^(-)?(0[,.]\d{2,#{@decimal_places}})\d+$/, '\1\2')

    segments = amount.scan(/^(.*?)(?:[\.\,](\d{1,#{@decimal_places}}))?$/).first

    return ZERO_MONEY if segments.empty?

    amount   = segments[0].gsub(/[^-\d]/, '')
    decimals = segments[1].to_s.ljust(@decimal_places, '0')

    "#{amount}.#{decimals}"
  end
end
