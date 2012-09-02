Layout = '''
!!!
%head
  %link{:href => "/vendor/jasmine.css", :rel => "stylesheet", :type => "text/css"}
  %script{:src => "/vendor/jasmine.js", :type => "text/javascript"}
  %script{:src => "/vendor/jasmine-html.js", :type => "text/javascript"}
  %script{:src => "/crystal.js", :type => "text/javascript"}
  %script{:src => "/specs.js", :type => "text/javascript"}
  :javascript
    (function() {
      var console_reporter = new jasmine.ConsoleReporter()
      var jasmineEnv = jasmine.getEnv();
      jasmineEnv.addReporter(console_reporter);
      window.onload = function(){
        jasmineEnv.execute();
      }

    })();
%body
'''
class SpecSever < Renee::Application
  app do
    path "/crystal.js" do
      respond! do
        headers({'Content-Type' => 'text/javascript'})
        body `rake build:crystal`
      end
    end
    path "/specs.js" do
      respond! do
        headers({'Content-Type' => 'text/javascript'})
        body `rake build:specs`
      end
    end
    part "vendor" do
      remainder do |file|
        type = 'text/css' if file =~ /\.css$/
        type = 'text/javascript' if file =~ /\.js$/
        respond! do
          headers({'Content-Type' => type})
          body File.read('./assets/vendor/'+file)
        end
      end
    end
    respond! do
      headers({'Content-Type' => 'text/html'})
      body Haml::Engine.new(Layout).render
    end
  end
end
