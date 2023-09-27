# frozen_string_literal: true

module FilePermission
  DIGITS_OCTAL_TO_BINARY = 3

  module PermissionMask
    READABLE    = 0o4
    WRITABLE    = 0o2
    EXECUTABLE  = 0o1
  end

  module PermissionUser
    OWNER = 0o700
    GROUP = 0o070
    OTHER = 0o007
  end

  def get_perission(mode)
    owner_permission = get_permission_attr((mode & PermissionUser::OWNER) >> 2 * DIGITS_OCTAL_TO_BINARY)
    group_permission = get_permission_attr((mode & PermissionUser::GROUP) >> 1 * DIGITS_OCTAL_TO_BINARY)
    other_permission = get_permission_attr((mode & PermissionUser::OTHER) >> 0 * DIGITS_OCTAL_TO_BINARY)
    [owner_permission, group_permission, other_permission].join
  end

  def get_permission_attr(permission_bits)
    permission_masks = {
      PermissionMask::READABLE => 'r',
      PermissionMask::WRITABLE => 'w',
      PermissionMask::EXECUTABLE => 'x'
    }
    permission_masks.each_with_object(+'') do |(mask, attr), permission|
      permission << (mask & permission_bits != 0 ? attr : '-')
    end
  end
end
