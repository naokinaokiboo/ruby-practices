#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = 0
frames.each.with_index(1) do |frame, idx|
  point += frame.sum

  if idx < 10
    next_frame = frames[idx]
    second_next_frame = frames[idx + 1]

    if frame[0] == 10
      if next_frame[0] == 10
        point += next_frame[0]
        point += second_next_frame[0]
      else
        point += next_frame.sum
      end
    elsif frame.sum == 10
      point += next_frame[0]
    end
  end
end

puts point
