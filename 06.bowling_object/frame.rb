# frozen_string_literal: true

MAX_PINS = 10

class Frame
  attr_reader :frame_no

  def initialize(frame_no, score_marks)
    @frame_no = frame_no
    @shots = score_marks.map do |score_mark|
      score_mark == 'X' ? MAX_PINS : score_mark.to_i
    end
  end

  def base_score
    shots.sum
  end

  def first_pins
    shots[0]
  end

  def second_pins
    nil if frame_no != 10 && strike?

    shots[1]
  end

  def strike?
    shots[0] == MAX_PINS
  end

  def spare?
    return false if strike?

    shots[0] + shots[1] == MAX_PINS
  end

  private

  attr_reader :shots
end
