# frozen_string_literal: true

require 'test/unit'
require_relative 'common/test_common'
require_relative 'common/test_double_optional_parameter'
require_relative '../ls'

class TestLongFormatter < Test::Unit::TestCase
  include TestCommon

  test 'オプション指定（l）、パス指定（ファイル）' do
    path_args = EXISTENT_FILES
    expected = `ls -l #{path_args.join(' ')}`.chomp

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: false, opt_l: true)
    container = UnrelatedFileContainer.new(path_args)
    container.generate_entries(opt_param)
    long_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, long_formatter.generate_formatted_content)
  end

  test 'オプション指定（a,l）、パス指定（ファイル）' do
    path_args = EXISTENT_FILES
    expected = `ls -al #{path_args.join(' ')}`.chomp

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: false, opt_l: true)
    container = UnrelatedFileContainer.new(path_args)
    container.generate_entries(opt_param)
    long_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, long_formatter.generate_formatted_content)
  end

  test 'オプション指定（r,l）、パス指定（ファイル）' do
    path_args = EXISTENT_FILES
    expected = `ls -rl #{path_args.join(' ')}`.chomp

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: true, opt_l: true)
    container = UnrelatedFileContainer.new(path_args)
    container.generate_entries(opt_param)
    long_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, long_formatter.generate_formatted_content)
  end

  test 'オプション指定（a,r,l）、パス指定（ファイル）' do
    path_args = EXISTENT_FILES
    expected = `ls -arl #{path_args.join(' ')}`.chomp

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: true, opt_l: true)
    container = UnrelatedFileContainer.new(path_args)
    container.generate_entries(opt_param)
    long_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, long_formatter.generate_formatted_content)
  end

  test 'オプション指定（l）、パス指定（ディレクトリ）' do
    dir_path = './'
    expected = `ls -l #{dir_path}`.chomp

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: false, opt_l: true)
    container = Directory.new(dir_path)
    container.generate_entries(opt_param)
    long_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, long_formatter.generate_formatted_content)
  end

  test 'オプション指定（a,l）、パス指定（ディレクトリ）' do
    dir_path = './'
    expected = `ls -al #{dir_path}`.chomp

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: false, opt_l: true)
    container = Directory.new(dir_path)
    container.generate_entries(opt_param)
    long_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, long_formatter.generate_formatted_content)
  end

  test 'オプション指定（r,l）、パス指定（ディレクトリ）' do
    dir_path = './'
    expected = `ls -rl #{dir_path}`.chomp

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: true, opt_l: true)
    container = Directory.new(dir_path)
    container.generate_entries(opt_param)
    long_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, long_formatter.generate_formatted_content)
  end

  test 'オプション指定（a,r,l）、パス指定（ディレクトリ）' do
    dir_path = './'
    expected = `ls -arl #{dir_path}`.chomp

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: true, opt_l: true)
    container = Directory.new(dir_path)
    container.generate_entries(opt_param)
    long_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, long_formatter.generate_formatted_content)
  end
end
