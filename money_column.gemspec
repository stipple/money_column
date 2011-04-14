# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "money_column/version"

Gem::Specification.new do |s|
  s.name        = "money_column"
  s.version     = MoneyColumn::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Lütke"]
  s.email       = ["tobi@shopify.com"]
  s.homepage    = "http://blog.leetsoft.com"
  s.summary     = %q{Simplifies dealing with money values in the database.}
  s.description = %q{Rails plugin that makes handling of money values in the database convenient. On assignment the money column will
 parse the input and apply heuristics to normalize oddball user input.}

  s.rubyforge_project = "money_column"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
