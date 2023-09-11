#!/usr/bin/env ruby

require_relative './game'

puts Game.new(ARGV[0]).calculate_total_score
