/* macxattr.c */
#include <sys/types.h>
#include <sys/xattr.h>
#include <sys/types.h>
#include <sys/acl.h>
#include <stdio.h>
#include <ruby.h>

VALUE macxattr;

VALUE get_macxattr_func(VALUE self, VALUE path)
{
  char* pPath = StringValuePtr(path);
  acl_t acl = NULL;
  acl_entry_t dummy;
  ssize_t xattr = 0;

  acl = acl_get_link_np(pPath, ACL_TYPE_EXTENDED);
  if (acl && acl_get_entry(acl, ACL_FIRST_ENTRY, &dummy) == -1) {
      acl_free(acl);
      acl = NULL;
  }
  xattr = listxattr(pPath, NULL, 0, XATTR_NOFOLLOW);
  if (xattr < 0)
      xattr = 0;

  if (xattr > 0){
      return rb_str_new2("@");
  } else if (acl != NULL){
      return rb_str_new2("+");
  } else {
      return rb_str_new2(" ");
  }
}

void Init_macxattr()
{
  macxattr = rb_define_class("MacXattr", rb_cObject);

  rb_define_method(macxattr, "get_macxattr", RUBY_METHOD_FUNC(get_macxattr_func), 1);
}
