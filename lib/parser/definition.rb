class DefinitionParser

  attr_accessor :schema

  EXTRACTORS = [
    :class,
    :def
  ]

  def initialize(file)
    @schema = {}
    counter = 0
    file = File.new(file, "r")
    while (line = file.gets)
      extract(line)
      counter = counter + 1
    end
    file.close
  end

  private
  
  def extract(line)
    EXTRACTORS.each do |method|
      @schema[method] = [] if @schema[method].nil?
      extracted = send("extract_#{method}", line)
      @schema[method] << extracted[1] unless extracted.nil?
    end
  end

  def extract_class(line)
    line.match(/class\s+([A-Z][a-zA-Z]+)/)
  end

  def extract_def(line)
    line.match(/def\s+([a-zA-Z]+)\([^)]+\)/)
  end
  
end