require "rubygems"
require "bundler/setup"
Bundler.require(:default)

use Rack::Static, :urls => ['/images', '/font','/js'], :root => 'public'
use Rack::Session::Cookie, :secret => "ink is awesome"
use Rack::MethodOverride
use Rack::Deflater


module RouteHelpers

  def haml(page, options={}, &block)
    opts = {
      :ugly => true,
      :locals => {}
    }.merge! options
    if block
      opts[:locals][:more] = block.call()
    end
    render page.to_s+".haml", opts
  end

  def haml!(page,options={}, &block)
    opts = {
      :layout => if request.xhr? then false else 'layout.haml' end,
      :ugly => true
    }.merge! options
    halt haml page, opts, &block
  end

  def sass(page)
    a = render "../stylesheets/"+page.to_s+".sass"
    respond! do
      status 200
      headers({
        :"Content-Type" => "text/css",
      })
      body a
    end
  end
end

class Site < Renee::Application
  include RouteHelpers
  setup do
   views_path "./views"
  end
  app do

    @types = {
      'new' => '::',
      'fn' => '$',
      'prop' => '#',
      'self' => '@'
    }
    @docs = YAML.load_file('./docs.yml')

    @path_info = request.path_info

    path "/example.json" do
      respond! do
        headers({"Content-Type" => "text/json"})
        body({message: 'May the force be with you!'}.to_json)
      end
    end

    complete do
      haml! :index
    end

    path "/style.css" do
      sass :index
    end

    path "/help" do
      haml! :help
    end

    haml! :notfound
  end
end

run Site