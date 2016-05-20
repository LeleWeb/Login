require 'rake/testtask'
require 'sinatra/activerecord' #特别要注意这个，　不加的话无法执行rake命令
require 'sinatra/activerecord/rake'
require 'pry'

task :environment do
  require './app.rb'
end

# load tasks file
Dir.glob('lib/tasks/*.rake').each { |r| load r}

Rake::TestTask.new do |t|
  t.libs.push("./")
  t.test_files = FileList['tests/*.rb']
  t.verbose = true
end

desc "List all routes for this application"
task :routes do
  puts `grep '^[get|post|put|delete].*do$' controllers/*.rb | sed 's/ do$//'`
end

task :default => ["test"]
