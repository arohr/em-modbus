require 'bundler/gem_tasks'
require 'rspec/core/rake_task'


task :default => ['spec:coverage']


namespace :spec do

  desc 'Run RSpec code examples with SimpeCov'
  RSpec::Core::RakeTask.new('coverage') do |t|
    ENV['COVERAGE'] = 'true'
  end

end
