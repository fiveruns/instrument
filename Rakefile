# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

require 'rubygems'
require 'echoe'

Echoe.new 'simple-instrumentation' do |p|
  p.version = '0.8.0'
  p.author = "FiveRuns Development Team"
  p.files = Dir['lib/**/*.rb']
  p.test_files = Dir['test/**/*_test.rb']
  p.email  = 'dev@fiveruns.com'
  p.project = 'fiveruns'
  p.summary = "Simple library providing an API to instrument method invocations."
  p.url = "http://github.com/fiveruns/simple-insrumentation"
  p.dependencies = %w(activesupport)
end