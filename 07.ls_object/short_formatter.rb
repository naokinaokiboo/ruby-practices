# frozen_string_literal: true

class ShortFormatter
  MAX_NUM_OF_COLUMNS = 3

  def initialize(entries)
    @entry_names = entries.map(&:display_name)
  end

  def generate_formatted_content
    max_name_width = entry_names.max_by(&:bytesize).bytesize
    num_of_rows = calc_num_of_rows(max_name_width)
    generate_rectangular_array(num_of_rows).map do |subset_names|
      subset_names.map do |name|
        ljust_for_mbchar(name, max_name_width) unless name.nil?
      end.join(' ').rstrip
    end.join("\n")
  end

  private

  attr_reader :entry_names

  def generate_rectangular_array(num_of_rows)
    rectangular_array = entry_names.each_slice(num_of_rows).to_a
    rectangular_array[-1] += Array.new(num_of_rows - rectangular_array.last.size) # 内側の配列の要素数を合わせる
    rectangular_array.transpose
  end

  def calc_num_of_rows(max_name_width)
    terminal_width = current_terminal_width
    num_of_columns = MAX_NUM_OF_COLUMNS.downto(1).find { |n| max_name_width * n + (n - 1) <= terminal_width }
    (entry_names.size / num_of_columns.to_f).ceil
  end

  # 半角英数字以外のファイル名でも表示が崩れないための対応
  def ljust_for_mbchar(name, width)
    num_of_mbchar = name.split('').count { |char| char.match?(/[^ -~｡-ﾟ]/) }
    name.ljust(width - num_of_mbchar)
  end

  def current_terminal_width
    if @terminal_width_for_test
      # 自動テスト用の分岐 : set_terminal_widhで幅を設定後、1度だけ設定した幅を使用する
      @terminal_width_for_test.tap { @terminal_width_for_test = nil }
    else
      `tput cols`.to_i
    end
  end

  # 自動テスト用メソッド（ターミナルの幅を仮設定する）
  def terminal_width_for_test(width)
    @terminal_width_for_test = width
  end
end
