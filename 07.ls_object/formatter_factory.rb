# frozen_string_literal: true

require_relative 'non_existent_formatter'
require_relative 'long_formatter'
require_relative 'short_formatter'

class FormatterFactory
  def self.create(container, opt_param)
    return NonExistentFormatter.new(container.entries) if container.instance_of?(NonExistentContainer)

    if opt_param.long_format?
      LongFormatter.new(container.entries, container.generate_statistics, container.disp_total)
    else
      ShortFormatter.new(container.entries)
    end
  end
end
