require "bundler/gem_tasks"
require "rspec/core/rake_task"


RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec


=begin

require 'rubygems'
require 'rake'
require 'rake/testtask'
require File.expand_path('../lib/mongomapper_id2/version', __FILE__)

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/{functional,unit}/**/test_*.rb'
end

namespace :test do
  Rake::TestTask.new(:lint) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/test_active_model_lint.rb'
  end

  task :all => ['test', 'test:lint']
end

task :default => 'test:all'

desc 'Builds the gem'
task :build do
  sh "gem build mongomapper_id2.gemspec"
end

desc 'Builds and installs the gem'
task :install => :build do
  sh "gem install mongomapper_id2-#{MongomapperId2::VERSION}"
end

desc 'Tags version, pushes to remote, and pushes gem'
task :release => :build do
  sh "git tag v#{MongomapperId2::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{MongomapperId2::VERSION}"
  sh "gem push mongomapper_id2-#{MongomapperId2::VERSION}.gem"
end


=end