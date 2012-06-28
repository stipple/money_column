module MoneyColumn
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def money_column(*columns)
      options = columns.extract_options! || {}

      decimal_places = options[:decimal_places] || 2

      [columns].flatten.each do |name|
        define_method(name) do
          value = read_attribute(name)
          value.blank? ? nil : McMoney.new(read_attribute(name), options)
        end

        define_method("#{name}_before_type_cast") do
          send(name) && sprintf("%.#{decimal_places}f", read_attribute(name))
        end

        define_method("#{name}=") do |value|
          if value.blank?
            write_attribute(name, nil)
            nil
          else
            money = value.to_money(decimal_places)
            write_attribute(name, money.value)
            money
          end
        end
      end
    end
  end
end
