require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require 'pathname'
require 'json'
require './assets/lib/builder'

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen('/dev/null')
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
end

def build(exclude = /^$/)
  b = Builder.new(exclude)
  compiled = b.build(Dir.glob('./source/**/*.coffee'), "MVC = {}\nLogging = {}\nUtils = {}\nStore = {}\n\n",)
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
  task :nw do
    puts build
  end
  task :crystal do
    puts build(/nw\//)
  end

  task :specs do
    b = Builder.new()
    puts b.build(Dir.glob('./specs/**/*.coffee'))
  end
end

task :specserver do
  require './assets/lib/spec_server'
  builder = Rack::Builder.new { run SpecSever }
  Rack::Handler::Thin.run builder, :Port => 5000
end

task :examples do
  require './assets/lib/example_server'
  statics = Dir.glob("./assets/*/").map {|dir| "/"+File.basename(dir)}
  builder = Rack::Builder.new { 
    use Rack::Static, :urls => statics, :root => "./assets"
    run ExampleServer
  }
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