require "coverage"

module SpecThisNotThat
  class TestToCodeMapping

    attr_reader :mapping

    def initialize
      @mapping = {}

      all_spec_files = Dir.glob(RSpec.configuration.pattern).uniq
      # .first(1) because ruby crashes when I launch rspec multiple times
      all_spec_files.first(1).each do |spec_file|
        @mapping[spec_file] = get_coverage_result(spec_file)
      end

      @mapping
    end

    def get_coverage_result(spec_file)
      Coverage.start
      RSpec::Core::Runner.run([spec_file], dev_null, dev_null)
      RSpec.clear_examples
      result = Coverage.result

      result.select { |file, _res| file.include?(Dir.pwd) }.reject do |file, _res|
        file.include?(File.join(Dir.pwd, RSpec.configuration.default_path))
      end
    end

    def dev_null
      StringIO.new
    end
  end
end
