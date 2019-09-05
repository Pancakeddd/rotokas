import ../environment, ../type, ../interpret, ../error

proc std_echo(E: var Environment) =
  var v = pop_env(E)

  echo object_tostring(v)

proc std_add(E: var Environment) =
    var v1 = pop_number(E)
    var v2 = pop_number(E)

    if v1 != nil and v2 != nil:
      push_env(E, new_numberobj(v1.value + v2.value))
    else:
      throw_runtime_error("Expected two variables for '+' operation")

proc load_stdlib*(E: var ref Environment) =
  define_in_env(E, "+", new_funcobj(std_add))
  define_in_env(E, "echo", new_funcobj(std_echo))