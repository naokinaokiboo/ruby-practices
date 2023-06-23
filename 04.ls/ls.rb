#!/usr/bin/env ruby
# frozen_string_literal: true

@max_columns = 3
@terminal_width = `tput cols`.to_i

# 半角英数字以外のファイル名でも表示が崩れないための対応
def ljust_for_mbchar(str, width)
  num_of_mbchar = str.split('').count { |char| char.match?(/[^ -~｡-ﾟ]/) }
  str.ljust(width - num_of_mbchar)
end

def display(files)
  return if files.empty?

  max_bytes_filename = files.max_by(&:bytesize).bytesize

  num_of_columns = @max_columns.downto(1).find { |n| max_bytes_filename * n + (n - 1) <= @terminal_width }
  num_of_rows = (files.size / num_of_columns.to_f).ceil

  matrix = files.each_slice(num_of_rows).map { |subset_files| subset_files }
  (num_of_rows - matrix.last.size).times { matrix.last << nil }

  matrix.transpose.each do |subset_files|
    subset_files.each do |file|
      print ljust_for_mbchar(file, max_bytes_filename + 1) unless file.nil?
    end
    print "\n"
  end
end

targets_for_disp = ARGV.empty? ? [Dir.pwd] : ARGV.sort!

existent_targets, noexistent_targets = targets_for_disp.partition { |target| File.exist?(target) }
files = existent_targets.reject { |target| File.ftype(target) == 'directory' }
directories = existent_targets.select { |target| File.ftype(target) == 'directory' }

noexistent_targets.each { |target| puts "ls: #{target}: No such file or directory" }

display(files)

directories.each do |directory|
  puts "\n#{directory}:" if targets_for_disp.size > 1
  entries = Dir.entries(directory).delete_if { |entry| entry[0] == '.' }.sort!
  display(entries)
end
