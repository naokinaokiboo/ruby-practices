# frozen_string_literal: true

require_relative 'entry'
require_relative 'statistics'

class UnrelatedFileContainer
  include Statistics

  attr_reader :entries, :disp_total

  def initialize(file_paths)
    @paths = file_paths
    @disp_total = false
  end

  def generate_entries(opt_param)
    row_entries = @paths.map { |path| Entry.new(path) }
    sorted_entries = row_entries.sort_by(&:display_name)
    @entries = opt_param.sort_reverse? ? sorted_entries.reverse : sorted_entries
  end
end
