require 'bundler'

require 'spec'
require 'spec/rake/spectask'
 
task :default => :spec

desc "Compile treetop files"
task :compile do
  Dir['lib/*.treetop'].each do |f|
    `tt #{f}`
  end
end

desc "Run the specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['-c']
  t.spec_files = Dir['spec/**/*_spec.rb']
  t.verbose = true
end

