Layout = '''
!!!
%head
  %link{:href => "/vendor/jasmine.css", :rel => "stylesheet", :type => "text/css"}
  %script{:src => "/vendor/jasmine.js", :type => "text/javascript"}
  %script{:src => "/vendor/jasmine-html.js", :type => "text/javascript"}
  %script{:src => "/vendor/jasmine-console.js", :type => "text/javascript"}
  %script{:src => "/crystal.js", :type => "text/javascript"}
  %script{:src => "/specs.js", :type => "text/javascript"}
  :javascript
    var console_reporter = new jasmine.ConsoleReporter()
    var jasmineEnv = jasmine.getEnv();
    var htmlReporter = new jasmine.HtmlReporter();
    jasmineEnv.addReporter(console_reporter);
    jasmineEnv.addReporter(htmlReporter);
    jasmineEnv.specFilter = function(spec) {
      return htmlReporter.specFilter(spec);
    };
    window.onload = function(){
      jasmineEnv.execute();
    }
%body
'''

Store = {}

class SpecSever < Renee::Application
  app do

    def say(data = "")
      respond! do
        status 200
        headers({
          :"Content-Type" => "text/json",
        })
        body data.to_json
      end
    end

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

    types = {
      js: "text/javascript",
      json: "text/json",
      xml: "text/xml",
      html: "text/html"
    }

    part "XHR" do
      query :key do |key|
        if key.empty?
          say false
        end
        get do
          if v = Store[key]
            say v
          end
          say false
        end
        post do
          query :value do |value|
            if value
              Store[key] = value
              say true
            end
            say false            
          end
        end
        delete do
          unless Store.has_key?(key)
            say false
          end
          Store.delete(key)
          say true
        end
      end
      say Store.keys
    end

    path "/xhr" do
      contentType = "text/plain"
      types.each do |key,type|
        extension key.to_s do
          contentType = type
        end
      end
      unless request.params.empty?
        body = request.params.to_json 
        respond! do
          headers({'Content-Type' => contentType})
          body body
        end 
      end
      body = request.request_method
      respond! do
        headers({'Content-Type' => contentType})
        body body
      end 
    end
    respond! do
      headers({'Content-Type' => 'text/html'})
      body Haml::Engine.new(Layout).render
    end
  end
end
