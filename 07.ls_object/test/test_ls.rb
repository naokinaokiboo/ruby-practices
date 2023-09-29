# frozen_string_literal: true

require 'test/unit'
require_relative 'common/test_common'
require_relative 'common/test_double_optional_parameter'
require_relative '../ls'

class TestLS < Test::Unit::TestCase
  include TestCommon

  test 'オプション指定（a, r, l）、パス指定（存在するファイル、ディレクトリ）' do
    args = [*EXISTENT_FILES, *DIRECTORIES]
    expected = `ls -arl #{args.join(' ')}`

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: true, opt_l: true)
    ls = LS.new(opt_param, args)

    assert_equal(expected, ls.generate_content)
  end

  test 'オプション指定（a, l）、指定（存在するディレクトリ）' do
    args = DIRECTORIES
    expected = `ls -al #{args.join(' ')}`

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: false, opt_l: true)
    ls = LS.new(opt_param, args)

    assert_equal(expected, ls.generate_content)
  end

  test 'オプション指定（r, l）、指定（存在するファイル）' do
    args = EXISTENT_FILES
    expected = `ls -rl #{args.join(' ')}`

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: true, opt_l: true)
    ls = LS.new(opt_param, args)

    assert_equal(expected, ls.generate_content)
  end

  test 'オプション指定（l）、指定（なし）' do
    expected = `ls -l`

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: false, opt_l: true)
    ls = LS.new(opt_param, [Dir.pwd])

    assert_equal(expected, ls.generate_content)
  end
end
