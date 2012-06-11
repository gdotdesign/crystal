require 'rest_client'
require 'logger'

module Shard
  class RackAdapter
    def initialize(app)
      @app = app
      @log = ::Logger.new(STDOUT)
      @log.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime}] #{msg}\n"
      end
    end
    
    # resolvePath 'package/file'
    # get from CDN if not found in current working directory
    def resolvePath(path)
      basePath = Pathname.new(Dir.pwd).realpath
      depPath = Pathname.new(path)
      realPath = basePath+depPath
      realPath = realPath.to_s.gsub! /\.js$/, '.coffee'

      if realPath
        if File.file? realPath
          @log.info 'Serving from local file: '+realPath
          return ::CoffeeScript.compile File.read(realPath), {:bare => true} 
        end
      end

      begin
        response = RestClient.get 'http://cdn.crystal.dev/'+depPath.to_s
        if response.code == 200
          @log.info 'Serving from cdn: '+depPath.to_s
          return response.to_str
        end
      rescue
        # rescue for errors
      end
      @log.info 'File not found in either sources: '+path
      false
    end
    
    def call(env)
      contents = self.resolvePath Rack::Request.new(env).path_info.gsub /^\//, ''
      return [200,{'Content-Type' => 'text/javascript'},[contents]] if contents
      @app.call env
    end
  end
end