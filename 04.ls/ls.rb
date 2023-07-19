#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'macxattr' # mac拡張属性取得用の拡張ライブラリ

MAX_COLUMNS = 3
TERMINAL_WIDTH = `tput cols`.to_i
DIGITS_OCTAL_TO_BINARY = 3

module FileType
  S_IFMT   = 0o170000 # bit mask for the file type bit field
  S_IFSOCK = 0o140000 # socket
  S_IFLNK  = 0o120000 # symbolic link
  S_IFREG  = 0o100000 # regular file
  S_IFBLK  = 0o060000 # block device
  S_IFDIR  = 0o040000 # directory
  S_IFCHR  = 0o020000 # character device
  S_IFIFO  = 0o010000 # FIFO
end

module PermissionMask
  READABLE    = 0o4
  WRITABLE    = 0o2
  EXECUTABLE  = 0o1
end

module PermissionUser
  OWNER = 0o700
  GROUP = 0o070
  OTHER = 0o007
end

def main
  opt_params = ARGV.getopts('arl')
  targets = ARGV.empty? ? [Dir.pwd] : ARGV.sort

  existent_targets, noexistent_targets = targets.partition { |target| File.exist?(target) }
  directories, files = existent_targets.partition { |target| File.ftype(target) == 'directory' }
  sorted_files = sort_with_reverse_option(files, opt_params['r'])

  noexistent_targets.each { |target| puts "ls: #{target}: No such file or directory" }

  dispatch_disp_format(sorted_files, opt_params['l'])

  directories.each do |directory|
    puts "\n#{directory}:" if targets.size > 1
    entries = get_entries(directory, opt_params['a'])
    sorted_entries = sort_with_reverse_option(entries, opt_params['r'])
    dispatch_disp_format(sorted_entries, opt_params['l'], directory)
  end
end

def dispatch_disp_format(files, long_format, directory = nil)
  if long_format
    display_with_long_format(files, directory)
  else
    display(files)
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

def get_entries(directory, disp_all)
  Dir.entries(directory).delete_if { |entry| !disp_all && entry[0] == '.' }.sort
end

def sort_with_reverse_option(array, reverse)
  reverse ? array.sort.reverse : array.sort
end

def display_with_long_format(files, directory)
  file_stat_hash = generate_file_stat_hash(files, directory)
  output_total_block_size(file_stat_hash) unless directory.nil?
  output_with_detail_info(file_stat_hash, directory)
end

def generate_file_stat_hash(files, directory)
  file_stat_hash = {}
  files.each do |file|
    file_stat = File.lstat(directory.nil? ? file : [directory, file].join('/'))
    file_stat_hash[file] = file_stat
  end
  file_stat_hash
end

def output_total_block_size(file_stat_hash)
  total_blocks = 0
  file_stat_hash.each do |_file, file_stat|
    total_blocks += file_stat.blocks
  end
  puts "total #{total_blocks}"
end

def output_with_detail_info(file_stat_hash, directory)
  return if file_stat_hash.empty?

  nlink_length = get_max_length_nlink(file_stat_hash)
  owner_name_length = get_max_length_owner_name(file_stat_hash)
  group_name_length = get_max_length_group_name(file_stat_hash)
  file_size_length = get_max_length_file_size(file_stat_hash)

  delimiter = ' '
  file_stat_hash.each do |file, file_stat|
    detail_string = get_file_type_char(file_stat.mode)
    detail_string += get_perission_str(file_stat.mode)
    file_path = directory.nil? ? file : [directory, file].join('/')
    mac_xattr = MacXattr.new
    detail_string += mac_xattr.get_macxattr(file_path) + delimiter
    detail_string += file_stat.nlink.to_s.rjust(nlink_length) + delimiter
    detail_string += Etc.getpwuid(file_stat.uid).name.rjust(owner_name_length) + delimiter * 2
    detail_string += Etc.getgrgid(file_stat.gid).name.rjust(group_name_length) + delimiter * 2
    detail_string += file_stat.size.to_s.rjust(file_size_length) + delimiter
    detail_string += get_modified_time_string(file_stat) + delimiter
    detail_string += file_stat.symlink? ? "#{file} -> #{File.readlink(file_path)}" : file

    puts detail_string
  end
end

def get_max_length_nlink(file_stat_hash)
  file_stat_with_max_nlink = file_stat_hash.max_by { |_file, file_stat| file_stat.nlink }.last
  file_stat_with_max_nlink.nlink.to_s.length
end

def get_max_length_owner_name(file_stat_hash)
  file_stat_with_longest_owner_name = file_stat_hash.max_by { |_file, file_stat| Etc.getpwuid(file_stat.uid).name.to_s.length }.last
  Etc.getpwuid(file_stat_with_longest_owner_name.uid).name.to_s.length
end

def get_max_length_group_name(file_stat_hash)
  file_stat_with_longest_group_name = file_stat_hash.max_by { |_file, file_stat| Etc.getgrgid(file_stat.gid).name }.last
  Etc.getgrgid(file_stat_with_longest_group_name.gid).name.to_s.length
end

def get_max_length_file_size(file_stat_hash)
  file_stat_with_max_file_size = file_stat_hash.max_by { |_file, file_stat| file_stat.size }.last
  file_stat_with_max_file_size.size.to_s.length
end

def get_modified_time_string(file_stat)
  if file_stat.mtime.year == Time.now.year
    file_stat.mtime.strftime('%_2m %_2d %H:%M')
  else
    file_stat.mtime.strftime('%_2m %_2d  %Y')
  end
end

def get_perission_str(mode)
  owner_permission_str = get_permission_attr_str((mode & PermissionUser::OWNER) >> 2 * DIGITS_OCTAL_TO_BINARY)
  group_permission_str = get_permission_attr_str((mode & PermissionUser::GROUP) >> 1 * DIGITS_OCTAL_TO_BINARY)
  other_permission_str = get_permission_attr_str((mode & PermissionUser::OTHER) >> 0 * DIGITS_OCTAL_TO_BINARY)
  [owner_permission_str, group_permission_str, other_permission_str].join
end

def get_permission_attr_str(permission_bits)
  permission_masks = {
    PermissionMask::READABLE => 'r',
    PermissionMask::WRITABLE => 'w',
    PermissionMask::EXECUTABLE => 'x'
  }
  permission_str = ''
  permission_masks.each do |mask, attribute|
    permission_str += mask & permission_bits != 0 ? attribute : '-'
  end
  permission_str
end

def get_file_type_char(mode)
  case FileType::S_IFMT & mode
  when FileType::S_IFSOCK then 's'
  when FileType::S_IFLNK  then 'l'
  when FileType::S_IFREG  then '-'
  when FileType::S_IFBLK  then 'b'
  when FileType::S_IFDIR  then 'd'
  when FileType::S_IFCHR  then 'c'
  when FileType::S_IFIFO  then 'p'
  end
end

main
