# frozen_string_literal: true

require_relative './frame'

NUM_OF_FRAMES = 10

class Game
  def initialize(score)
    @frames = []
    marks = score.split(',')
    generate_marks_grouped_by_frame(marks).each.with_index(1) do |frame_no, marks_in_frame|
      @frames << Frame.new(frame_no, marks_in_frame)
    end
  end

  private

  def generate_marks_grouped_by_frame(marks)
    marks_grouped_by_strike_or_not =
      marks.slice_when { |left, right| left == 'X' || right == 'X' }

    marks_grouped_by_frame =
      marks_grouped_by_strike_or_not.flat_map { |subset_marks| subset_marks.each_slice(2).to_a }

    if marks_grouped_by_frame.size > NUM_OF_FRAMES
      join_to_last_frame(marks_grouped_by_frame)
    else
      marks_grouped_by_frame
    end
  end

  def join_to_last_frame(grouped_marks)
    [*grouped_marks[..(NUM_OF_FRAMES - 2)], grouped_marks[(NUM_OF_FRAMES - 1)..].flatten]
  end
end
