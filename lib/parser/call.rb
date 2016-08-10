class CallParser

  attr_accessor :schema

  EXTRACTORS = {
    var_module_mapping: [
      :var,
      :module,
      :method
    ],
    instance_call: [:var, :method],
    module_call: [:module, :method],
  }

  def initialize(file)
    @schema = {}
    counter = 0
    file = File.new(file, "r")
    while (line = file.gets)
      extract(line, counter)
      counter = counter + 1
    end
    file.close
  end

  def analyse!
    @schema[:instance_call].each do |instance_call|
      mapping = instance_call[1]
      var = mapping[0][:var]
      method = mapping[1][:method]

      if indexVarModuleMapping[var]
        puts "#{var} is calling #{method} on #{indexVarModuleMapping[var]}"
      end
    end
  end

  def indexVarModuleMapping
    @_var_module_mapping if @_var_module_mapping
    @var_module_mapping = @schema[:var_module_mapping].each_with_object({}) do |array, hash|
      mapping = array[1]
      var_name = mapping[0][:var]
      module_name = mapping[1][:module]
      hash[var_name] = module_name
    end
  end

  private
  
  def extract(line, line_no)
    EXTRACTORS.each do |method, match_mapping|
      @schema[method] = [] if @schema[method].nil?
      extracted = send("extract_#{method}", line)
      unless extracted.nil?
        @schema[method] << [
          line_no,
          match_mapping.map.with_index { |k, v|
            {
              k => extracted[v+1]
            }
          }
        ]
      end
    end
  end


  def extract_instance_call(line)
    line.strip.match(/^([a-z][a-zA-Z]+)\.([a-z]+)\(?/)
  end

  def extract_module_call(line)
    line.strip.match(/([A-Z][a-zA-Z]+)\.([a-z]+)\(?/)
  end

  def extract_var_module_mapping(line)
    line.strip.match(/(@?[a-zA-Z]+)\s*=\s*([A-Z][a-zA-Z]+)\.([a-z]+)\(?/)
  end
  
end