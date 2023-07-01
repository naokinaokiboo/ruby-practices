#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_COLUMNS = 3
TERMINAL_WIDTH = `tput cols`.to_i

def main
  targets_for_disp = ARGV.empty? ? [Dir.pwd] : ARGV.sort!

  existent_targets, noexistent_targets = targets_for_disp.partition { |target| File.exist?(target) }
  directories, files = existent_targets.partition { |target| File.ftype(target) == 'directory' }

  noexistent_targets.each { |target| puts "ls: #{target}: No such file or directory" }

  display(files)

  directories.each do |directory|
    puts "\n#{directory}:" if targets_for_disp.size > 1
    entries = Dir.entries(directory).delete_if { |entry| entry[0] == '.' }.sort!
    display(entries)
  end
end

def display(files)
  return if files.empty?

  max_bytes_filename = files.max_by(&:bytesize).bytesize

  num_of_columns = MAX_COLUMNS.downto(1).find { |n| max_bytes_filename * n + (n - 1) <= TERMINAL_WIDTH }
  num_of_rows = (files.size / num_of_columns.to_f).ceil

  matrix = files.each_slice(num_of_rows).to_a
  (num_of_rows - matrix.last.size).times { matrix.last << nil }

  matrix.transpose.each do |subset_files|
    subset_files.each do |file|
      print ljust_for_mbchar(file, max_bytes_filename + 1) unless file.nil?
    end
    puts
  end
end

# 半角英数字以外のファイル名でも表示が崩れないための対応
def ljust_for_mbchar(str, width)
  num_of_mbchar = str.split('').count { |char| char.match?(/[^ -~｡-ﾟ]/) }
  str.ljust(width - num_of_mbchar)
end

main
