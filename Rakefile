require 'rake/testtask'
require 'open-uri'
require 'fileutils'
require 'zip/zipfilesystem'
require "sinatra/activerecord/rake"
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
  puts `grep '^[get|post|put|delete].*do$' app/controllers/*.rb | sed 's/ do$//'`
end

task :default => ["test"]
