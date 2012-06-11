require 'rubygems'
require 'renee'
require 'haml'
require 'coffee-script'
require 'json'

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
        require(#{specs},function(){
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
  %a{:href=>"/all"} Run all specs
  %ul
    - files.each do |file|
      %li
        %a{:href=>"#{file[:package]}#{file[:file]}"} #{file[:package]}#{file[:file]}
'''

$layout = Haml::Engine.new Layout
$index = Haml::Engine.new Index
module Shard
  class SpecSever < Renee::Application
    app do
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
      part 'all' do
        specs = []
        files.each do |f| 
          specs.push 'specs/'+f[:package]+f[:file]
        end
        respond! do
          status 200
          headers({'Content-Type' => 'text/html'})
          body $layout.render nil, {:specs => specs.to_json }
        end
      end
      complete do
        respond! do
          status 200
          headers({'Content-Type' => 'text/html'})
          body $index.render nil, {:files => files }
        end
      end
      var do |package|
        complete do
          respond! do
            status 200
            headers({'Content-Type' => 'text/html'})
            body $layout.render nil, {:specs => ["specs/#{package}"].to_json }
          end
        end
        var do |file|
          respond! do
            status 200
            headers({'Content-Type' => 'text/html'})
            body $layout.render nil, {:specs => ["specs/#{package}/#{file}"].to_json }
          end
        end
      end
    end
  end
end