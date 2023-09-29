# frozen_string_literal: true

class TestDoubleOptionalParameter
  def initialize(opt_a:, opt_r:, opt_l:)
    @opt_a = opt_a
    @opt_r = opt_r
    @opt_l = opt_l
  end

  def show_all? = @opt_a
  def sort_reverse? = @opt_r
  def long_format? = @opt_l
end
