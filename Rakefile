require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require 'pathname'
require 'json'
require './assets/lib/builder'
require './assets/lib/spec_server'

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen('/dev/null')
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
end

def build
  b = Builder.new()
  compiled = b.build(Dir.glob('./source/**/*.coffee'), "MVC = {}\nLogging = {}\nUtils = {}\n\n", !!ENV['ugly'])
  "(function(Crystal){\n #{compiled} \n })(window.Crystal={Utils:{}})"
end

task :nw do
  File.open('./nw/crystal.js','w+') do |f|
    f.write build()
  end
  p = Process.fork do
    silence_stream(STDERR) do
      `nw ./nw --developer`
    end
  end
  Process.detach p
end

namespace :build do
  task :crystal do
    puts build
  end

  task :specs do
    b = Builder.new()
    puts b.build(Dir.glob('./specs/**/*.coffee'))
  end
end

task :specserver do
  builder = Rack::Builder.new { run SpecSever }
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
  puts `phantomjs assets/vendor/script.coffee http://localhost:5000/`
  Process.kill "KILL", job1
end

task :docs do
  `codo --title "Crystal Documentation" ./source`
end