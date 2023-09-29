# frozen_string_literal: true

class ShortFormatter
  MAX_NUM_OF_COLUMNS = 3

  def initialize(entries)
    @entries = entries
  end

  def generate_formatted_content
    display_names = entries.map(&:display_name)

    max_bytes_of_name = display_names.max_by(&:bytesize).bytesize
    terminal_width = current_terminal_width
    num_of_columns = MAX_NUM_OF_COLUMNS.downto(1).find { |n| max_bytes_of_name * n + (n - 1) <= terminal_width }
    num_of_rows = (display_names.size / num_of_columns.to_f).ceil

    matrix = display_names.each_slice(num_of_rows).to_a

    # transposeするために、要素数を合わせる
    (num_of_rows - matrix.last.size).times { matrix.last << nil }

    matrix.transpose.map do |subset_names|
      subset_names.map do |name|
        ljust_for_mbchar(name, max_bytes_of_name) unless name.nil?
      end.join(' ').rstrip
    end.join("\n")
  end

  private

  attr_reader :entries

  # 半角英数字以外のファイル名でも表示が崩れないための対応
  def ljust_for_mbchar(str, width)
    num_of_mbchar = str.split('').count { |char| char.match?(/[^ -~｡-ﾟ]/) }
    str.ljust(width - num_of_mbchar)
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
