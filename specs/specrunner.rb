require "rubygems"
require "bundler/setup"
require "yaml"

Bundler.require(:default)

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


$layout = Haml::Engine.new Layout

class Specrunner < Renee::Application
  app do
    part "specs" do
      var do |package|
        remainder do |file|
          file.gsub! /\.js/, ''
          body = CoffeeScript.compile File.read("./specs/#{package}/#{file}.coffee"), {:bare => true}
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
          file.gsub! /\.js/, ''
          body = CoffeeScript.compile File.read("../source/#{package}/#{file}.coffee"), {:bare => true}
          respond! do 
            status 200
            headers({'Content-Type' => 'text/javascript'})
            body body
          end
        end
      end
    end
    var do |package|
      var do |file|
        puts "#{package}/#{file}" 
        respond! do
          status 200
          headers({'Content-Type' => 'text/html'})
          body $layout.render nil, {:spec => "#{package}/#{file}" }
        end
      end
    end
  end
end
