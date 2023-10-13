# frozen_string_literal: true

require 'test/unit'
require_relative 'common/test_common'
require_relative 'common/test_double_optional_parameter'
require_relative '../ls'

class TestShortFormatter < Test::Unit::TestCase
  include TestCommon

  test 'オプション指定（なし）、パス指定（ファイル）、列数（1）' do
    expected = <<~TEXT.chomp
      ./directory.rb
      ./file_permission.rb
      ./file_type.rb
      ./non_existent_container.rb
      ./short_formatter.rb
      ./statistics.rb
      entry.rb
      formatter_factory.rb
      long_formatter.rb
      ls.rb
      non_existent_formatter.rb
      optional_parameter.rb
      unrelated_file_container.rb
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: false, opt_l: false)
    container = UnrelatedFileContainer.new(EXISTENT_FILES)
    container.generate_entries(opt_param)
    short_formatter = FormatterFactory.create(container, opt_param)
    short_formatter.send(:terminal_width_for_test, 40)

    assert_equal(expected, short_formatter.generate_formatted_content)
  end

  test 'オプション指定（a）、パス指定（ファイル）、列数（1）' do
    expected = <<~TEXT.chomp
      ./directory.rb
      ./file_permission.rb
      ./file_type.rb
      ./non_existent_container.rb
      ./short_formatter.rb
      ./statistics.rb
      entry.rb
      formatter_factory.rb
      long_formatter.rb
      ls.rb
      non_existent_formatter.rb
      optional_parameter.rb
      unrelated_file_container.rb
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: false, opt_l: false)
    container = UnrelatedFileContainer.new(EXISTENT_FILES)
    container.generate_entries(opt_param)
    short_formatter = FormatterFactory.create(container, opt_param)
    short_formatter.send(:terminal_width_for_test, 40)

    assert_equal(expected, short_formatter.generate_formatted_content)
  end

  test 'オプション指定（r）、パス指定（ファイル）、列数（2）' do
    expected = <<~TEXT.chomp
      unrelated_file_container.rb ./statistics.rb
      optional_parameter.rb       ./short_formatter.rb
      non_existent_formatter.rb   ./non_existent_container.rb
      ls.rb                       ./file_type.rb
      long_formatter.rb           ./file_permission.rb
      formatter_factory.rb        ./directory.rb
      entry.rb
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: true, opt_l: false)
    container = UnrelatedFileContainer.new(EXISTENT_FILES)
    container.generate_entries(opt_param)
    short_formatter = FormatterFactory.create(container, opt_param)
    short_formatter.send(:terminal_width_for_test, 70)

    assert_equal(expected, short_formatter.generate_formatted_content)
  end

  test 'オプション指定（a, r）、パス指定（ファイル）、列数（3）' do
    expected = <<~TEXT.chomp
      unrelated_file_container.rb formatter_factory.rb        ./file_type.rb
      optional_parameter.rb       entry.rb                    ./file_permission.rb
      non_existent_formatter.rb   ./statistics.rb             ./directory.rb
      ls.rb                       ./short_formatter.rb
      long_formatter.rb           ./non_existent_container.rb
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: true, opt_l: false)
    container = UnrelatedFileContainer.new(EXISTENT_FILES)
    container.generate_entries(opt_param)
    short_formatter = FormatterFactory.create(container, opt_param)
    short_formatter.send(:terminal_width_for_test, 120)

    assert_equal(expected, short_formatter.generate_formatted_content)
  end

  test 'オプション指定（なし）、パス指定（ディレクトリ）、列数（1）' do
    expected = <<~TEXT.chomp
      Gemfile
      Gemfile.lock
      directory.rb
      entry.rb
      extconf.rb
      file_permission.rb
      file_type.rb
      formatter_factory.rb
      long_formatter.rb
      ls.rb
      macxattr.c
      non_existent_container.rb
      non_existent_formatter.rb
      optional_parameter.rb
      short_formatter.rb
      statistics.rb
      test
      unrelated_file_container.rb
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: false, opt_l: false)
    container = Directory.new('./')
    container.generate_entries(opt_param)
    short_formatter = FormatterFactory.create(container, opt_param)
    short_formatter.send(:terminal_width_for_test, 50)

    assert_equal(expected, short_formatter.generate_formatted_content)
  end

  test 'オプション指定（a）、パス指定（ディレクトリ）、列数（1）' do
    expected = <<~TEXT.chomp
      .
      ..
      .gitkeep
      .rubocop.yml
      Gemfile
      Gemfile.lock
      directory.rb
      entry.rb
      extconf.rb
      file_permission.rb
      file_type.rb
      formatter_factory.rb
      long_formatter.rb
      ls.rb
      macxattr.c
      non_existent_container.rb
      non_existent_formatter.rb
      optional_parameter.rb
      short_formatter.rb
      statistics.rb
      test
      unrelated_file_container.rb
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: false, opt_l: false)
    container = Directory.new('./')
    container.generate_entries(opt_param)
    short_formatter = FormatterFactory.create(container, opt_param)
    short_formatter.send(:terminal_width_for_test, 50)

    assert_equal(expected, short_formatter.generate_formatted_content)
  end

  test 'オプション指定（r）、パス指定（ディレクトリ）、列数（2）' do
    expected = <<~TEXT.chomp
      unrelated_file_container.rb long_formatter.rb
      test                        formatter_factory.rb
      statistics.rb               file_type.rb
      short_formatter.rb          file_permission.rb
      optional_parameter.rb       extconf.rb
      non_existent_formatter.rb   entry.rb
      non_existent_container.rb   directory.rb
      macxattr.c                  Gemfile.lock
      ls.rb                       Gemfile
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: false, opt_r: true, opt_l: false)
    container = Directory.new('./')
    container.generate_entries(opt_param)
    short_formatter = FormatterFactory.create(container, opt_param)
    short_formatter.send(:terminal_width_for_test, 80)

    assert_equal(expected, short_formatter.generate_formatted_content)
  end

  test 'オプション指定（a,r）、パス指定（ディレクトリ）、列数（3）' do
    expected = <<~TEXT.chomp
      unrelated_file_container.rb ls.rb                       Gemfile.lock
      test                        long_formatter.rb           Gemfile
      statistics.rb               formatter_factory.rb        .rubocop.yml
      short_formatter.rb          file_type.rb                .gitkeep
      optional_parameter.rb       file_permission.rb          ..
      non_existent_formatter.rb   extconf.rb                  .
      non_existent_container.rb   entry.rb
      macxattr.c                  directory.rb
    TEXT

    opt_param = TestDoubleOptionalParameter.new(opt_a: true, opt_r: true, opt_l: false)
    container = Directory.new('./')
    container.generate_entries(opt_param)
    short_formatter = FormatterFactory.create(container, opt_param)
    short_formatter.send(:terminal_width_for_test, 100)

    assert_equal(expected, short_formatter.generate_formatted_content)
  end
end
