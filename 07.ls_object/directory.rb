# frozen_string_literal: true

require_relative 'entry'

class Directory
  def initialize(directory_path)
    @path = directory_path
  end

  def generate_list_content(opt_param)
    @entries =
      Dir.entries(@path).map { |entry| Entry.new(path, entry) }
  end
end
