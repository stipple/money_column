# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "money_column/version"

files = ["README*", "LICENSE", "Gemfile", "init.rb", "Rakefile", "lib/**/*"].map do |glob|
  Dir[glob]
end.flatten

test_files = ["spec/**/*"].map do |glob|
  Dir[glob]
end.flatten

executable_files = ["bin/**/*"].map do |glob|
  Dir[glob]
end.flatten

Gem::Specification.new do |s|
  s.name        = "money_column"
  s.version     = MoneyColumn::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Lütke", "Michael Dungan"]
  s.email       = ["tobi@shopify.com", "mpd@stippleit.com"]
  s.homepage    = "http://blog.leetsoft.com"
  s.summary     = %q{Simplifies dealing with money values in the database.}
  s.description = %q{Rails plugin that makes handling of money values in the database convenient. On assignment the money column will
 parse the input and apply heuristics to normalize oddball user input.}

  s.rubyforge_project = "money_column"

  s.files         = files
  s.test_files    = test_files
  s.executables   = executable_files
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2"
end
