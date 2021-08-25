#include <stdio.h>
#include <libguile.h>

int main(int argc, char **argv)
{
  SCM func;
  scm_init_guile();
  scm_c_primitive_load("main.scm");
  func = scm_variable_ref(scm_c_lookup("repl"));
  scm_call_0(func);
  return 0;
}
