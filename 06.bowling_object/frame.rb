# frozen_string_literal: true

class Frame
  MAX_PINS = 10

  def initialize(score_marks)
    @shots = score_marks.map do |score_mark|
      Frame.strike_mark?(score_mark) ? MAX_PINS : score_mark.to_i
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

  def self.strike_mark?(mark)
    mark == 'X'
  end
end
