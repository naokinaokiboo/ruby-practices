# frozen_string_literal: true

require 'test/unit'
require_relative '../game'

class TestGame < Test::Unit::TestCase
  setup do
    @game = Game.new('')
  end

  test '#generate_marks_grouped_by_frameは、スコアを各フレーム毎に配列としてまとめた二次元配列を生成する' do
    assert_equal(
      [%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], %w[X], %w[9 1], %w[8 0], %w[X], %w[6 4 5]],
      @game.send(:generate_marks_grouped_by_frame, %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X 6 4 5])
    )

    assert_equal(
      [%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], %w[X], %w[9 1], %w[8 0], %w[X], %w[X X X]],
      @game.send(:generate_marks_grouped_by_frame, %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X X X])
    )

    assert_equal(
      [%w[0 10], %w[1 5], %w[0 0], %w[0 0], %w[X], %w[X], %w[X], %w[5 1], %w[8 1], %w[0 4]],
      @game.send(:generate_marks_grouped_by_frame, %w[0 10 1 5 0 0 0 0 X X X 5 1 8 1 0 4])
    )

    assert_equal(
      [%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], %w[X], %w[9 1], %w[8 0], %w[X], %w[X 0 0]],
      @game.send(:generate_marks_grouped_by_frame, %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X 0 0])
    )

    assert_equal(
      [%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], %w[X], %w[9 1], %w[8 0], %w[X], %w[X 1 8]],
      @game.send(:generate_marks_grouped_by_frame, %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X 1 8])
    )

    assert_equal(
      [%w[X], %w[X], %w[X], %w[X], %w[X], %w[X], %w[X], %w[X], %w[X], %w[X X X]],
      @game.send(:generate_marks_grouped_by_frame, %w[X X X X X X X X X X X X])
    )

    assert_equal(
      [%w[X], %w[0 0], %w[X], %w[0 0], %w[X], %w[0 0], %w[X], %w[0 0], %w[X], %w[0 0]],
      @game.send(:generate_marks_grouped_by_frame, %w[X 0 0 X 0 0 X 0 0 X 0 0 X 0 0])
    )
  end
end
