# frozen_string_literal: true

class LongFormatter
  def initialize(entries, statistics, disp_total)
    @entries = entries
    @statistics = statistics
    @disp_total = disp_total
  end

  def generate_formatted_content
    contents = disp_total ? ["total #{statistics.total_block_size}"] : []
    entries.each_with_object(contents) do |entry, results|
      results << format_entry(entry)
    end.join("\n")
  end

  private

  attr_reader :entries, :statistics, :disp_total

  def format_entry(entry)
    delimiter = ' '
    [
      entry.file_type,
      entry.permission,
      entry.macxattr + delimiter,
      entry.nlink.to_s.rjust(statistics.nlink_length) + delimiter,
      entry.owner_name.ljust(statistics.owner_name_length) + delimiter * 2,
      entry.group_name.ljust(statistics.group_name_length) + delimiter * 2,
      entry.file_size.to_s.rjust(statistics.file_size_length) + delimiter,
      format_modified_time(entry.modified_time) + delimiter,
      entry.symbolic_link? ? [entry.display_name, ' -> ', entry.symbolic_link].join : entry.display_name
    ].join
  end

  def format_modified_time(time)
    if time.year == Time.now.year
      time.strftime('%_2m %_2d %H:%M')
    else
      time.strftime('%_2m %_2d  %Y')
    end
  end
end
