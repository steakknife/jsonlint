require 'multi_json'
require 'set'

require 'jsonlint/errors'

module JsonLint
  class Linter
    attr_reader :errors

    def initialize
      @errors = {}
    end

    def check_all(*files_to_check)
      files_to_check.flatten.each { |f| check(f) }
    end

    def check(path)
      fail FileNotFoundError, "#{path}: no such file" unless File.exist?(path)

      valid = false
      File.open(path, 'r') do |f|
        error_array = []
        valid = check_data(f.read, error_array)
        errors[path] = error_array unless error_array.empty?
      end

      valid
    end

    def check_stream(io_stream)
      json_data = io_stream.read
      error_array = []

      valid = check_data(json_data, error_array)
      errors[''] = error_array unless error_array.empty?

      valid
    end

    def errors?
      !errors.empty?
    end

    # Return the number of lint errors found
    def errors_count
      errors.length
    end

    def display_errors
      errors.each do |path, errors|
        puts path
        errors.each do |err|
          puts "  #{err}"
        end
      end
    end

    private

    def check_data(json_data, errors_array)
      valid = check_not_empty?(json_data, errors_array)
      valid &&= check_syntax_valid?(json_data, errors_array)

      valid
    end

    def check_not_empty?(json_data, errors_array)
      if json_data.empty?
        errors_array << 'The JSON should not be an empty string'
        false
      elsif json_data.strip.empty?
        errors_array << 'The JSON should not just be spaces'
        false
      else
        true
      end
    end

    def check_syntax_valid?(json_data, errors_array)
      MultiJson.load(json_data, nilnil: false)
      true
    rescue MultiJson::ParseError => e
      errors_array << e.message
      false
    end
  end
end
