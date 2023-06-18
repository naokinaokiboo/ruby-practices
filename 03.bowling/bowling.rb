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

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, idx|
  point += frame.sum

  if idx + 1 < 10
    if frame[0] == 10 # strike:次の2投を加算する
      if frames[idx + 1][0] == 10 # 次の1投目でstrike
        point += frames[idx + 1][0]
        point += frames[idx + 2][0]
      else
        point += frames[idx + 1].sum
      end
    elsif frame.sum == 10 # spare:次の１投を加算する
      point += frames[idx + 1][0]
    end
  end
end
puts point
