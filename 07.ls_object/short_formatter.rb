# frozen_string_literal: true

class ShortFormatter
  MAX_COLUMNS = 3

  def generate_formatted_content(container, opt_param)
    display_names = generate_diplay_names(container, opt_param)

    max_bytes_of_name = display_names.max_by(&:bytesize).bytesize
    terminal_width = `tput cols`.to_i
    num_of_columns = MAX_COLUMNS.downto(1).find { |n| max_bytes_of_name * n + (n - 1) <= terminal_width }
    num_of_rows = (display_names.size / num_of_columns.to_f).ceil

    matrix = display_names.each_slice(num_of_rows).to_a

    # transposeするために、要素数を合わせる
    (num_of_rows - matrix.last.size).times { matrix.last << nil }

    matrix.transpose.map do |subset_names|
      subset_names.map do |name|
        ljust_for_mbchar(name, max_bytes_of_name) unless name.nil?
      end.join(' ')
    end.join("\n")
  end

  private

  def generate_diplay_names(container, opt_param)
    display_names = container.entries.map(&:display_name)
    filtered_names =
      if opt_param.show_all?
        display_names
      else
        display_names.reject { |name| name[0] == '.' }
      end

    opt_param.sort_reverse? ? filtered_names.sort.reverse : filtered_names.sort
  end

  # 半角英数字以外のファイル名でも表示が崩れないための対応
  def ljust_for_mbchar(str, width)
    num_of_mbchar = str.split('').count { |char| char.match?(/[^ -~｡-ﾟ]/) }
    str.ljust(width - num_of_mbchar)
  end
end
