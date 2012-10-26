class ExampleServer < Renee::Application
  app do
    path "/crystal" do
      respond! do
        headers({'Content-Type' => 'text/javascript'})
        body `rake build:crystal`
      end
    end
    part "style" do
      remainder do |example|
        respond! do
          headers({'Content-Type' => 'text/css'})
          body Sass::Engine.new(File.read("./examples/#{example}/style.sass")).render()
        end
      end
    end
    part "js" do
      remainder do |example|
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
      respond! do
        headers({'Content-Type' => 'text/html'})
        body Haml::Engine.new(code).render(Object.new)
      end
    end
  end
end
