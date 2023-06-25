#!/usr/bin/env ruby
require 'optparse'
require 'date'

# 表示カレンダーの横幅
CALENDAR_WIDTH = 20

# 日付整形用メソッド
def format_date_display(disp_date, day)
  if disp_date.year == Date.today.year && disp_date.month == Date.today.month && day == Date.today.day
    "\e[30;47m#{day.to_s.rjust(2)}\e[m"  # 反転（白背景に黒文字）
  else
    day.to_s.rjust(2)
  end
end

# コマンドライン引数の取得
begin
  opt_params = ARGV.getopts('y:', 'm:')
rescue OptionParser::MissingArgument => e
  puts e.message
  return
end
opt_y = opt_params["y"]
opt_m = opt_params["m"]

# オプション引数の範囲チェック
if !opt_y.nil? && !(1..9999).include?(opt_y.to_i)
  puts "year `#{opt_y}' not in range 1..9999"
  return
end
if !opt_m.nil? && !(1..12).include?(opt_m.to_i)
  puts  "#{opt_m} is neither a month number (1..12) nor a name"
  return
end

# 表示するカレンダーの年月日と曜日
disp_month = (opt_m != nil) ? opt_m.to_i : Date.today.month
disp_year = (opt_y != nil) ? opt_y.to_i : Date.today.year
disp_date = Date.new(disp_year, disp_month, 1)

# 表示するカレンダーの最終日（=>翌月1日の前日）
last_day = disp_date.next_month.prev_day.day

# カレンダーの年月と曜日の表示
puts "#{disp_month}月 #{disp_year}".center(CALENDAR_WIDTH)
puts "日 月 火 水 木 金 土"

# 1週目の表示
week_index = disp_date.wday                  # 表示月1日の曜日Index（日曜日を0とした0〜6の整数）
days_in_first_week = 7 - week_index          # カレンダー1週目の表示日数（最初の土曜日までの日数）
space_array = Array.new(week_index, " " * 2) # 日付がない空白部分
first_week_array = space_array + (1..days_in_first_week).map{|day| format_date_display(disp_date, day)}
puts first_week_array.join(" ")

# 2週目以降の表示
(days_in_first_week+1..last_day).each_slice(7) do |days|
  fix_days = days.map{|day| format_date_display(disp_date, day)}
  puts fix_days.join(" ")
end
