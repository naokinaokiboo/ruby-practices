#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'optional_parameter'
require_relative 'non_existent_container'
require_relative 'unrelated_file_container'
require_relative 'directory'
require_relative 'formatter_factory'

class LS
  def initialize(opt_param, paths)
    @opt_param = opt_param
    @paths = paths
  end

  def generate_content
    containers = generate_containers
    containers.map do |container|
      container.generate_entries(opt_param)
      subset_content = []
      subset_content << "#{container.path}:\n" if container.instance_of?(Directory) && containers.size > 1
      subset_content << FormatterFactory.create(container, opt_param).generate_formatted_content
      subset_content << "\n" unless container.instance_of?(NonExistentContainer)
      subset_content.join
    end.join("\n")
  end

  private

  attr_reader :opt_param, :paths

  def generate_containers
    existent_paths, nonexistent_paths = paths.partition { |path| File.exist?(path) }
    directory_paths, file_paths = existent_paths.partition { |path| File.ftype(path) == 'directory' }
    sorted_file_paths = sort_with_reverse_option(file_paths, opt_param.sort_reverse?)
    sorted_directory_paths = sort_with_reverse_option(directory_paths, opt_param.sort_reverse?)

    containers = []
    containers << NonExistentContainer.new(nonexistent_paths) unless nonexistent_paths.empty?
    containers << UnrelatedFileContainer.new(sorted_file_paths) unless sorted_file_paths.empty?
    sorted_directory_paths.each_with_object(containers) do |directory_path, result|
      result << Directory.new(directory_path)
    end
  end

  def sort_with_reverse_option(paths, reverse)
    reverse ? paths.sort.reverse : paths.sort
  end
end

if __FILE__ == $PROGRAM_NAME
  opt_param = OptionalParameter.new
  paths = ARGV.empty? ? [Dir.pwd] : ARGV
  puts LS.new(opt_param, paths).generate_content
end
