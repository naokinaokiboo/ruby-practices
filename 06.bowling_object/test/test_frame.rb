# frozen_string_literal: true

require 'test/unit'
require_relative '../frame'

class TestFrame < Test::Unit::TestCase
  test '#base_scoreはスペアでもストライクでも無い場合、1投目と2投目の合計を返す' do
    frame1 = Frame.new(1, %w[0 0])
    assert_equal 0, frame1.base_score

    frame2 = Frame.new(1, %w[9 0])
    assert_equal 9, frame2.base_score

    frame3 = Frame.new(1, %w[0 1])
    assert_equal 1, frame3.base_score

    frame4 = Frame.new(1, %w[3 4])
    assert_equal 7, frame4.base_score
  end

  test '#base_scoreはスペアの場合、10を返す' do
    frame1 = Frame.new(1, %w[9 1])
    assert_equal 10, frame1.base_score

    frame2 = Frame.new(2, %w[0 10])
    assert_equal 10, frame2.base_score
  end

  test '#base_scoreはストライクの場合、10を返す' do
    frame1 = Frame.new(1, %w[X])
    assert_equal 10, frame1.base_score
  end

  test '#base_scoreは10フレーム目にスペア、またはストライクを出して3投した場合、3投の合計を返す' do
    frame1 = Frame.new(10, %w[0 10 5])
    assert_equal 15, frame1.base_score

    frame2 = Frame.new(10, %w[X 2 8])
    assert_equal 20, frame2.base_score

    frame3 = Frame.new(10, %w[X X X])
    assert_equal 30, frame3.base_score
  end

  test '#first_pinsは1投目の本数を返す' do
    frame1 = Frame.new(1, %w[9 1])
    assert_equal 9, frame1.first_pins

    frame2 = Frame.new(1, %w[X])
    assert_equal 10, frame2.first_pins
  end

  test '#second_pinsは2投目の本数を返す' do
    frame1 = Frame.new(1, %w[9 1])
    assert_equal 1, frame1.second_pins

    frame2 = Frame.new(2, %w[0 10])
    assert_equal 10, frame2.second_pins
  end

  test '#second_pinsは10フレーム目でなくストライクの場合、nilを返す' do
    frame1 = Frame.new(10, %w[X])
    assert_equal nil, frame1.second_pins
  end

  test '#second_pinsは10フレーム目でストライクの場合、2投目の本数を返す' do
    frame1 = Frame.new(10, %w[X X X])
    assert_equal 10, frame1.second_pins
  end

  test '#strike?はフレームの1投目が"X"の場合、trueを返す' do
    frame1 = Frame.new(1, %w[X])
    assert_equal true, frame1.strike?

    frame2 = Frame.new(10, %w[X 4 5])
    assert_equal true, frame2.strike?
  end

  test '#strike?はフレームの1投目が"X"以外の場合、falseを返す' do
    frame1 = Frame.new(1, %w[9 1])
    assert_equal false, frame1.strike?
  end

  test '#spare?は1投目と2投目の合計が10の場合、trueを返す' do
    frame1 = Frame.new(1, %w[9 1])
    assert_equal true, frame1.spare?

    frame2 = Frame.new(1, %w[0 10])
    assert_equal true, frame2.spare?

    frame3 = Frame.new(10, %w[5 5 5])
    assert_equal true, frame3.spare?
  end

  test '#spare?は最初の1投目が"X"の場合、falseを返す' do
    frame1 = Frame.new(1, %w[X])
    assert_equal false, frame1.spare?
  end

  test '#spare?は1投目と2投目の合計が10でない場合、falseを返す' do
    frame1 = Frame.new(1, %w[8 1])
    assert_equal false, frame1.spare?

    frame2 = Frame.new(10, %w[4 3 3])
    assert_equal false, frame2.spare?
  end
end
