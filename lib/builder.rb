class Builder
  attr_reader :files

  def initialize
    @files = []
  end

  def build(files = [], ugly = false)
    files.each do |f|
      add f
    end
    assemble
    compile
    if ugly
      uglify 
    else
      @compiled
    end
  end

  def add(path)
    realpath = Pathname.new(path).realpath
    basePath = Pathname.new(File.dirname(realpath))
    contents = File.read(path)
    m = contents.scan /@requires\s(.*)[\n|\r\$]/
    m.each do |dependency|
      p = basePath+(dependency[0]+".coffee")
      add p unless @files.include? p
    end
    @files.push realpath unless @files.include? realpath
  end

  def assemble
    @contents = ""
    @files.each do |path|
      if File.exists?(path)
        @contents += "\n###\n--------------- #{path}--------------\n###\n"
        @contents += File.read(path)+"\n"
      end
    end
    @contents
  end

  def compile
    @compiled = CoffeeScript.compile(@contents, bare: true)
  end

  def uglify
    @uglified = Uglifier.compile(@compiled)
  end

end