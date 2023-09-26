#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  opt_params = ARGV.getopts('arl')
  targets = ARGV.empty? ? [Dir.pwd] : ARGV.sort
  existent_targets, noexistent_targets = targets.partition { |target| File.exist?(target) }
  directories, files = existent_targets.partition { |target| File.ftype(target) == 'directory' }

  # TODO
  # 各Pathクラスから文字列作成(形式はFormatterクラスの責務とする)
  # 取得した文字列を標準出力へ表示
  #  -> 表示する順番については、こちらの責務
  #  -> 引数を複数指定した場合のディレクトリ名表示もこちらの責務とする
  #     (表示する対象が複数あることを、Formatterは知らない)
end

main
