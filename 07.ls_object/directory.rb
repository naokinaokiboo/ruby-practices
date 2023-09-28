# frozen_string_literal: true

require_relative 'entry'
require_relative 'formatter_factory'

class Directory
  attr_reader :entries, :path

  def initialize(directory_path)
    @path = directory_path
  end

  def generate_list_content(opt_param)
    @entries = generate_entries_by_options(opt_param)
    FormatterFactory.create(self, opt_param).generate_formatted_content
  end

  private

  def generate_entries_by_options(opt_param)
    entries = Dir.entries(path).map { |entry| Entry.new([path, entry].join('/'), entry) }
    filtered_entries =
      if opt_param.show_all?
        entries
      else
        entries.reject { |entry| entry.display_name[0] == '.' }
      end

    if opt_param.sort_reverse?
      filtered_entries.sort_by(&:display_name).reverse
    else
      filtered_entries.sort_by(&:display_name)
    end
  end
end
