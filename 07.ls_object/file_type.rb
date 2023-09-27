# frozen_string_literal: true

module FileType
  S_IFMT   = 0o170000 # bit mask for the file type bit field
  S_IFSOCK = 0o140000 # socket
  S_IFLNK  = 0o120000 # symbolic link
  S_IFREG  = 0o100000 # regular file
  S_IFBLK  = 0o060000 # block device
  S_IFDIR  = 0o040000 # directory
  S_IFCHR  = 0o020000 # character device
  S_IFIFO  = 0o010000 # FIFO

  def get_file_type(mode)
    case FileType::S_IFMT & mode
    when FileType::S_IFSOCK then 's'
    when FileType::S_IFLNK  then 'l'
    when FileType::S_IFREG  then '-'
    when FileType::S_IFBLK  then 'b'
    when FileType::S_IFDIR  then 'd'
    when FileType::S_IFCHR  then 'c'
    when FileType::S_IFIFO  then 'p'
    end
  end
end
