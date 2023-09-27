# frozen_string_literal: true

require_relative 'non_existent_formatter'
require_relative 'long_formatter'
require_relative 'short_formatter'

class FormatterFactory
  def self.create(opt_param, non_existent: false)
    return NonExistentFormatter.new if non_existent

    opt_param.long_format? ? LongFormatter.new : ShortFormatter.new
  end
end
