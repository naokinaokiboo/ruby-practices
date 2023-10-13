# frozen_string_literal: true

module TestCommon
  NON_EXISTENT_FILES = %w[
    ./non_existent_file_1
    ./non_existent_file_2
    ./non_existent_file_3
    ./non_existent_file_4
    ../non_existent_file_101.a
    ../non_existent_file_102.g
    ../non_existent_file_103.m
    ../non_existent_file_104.z
  ].freeze

  EXISTENT_FILES = %w[
    ./directory.rb
    ./file_permission.rb
    ./non_existent_container.rb
    ./short_formatter.rb
    ./statistics.rb
    ./file_type.rb
    long_formatter.rb
    ls.rb
    non_existent_formatter.rb
    formatter_factory.rb
    entry.rb
    unrelated_file_container.rb
    optional_parameter.rb
  ].freeze

  DIRECTORIES = %w[
    ./
    ../
  ].freeze
end
