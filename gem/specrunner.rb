require 'rubygems'
require 'renee'
require 'haml'
require 'coffee-script'

Layout = '''
!!!
%head
  %link{:href => "/vendor/jasmine.css", :rel => "stylesheet", :type => "text/css"}
  %script{:src => "/vendor/jasmine.js", :type => "text/javascript"}
  %script{:src => "/vendor/jasmine-html.js", :type => "text/javascript"}
  %script{:src => "/vendor/require.js", :type => "text/javascript"}
  :javascript
    (function() {
      var jasmineEnv = jasmine.getEnv();
      jasmineEnv.updateInterval = 1000;

      var htmlReporter = new jasmine.HtmlReporter();

      jasmineEnv.addReporter(htmlReporter);

      jasmineEnv.specFilter = function(spec) {
        return htmlReporter.specFilter(spec);
      };

      require.config({
        baseUrl: "/"
      })

      window.onload = function(){
        require(["specs/#{spec}"],function(){
          jasmineEnv.execute();
        })
      }

    })();
%body
'''

Index = '''
!!!
%head
%body
  - files.each do |file|
    %a{:href=>"#{file[:package]}#{file[:file]}"} #{file[:package]}#{file[:file]}
'''

$layout = Haml::Engine.new Layout
$index = Haml::Engine.new Index

class Specrunner < Renee::Application
  app do
    complete do
      files = []
      Dir.glob './specs/**/*' do |f|
        if File.file? f
          filename = File.basename f
          extname = File.extname f
          if extname == '.coffee'
            package = File.dirname(f).split(/\//).last
            files.push({
              :package => if package == '.' then '' else package+"/" end,
              :file => filename.gsub(extname,'')
            })
          end
        end
      end
      respond! do
        status 200
        headers({'Content-Type' => 'text/html'})
        body $index.render nil, {:files => files }
      end
    end
    part "specs" do
      var do |package|
        remainder do |file|
          if file == ".js"
            file = package 
            package = ''
          end
          package += "/"
          file.gsub! /\.js/, ''
          body = CoffeeScript.compile File.read(Dir.pwd+"/specs/#{package}#{file}.coffee"), {:bare => true}
          respond! do 
            status 200
            headers({'Content-Type' => 'text/javascript'})
            body body
          end
        end
      end
    end
    part "source" do
      var do |package|
        remainder do |file|
          if file == ".js"
            file = package 
            package = ''
          end
          package += "/"
          file.gsub! /\.js/, ''
          body = CoffeeScript.compile File.read(Dir.pwd+"/source/#{package}#{file}.coffee"), {:bare => true}
          respond! do 
            status 200
            headers({'Content-Type' => 'text/javascript'})
            body body
          end
        end
      end
    end
    var do |package|
      complete do
        respond! do
          status 200
          headers({'Content-Type' => 'text/html'})
          body $layout.render nil, {:spec => "#{package}" }
        end
      end
      var do |file|
        respond! do
          status 200
          headers({'Content-Type' => 'text/html'})
          body $layout.render nil, {:spec => "#{package}/#{file}" }
        end
      end
    end
  end
end
