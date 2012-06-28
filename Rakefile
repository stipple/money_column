#!/usr/bin/env ruby
require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

task :default => [:spec]

desc "Run all spec examples"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb"
  t.rspec_opts = ['--options', %\"#{File.dirname(__FILE__)}/spec/spec.opts"\]
end
