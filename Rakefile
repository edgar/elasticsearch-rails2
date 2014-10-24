require "bundler/gem_tasks"

Dir.glob('tasks/**/*.rake').each(&method(:import))

task :default => :spec
task :test => :spec

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r elasticsearch/rails2.rb"
end