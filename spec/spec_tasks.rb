require 'rake/testtask'

Rake::TestTask.new('test:middleware') do |test|
  test.pattern = 'spec/rack-modernizer_spec.rb'
  test.verbose = true
end

desc 'Run application test suite'
task 'test' => "test:middleware"