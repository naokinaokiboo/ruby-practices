# frozen_string_literal: true

require 'optparse'

class OptionalParameter
  def initialize
    optional_args = ARGV.getopts('arl')
    @show_all = optional_args['a']
    @sort_reverse = optional_args['r']
    @long_format = optional_args['l']
  end

  def show_all? = @show_all

  def sort_reverse? = @sort_reverse

  def long_format? = @long_format
end
