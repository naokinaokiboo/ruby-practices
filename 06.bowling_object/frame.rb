# frozen_string_literal: true

MAX_PINS = 10

class Frame
  def initialize(score_marks)
    @shots = score_marks.map do |score_mark|
      score_mark == 'X' ? MAX_PINS : score_mark.to_i
    end
  end

  def base_score
    @shots.sum
  end

  def first_shot
    @shots[0]
  end

  def second_shot
    @shots[1]
  end

  def strike?
    @shots[0] == MAX_PINS
  end

  def spare?
    return false if strike?

    @shots[0] + @shots[1] == MAX_PINS
  end
end
