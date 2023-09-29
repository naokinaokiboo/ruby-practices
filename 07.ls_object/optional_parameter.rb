# frozen_string_literal: true

require 'optparse'

class OptionalParameter
  def initialize
    optional_args = ARGV.getopts('arl')
    @opt_a = optional_args['a']
    @opt_r = optional_args['r']
    @opt_l = optional_args['l']
  end

  def show_all? = @opt_a

  def sort_reverse? = @opt_r

  def long_format? = @opt_l
end
