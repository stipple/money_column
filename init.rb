require 'mc_money' 
require 'money_column'

ActiveRecord::Base.send :include, MoneyColumn
