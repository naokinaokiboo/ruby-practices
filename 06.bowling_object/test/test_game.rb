# frozen_string_literal: true

require 'test/unit'
require_relative '../game'

class TestGame < Test::Unit::TestCase
  setup do
    @game = Game.new('')
  end

  test '#calculate_total_scoreは、トータルスコアを返す' do
    assert_equal 139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').calculate_total_score
    assert_equal 164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').calculate_total_score
    assert_equal 107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').calculate_total_score
    assert_equal 134, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0').calculate_total_score
    assert_equal 144, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8').calculate_total_score
    assert_equal 300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').calculate_total_score
    assert_equal 50,  Game.new('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0').calculate_total_score
  end
end
