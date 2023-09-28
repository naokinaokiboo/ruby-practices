#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'optional_parameter'
require_relative 'non_existent_container'
require_relative 'unrelated_file_container'
require_relative 'directory'
require_relative 'formatter_factory'

class LS
  def initialize
    @opt_param = OptionalParameter.new
    @paths = ARGV.empty? ? [Dir.pwd] : ARGV.sort
  end

  def generate_content
    generate_containers.each_with_object([]) do |container, result|
      container.generate_entries(opt_param)
      result << "\n#{container.path}:" if container.instance_of?(Directory)
      result << FormatterFactory.create(container, opt_param).generate_formatted_content
    end.join("\n")
  end

  private

  attr_reader :opt_param, :paths

  def sort_with_reverse_option(paths, reverse)
    reverse ? paths.sort.reverse : paths.sort
  end

  def generate_containers
    existent_paths, nonexistent_paths = paths.partition { |path| File.exist?(path) }
    directory_paths, file_paths = existent_paths.partition { |path| File.ftype(path) == 'directory' }
    sorted_file_paths = sort_with_reverse_option(file_paths, opt_param.sort_reverse?)
    sorted_directory_paths = sort_with_reverse_option(directory_paths, opt_param.sort_reverse?)

    containers = []
    containers << NonExistentContainer.new(nonexistent_paths) if nonexistent_paths.any?
    containers << UnrelatedFileContainer.new(sorted_file_paths) if sorted_file_paths.any?
    sorted_directory_paths.each_with_object(containers) do |directory_path, result|
      result << Directory.new(directory_path)
    end
  end
end

puts LS.new().generate_content
