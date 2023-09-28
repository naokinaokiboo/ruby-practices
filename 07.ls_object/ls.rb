#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'optional_parameter'
require_relative 'non_existent_container'
require_relative 'unrelated_file_container'
require_relative 'directory'
require_relative 'formatter_factory'

def main
  opt_param = OptionalParameter.new

  paths = ARGV.empty? ? [Dir.pwd] : ARGV.sort
  existent_paths, nonexistent_paths = paths.partition { |path| File.exist?(path) }
  directory_paths, file_paths = existent_paths.partition { |path| File.ftype(path) == 'directory' }

  sorted_file_paths = sort_with_reverse_option(file_paths, opt_param.sort_reverse?)
  sorted_directory_paths = sort_with_reverse_option(directory_paths, opt_param.sort_reverse?)

  containers = []
  containers << NonExistentContainer.new(nonexistent_paths) if nonexistent_paths.any?
  containers << UnrelatedFileContainer.new(sorted_file_paths) if sorted_file_paths.any?
  sorted_directory_paths.each do |directory_path|
    containers << Directory.new(directory_path)
  end

  result =
    containers.each_with_object([]).with_index do |(container, result), index|
      container.generate_entries(opt_param)
      result << "#{container.path}:" if container.instance_of?(Directory)
      result << FormatterFactory.create(container, opt_param).generate_formatted_content
      result << "\n" if !container.instance_of?(NonExistentContainer) && index != containers.size - 1
    end

  puts result
end

def sort_with_reverse_option(paths, reverse)
  reverse ? paths.sort.reverse : paths.sort
end

main
