# frozen_string_literal: true

require_relative 'entry'

class UnrelatedFileContainer
  attr_reader :entries

  def initialize(file_paths)
    @paths = file_paths
  end

  def generate_entries(opt_param)
    row_entries = @paths.map { |path| Entry.new(path) }
    @entries =
      if opt_param.sort_reverse?
        row_entries.sort_by(&:display_name).reverse
      else
        row_entries.sort_by(&:display_name)
      end
  end
end
