require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require 'pathname'
require 'json'
require './lib/builder'
require './lib/spec_server'

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen('/dev/null')
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
end

namespace :build do
  task :crystal do
    b = Builder.new()
    puts b.build(Dir.glob('./source/**/*.coffee'), !!ENV['ugly'])
  end

  task :specs do
    b = Builder.new()
    puts b.build(Dir.glob('./specs/**/*.coffee'))
  end
end

task :specserver do
  builder = Rack::Builder.new do
    use Rack::Static, :urls => ['./vendor'], :root => "./public"
    run SpecSever
  end
  Rack::Handler::Thin.run builder, :Port => 5000
end

task :specs do
  job1 = 0
  silence_stream(STDOUT) do
    job1 = fork do
      exec "rake specserver"
    end
  end
  sleep 5
  Process.detach(job1)
  puts `phantomjs vendor/script.coffee http://localhost:5000/`
  Process.kill "KILL", job1
end