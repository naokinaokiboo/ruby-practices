# frozen_string_literal: true

require 'etc'
require 'macxattr' # mac拡張属性取得用の拡張ライブラリ
require_relative 'file_type'
require_relative 'file_permission'

class Entry
  include FileType
  include FilePermission

  attr_reader :path, :display_name

  def initialize(path, display_name = nil)
    @path = path
    @display_name = display_name || path
    @file_stat = File.lstat(path) if File.exist?(path)
  end

  def file_type = get_file_type(@file_stat.mode)

  def permission = get_perission(@file_stat.mode)

  def macxattr = MacXattr.new.get_macxattr(@path)

  def nlink = @file_stat.nlink

  def owner_name = Etc.getpwuid(@file_stat.uid).name

  def group_name = Etc.getgrgid(@file_stat.gid).name

  def file_size = @file_stat.size

  def modified_time = @file_stat.mtime

  def symbolic_link
    symbolic_link? ? File.readlink(path) : nil
  end

  def symbolic_link? = @file_stat.symlink?

  def blocks = @file_stat.blocks
end
