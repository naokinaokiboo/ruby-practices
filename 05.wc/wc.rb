#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MIN_DISP_DIGITS = 7

def main
  opt_params = ARGV.getopts('lwc')
  count_all = opt_params.values.uniq.size == 1
  count_flags = {
    l: count_all ? true : opt_params['l'],
    w: count_all ? true : opt_params['w'],
    c: count_all ? true : opt_params['c']
  }.freeze

  counters = generate_counters(count_flags)
  counters << generate_total_counter(counters, count_flags) if counters.size > 1
  display(counters, count_flags)
end

def generate_counters(count_flags)
  if ARGV.empty?
    [generate_counter($stdin.read, count_flags)]
  else
    files = ARGV
    files.each_with_object([]) do |file, counters|
      counters << { name: file, exist: false } and next unless File.exist?(file)
      counters << { name: file, exist: true, is_dir: true } and next if File.ftype(file) == 'directory'

      counters << generate_counter(File.read(file), count_flags, file)
    end
  end
end

def generate_counter(contents, count_flags, name = nil)
  {
    name:,
    exist: true,
    is_dir: false,
    lines: count_flags[:l] ? contents.lines.size : nil,
    words: count_flags[:w] ? contents.split(/\s+/).delete_if(&:empty?).size : nil,
    bytes: count_flags[:c] ? contents.bytesize : nil
  }
end

def generate_total_counter(counters, count_flags)
  base = { name: 'total', exist: true, is_dir: false }
  base.default = 0
  counters.each_with_object(base) do |counter, total|
    next unless counter[:exist]
    next if counter[:is_dir]

    total[:lines] += counter[:lines] if count_flags[:l]
    total[:words] += counter[:words] if count_flags[:w]
    total[:bytes] += counter[:bytes] if count_flags[:c]
  end
end

def display(counters, count_flags)
  counters.each do |counter|
    puts "wc: #{counter[:name]}: open: No such file or directory" or next unless counter[:exist]
    puts "wc: #{counter[:name]}: read: Is a directory" or next if counter[:is_dir]

    puts " #{generate_formatted_counter(counter, count_flags).join(' ')}"
  end
end

def generate_formatted_counter(counter, count_flags)
  formatted_counter = []
  formatted_counter << format_counted_value(counter[:lines]) if count_flags[:l]
  formatted_counter << format_counted_value(counter[:words]) if count_flags[:w]
  formatted_counter << format_counted_value(counter[:bytes]) if count_flags[:c]
  formatted_counter << counter[:name]
end

def format_counted_value(count_value)
  count_value_str = count_value.to_s
  count_value_str.size >= MIN_DISP_DIGITS ? count_value_str : count_value_str.rjust(MIN_DISP_DIGITS)
end

main
