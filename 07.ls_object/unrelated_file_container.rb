# frozen_string_literal: true

require_relative 'entry'
require_relative 'formatter_factory'

class UnrelatedFileContainer
  attr_reader :entries

  def initialize(file_paths)
    @paths = file_paths
  end

  def generate_list_content(opt_param)
    @entries = generate_entries_by_options(opt_param)
    FormatterFactory.create(self, opt_param).generate_formatted_content
  end

  private

  def generate_entries_by_options(opt_param)
    entries = @paths.map { |path| Entry.new(path) }
    if opt_param.sort_reverse?
      entries.sort_by(&:display_name).reverse
    else
      entries.sort_by(&:display_name)
    end
  end
end
