# frozen_string_literal: true

class LongFormatter
  def initialize(entries)
    @entries = entries
  end

  def generate_formatted_content
    nlink_length = entries.map(&:nlink).max.to_s.length
    owner_name_length = entries.map(&:owner_name).max_by(&:length).length
    group_name_length = entries.map(&:group_name).max_by(&:length).length
    file_size_length = entries.map(&:file_size).max.to_s.length
    total_blocks = entries.sum(&:blocks)

    delimiter = ' '
    result_content = ["total #{total_blocks}"]
    entries.each_with_object(result_content) do |entry, result|
      result.push(
        [
          entry.file_type,
          entry.permission,
          entry.macxattr + delimiter,
          entry.nlink.to_s.rjust(nlink_length) + delimiter,
          entry.owner_name.ljust(owner_name_length) + delimiter * 2,
          entry.group_name.ljust(group_name_length) + delimiter * 2,
          entry.file_size.to_s.rjust(file_size_length) + delimiter,
          get_modified_time_string(entry.modified_time) + delimiter,
          entry.symbolic_link? ? [entry.display_name, ' -> ', entry.symbolic_link].join : entry.display_name
        ].join)
    end.join("\n")
  end

  private

  attr_reader :entries

  def get_modified_time_string(time)
    if time.year == Time.now.year
      time.strftime('%_2m %_2d %H:%M')
    else
      time.strftime('%_2m %_2d  %Y')
    end
  end
end
