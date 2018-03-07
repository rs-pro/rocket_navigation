require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'RocketNavigation'
  rdoc.options << '--inline-source'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
end
