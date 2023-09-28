# frozen_string_literal: true

require_relative 'entry'

class NonExistentContainer
  attr_reader :entries

  def initialize(non_existent_paths)
    @paths = non_existent_paths
  end

  def generate_entries(_opt_param)
    @entries = @paths.map { |path| Entry.new(path) }
  end
end
