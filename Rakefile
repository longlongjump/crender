require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << '.'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end

task :default => :test
