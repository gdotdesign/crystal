Layout = '''
!!!
%head
  %script{:src => "/crystal", :type => "text/javascript"}
  %script{:src => "/js#{name}", :type => "text/javascript"}
%body
  {{file}}
'''
class ExampleServer < Renee::Application
  app do
    path "/crystal" do
      respond! do
        headers({'Content-Type' => 'text/javascript'})
        body `rake build:crystal`
      end
    end
    part "js" do
      remainder do |example|
        puts example
        respond! do
          headers({'Content-Type' => 'text/html'})
          body CoffeeScript.compile File.read("./examples/#{example}/script.coffee")
        end
      end
      respond! do
        headers({'Content-Type' => 'text/javascript'})
        body File.read('./build/crystal.is')
      end
    end
    remainder do |example|
      code = File.read("./examples/#{example}/view.haml")
      html = Layout.gsub '{{file}}', code
      respond! do
        headers({'Content-Type' => 'text/html'})
        body Haml::Engine.new(html).render Object.new, {name: example}
      end
    end
  end
end
