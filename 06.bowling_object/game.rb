# frozen_string_literal: true

require_relative './frame'

class Game
  NUM_OF_FRAMES = 10

  def initialize(score)
    @score = score
  end

  def calculate_total_score
    marks = @score.split(',')
    frames = generate_marks_by_frame(marks).map do |marks_in_frame|
      Frame.new(marks_in_frame)
    end

    (0..NUM_OF_FRAMES - 1).sum do |frame_idx|
      calculate_frame_score(frame_idx + 1, *frames[frame_idx, 3])
    end
  end

  private

  def generate_marks_by_frame(marks)
    marks_by_strike_or_not =
      marks.slice_when { |left, _right| Frame.strike_mark?(left) }

    marks_by_frame =
      marks_by_strike_or_not.flat_map { |subset_marks| subset_marks.each_slice(2).to_a }

    [*marks_by_frame[..8], marks_by_frame[9..].flatten]
  end

  def calculate_frame_score(frame_no, target_frame, next_frame = nil, after_next_frame = nil)
    return target_frame.base_score if frame_no == NUM_OF_FRAMES

    if target_frame.strike?
      target_frame.base_score + strike_bonus(frame_no, next_frame, after_next_frame)
    elsif target_frame.spare?
      target_frame.base_score + spare_bonus(next_frame)
    else
      target_frame.base_score
    end
  end

  def strike_bonus(frame_no, next_frame, after_next_frame)
    if frame_no == NUM_OF_FRAMES - 1
      next_frame.first_shot + next_frame.second_shot
    elsif next_frame.strike?
      next_frame.first_shot + after_next_frame.first_shot
    else
      next_frame.base_score
    end
  end

  def spare_bonus(next_frame)
    next_frame.first_shot
  end
end
