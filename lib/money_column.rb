require File.expand_path('../mc_money', __FILE__)
require File.expand_path('../money_column/money_column', __FILE__)

ActiveRecord::Base.send :include, MoneyColumn
