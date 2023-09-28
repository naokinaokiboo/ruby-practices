# frozen_string_literal: true

require_relative 'entry'
require_relative 'formatter_factory'

class NonExistentContainer
  attr_reader :entries

  def initialize(non_existent_paths)
    @paths = non_existent_paths
  end

  def generate_list_content(opt_param)
    @entries = @paths.map { |path| Entry.new(path) }
    FormatterFactory.create(self, opt_param).generate_formatted_content
  end
end
