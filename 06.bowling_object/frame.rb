# frozen_string_literal: true

class Frame
  def self.strike_mark?(mark)
    mark == 'X'
  end

  def initialize(score_marks)
    @shots = score_marks.map do |score_mark|
      Frame.strike_mark?(score_mark) ? 10 : score_mark.to_i
    end
  end

  def calculate_score(next_frame, after_next_frame)
    return base_score if next_frame.nil? && after_next_frame.nil?

    if strike?
      base_score + strike_bonus(next_frame, after_next_frame)
    elsif spare?
      base_score + spare_bonus(next_frame)
    else
      base_score
    end
  end

  protected

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
    @shots[0] == 10
  end

  private

  def spare?
    !strike? && @shots[0..1].sum == 10
  end

  def strike_bonus(next_frame, after_next_frame)
    if after_next_frame.nil?
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
