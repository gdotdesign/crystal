Gem::Specification.new do |gem|
  gem.name        = 'shard'
  gem.version     = '0.0.1'
  
  gem.require_paths = ["./lib"]

  gem.author      = "Szikszai Gusztáv"
  gem.email       = 'cyber.gusztav@gmail.com'
  gem.homepage    = ''
  gem.summary     = "Shard CLI"
  gem.description = "Shard CLI"
  gem.executables = "shard"
  
  gem.files = Dir.glob("**/*").select { |d| d != "shard.gemspec" and File.file?(d)}
  
  gem.add_dependency("renee","0.3.11")
  gem.add_dependency("haml","3.1.6")
  gem.add_dependency("coffee-script","2.2.0")
  gem.add_dependency("commander","~> 4.1.2")
  gem.add_dependency("thin","1.3.1")
end