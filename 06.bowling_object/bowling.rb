#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './game'

puts Game.new(ARGV[0]).calculate_total_score
