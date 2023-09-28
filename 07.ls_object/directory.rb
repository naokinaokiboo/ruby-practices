# frozen_string_literal: true

require_relative 'entry'
require_relative 'statistics'

class Directory
  include Statistics

  attr_reader :entries, :disp_total, :path

  def initialize(directory_path)
    @path = directory_path
    @disp_total = true
  end

  def generate_entries(opt_param)
    row_entries = Dir.entries(path).map { |entry| Entry.new([path, entry].join('/'), entry) }
    filtered_entries =
      if opt_param.show_all?
        row_entries
      else
        row_entries.reject { |entry| entry.display_name[0] == '.' }
      end

    @entries =
      if opt_param.sort_reverse?
        filtered_entries.sort_by(&:display_name).reverse
      else
        filtered_entries.sort_by(&:display_name)
      end
  end
end
