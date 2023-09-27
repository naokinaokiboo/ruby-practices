# frozen_string_literal: true

require_relative 'entry'

class UnrelatedFileContainer
  def initialize(file_paths)
    @paths = file_paths
  end

  def generate_list_content(opt_param)
    @entries = @paths.map { |path| Entry.new(path) }
  end
end
