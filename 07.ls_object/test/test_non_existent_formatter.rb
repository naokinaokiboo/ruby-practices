# frozen_string_literal: true

require 'test/unit'
require_relative 'common/test_common'
require_relative 'common/test_double_optional_parameter'
require_relative '../ls'

class TestLongFormatter < Test::Unit::TestCase
  include TestCommon

  test 'オプション指定（なし）' do
    path_args = NON_EXISTENT_FILES
    expected = <<~TEXT.chomp
      ls: ../non_existent_file_101.a: No such file or directory
      ls: ../non_existent_file_102.g: No such file or directory
      ls: ../non_existent_file_103.m: No such file or directory
      ls: ../non_existent_file_104.z: No such file or directory
      ls: ./non_existent_file_1: No such file or directory
      ls: ./non_existent_file_2: No such file or directory
      ls: ./non_existent_file_3: No such file or directory
      ls: ./non_existent_file_4: No such file or directory
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: false, opt_l: false)
    container = NonExistentContainer.new(path_args)
    container.generate_entries(opt_param)
    non_existent_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, non_existent_formatter.generate_formatted_content)
  end

  test 'オプション指定（a, r）' do
    path_args = NON_EXISTENT_FILES
    expected = <<~TEXT.chomp
      ls: ../non_existent_file_101.a: No such file or directory
      ls: ../non_existent_file_102.g: No such file or directory
      ls: ../non_existent_file_103.m: No such file or directory
      ls: ../non_existent_file_104.z: No such file or directory
      ls: ./non_existent_file_1: No such file or directory
      ls: ./non_existent_file_2: No such file or directory
      ls: ./non_existent_file_3: No such file or directory
      ls: ./non_existent_file_4: No such file or directory
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: true, opt_l: false)
    container = NonExistentContainer.new(path_args)
    container.generate_entries(opt_param)
    non_existent_formatter = FormatterFactory.create(container, opt_param)

    assert_equal(expected, non_existent_formatter.generate_formatted_content)
  end
end
