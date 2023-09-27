# frozen_string_literal: true

require_relative 'entry'

class UnrelatedFileContainer
  attr_reader :entries

  def initialize(file_paths)
    @paths = file_paths
  end

  def generate_list_content(opt_param)
    @entries = @paths.map { |path| Entry.new(path) }
    FormatterFactory.create(opt_param).generate_formatted_content(self, opt_param)
  end
end
