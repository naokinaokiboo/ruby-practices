# frozen_string_literal: true

class NonExistentFormatter
  def initialize(entries)
    @entries = entries
  end

  def generate_formatted_content
    @entries.map do |entry|
      "ls: #{entry.path}: No such file or directory"
    end.join("\n")
  end
end
