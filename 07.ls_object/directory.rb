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
    filtered_entries = filter_entries(row_entries, opt_param)
    @entries = sort_entries(filtered_entries, opt_param)
  end

  private

  def filter_entries(unfiltered_entries, opt_param)
    if opt_param.show_all?
      unfiltered_entries
    else
      unfiltered_entries.reject { |entry| entry.display_name.start_with?('.') }
    end
  end

  def sort_entries(unsorted_entries, opt_param)
    if opt_param.sort_reverse?
      unsorted_entries.sort_by(&:display_name).reverse
    else
      unsorted_entries.sort_by(&:display_name)
    end
  end
end
