# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(score)
    @score = score
  end

  def calculate_total_score
    marks = @score.split(',')
    frames = generate_marks_by_frame(marks).map do |marks_in_frame|
      Frame.new(marks_in_frame)
    end

    frames.each_with_index.sum do |frame, i|
      next_frame = frames[i + 1]
      after_next_frame = frames[i + 2]
      frame.calculate_score(next_frame, after_next_frame)
    end
  end

  private

  def generate_marks_by_frame(marks)
    marks_sliced_after_strike =
      marks.slice_when { |left, _right| Frame.strike_mark?(left) }

    marks_by_frame =
      marks_sliced_after_strike.flat_map { |subset_marks| subset_marks.each_slice(2).to_a }

    [*marks_by_frame[..8], marks_by_frame[9..].flatten]
  end
end
