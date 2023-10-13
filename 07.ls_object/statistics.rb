# frozen_string_literal: true

module Statistics
  Statistics = Struct.new(
    :total_block_size,
    :nlink_length,
    :owner_name_length,
    :group_name_length,
    :file_size_length
  )

  def generate_statistics
    Statistics.new(
      total_block_size: entries.sum(&:blocks),
      nlink_length: entries.map(&:nlink).max.to_s.length,
      owner_name_length: entries.map(&:owner_name).max_by(&:length).length,
      group_name_length: entries.map(&:group_name).max_by(&:length).length,
      file_size_length: entries.map(&:file_size).max.to_s.length
    )
  end
end
