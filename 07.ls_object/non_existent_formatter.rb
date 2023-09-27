# frozen_string_literal: true

class NonExistentFormatter
  def generate_formatted_content(container, opt_param)
    container.entries.map do |entry|
      "ls: #{entry.path}: No such file or direcotry"
    end.join("\n")
  end
end
