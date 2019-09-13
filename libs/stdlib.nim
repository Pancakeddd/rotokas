import ../environment, ../type, ../interpret, ../error, ../parse, ../macros, ../node
import rdstdin, parseutils, strformat

proc std_setstr(E: var ref Environment) =
  var str = get_string(E, 2)
  var v = getfrom_env(E, 1)
  clear_env(E)

  if str != nil and v != nil:
    define_in_env(E.previous_env, str.value, v)

proc std_echo(E: var ref Environment) =
  var v = getfrom_env(E, 1)
  clear_env(E)

  echo object_tostring(v)

proc std_throw(E: var ref Environment) =
  var v = getfrom_env(E, 1)
  if v != nil and v of ObjectString:
      clear_env(E)
      throw_runtime_error(v.object_tostring)
  elif v of ObjectNumber:
    let str = getfrom_env(E, 2)
    if str != nil and str of ObjectString:
      clear_env(E)
      throw_runtime_error(str.object_tostring,v.ObjectNumber.value.int)

proc std_input(E: var ref Environment) =
  var str = get_string(E, 1)
  if str != nil:
    clear_env(E)
    let str = readLineFromStdin str.value
    push_env(E, new_stringobj(str))
  else:
    clear_env(E)
    let str = readLineFromStdin ""
    push_env(E, new_stringobj(str))


proc std_add(E: var ref Environment) =
  var v1 = get_number(E, 1)
  var v2 = get_number(E, 2)
  clear_env(E)

  if v1 != nil and v2 != nil:
    push_env(E, new_numberobj(v1.value + v2.value))
  else:
    throw_runtime_error("Expected two variables for '+' operation")

proc std_sub(E: var ref Environment) =
  var v1 = get_number(E, 1)
  var v2 = get_number(E, 2)
  clear_env(E)

  if v1 != nil and v2 != nil:
    push_env(E, new_numberobj(v1.value - v2.value))
  else:
    throw_runtime_error("Expected two variables for '-' operation")

proc std_mul(E: var ref Environment) =
  var v1 = get_number(E, 1)
  var v2 = get_number(E, 2)
  clear_env(E)

  if v1 != nil and v2 != nil:
    push_env(E, new_numberobj(v1.value * v2.value))
  else:
    throw_runtime_error("Expected two variables for '*' operation")

proc std_div(E: var ref Environment) =
  var v1 = get_number(E, 1)
  var v2 = get_number(E, 2)
  clear_env(E)

  if v1 != nil and v2 != nil:
    push_env(E, new_numberobj(v1.value / v2.value))
  else:
    throw_runtime_error("Expected two variables for '/' operation")

proc std_string_to_number(E: var ref Environment) =
  var v = get_string(E, 1)
  clear_env(E)

  if v != nil:
    var num: float
    discard parseFloat(v.value, num)
    push_env(E, new_numberobj(num))

proc std_tostring(E: var ref Environment) =
  var v = getfrom_env(E, 1)
  clear_env(E)
  
  if v != nil:
    push_env(E, new_stringobj(object_tostring(v)))

proc load_stdlib*(E: var ref Environment) =
  define_in_env(E, "+", new_funcobj(std_add))
  define_in_env(E, "-", new_funcobj(std_sub))
  define_in_env(E, "*", new_funcobj(std_mul))
  define_in_env(E, "/", new_funcobj(std_div))
  define_in_env(E, "set-str", new_funcobj(std_setstr))
  define_in_env(E, "echo", new_funcobj(std_echo))
  define_in_env(E, "throw", new_funcobj(std_throw))
  define_in_env(E, "input", new_funcobj(std_input))

  define_in_env(E, "string->number", new_funcobj(std_string_to_number))
  define_in_env(E, "->string", new_funcobj(std_tostring))

proc std_macro_set(ast: seq[Node]): Sexpr =
  macro_require_len(ast, 2)
  if ast[1] != nil and ast[1] of Symbol and ast[2] != nil:
    return macro_sexpr("set-str", String(value: fmt"{ast[1].Symbol.value}"), ast[2])

proc std_gay(ast: seq[Node]): Sexpr =
  return macro_sexpr("set", Symbol(value: "x"), Number(value: 10))

proc load_stdlib_macros*(P: var Parser) =
  add_macro(P, "set", new_macro(std_macro_set))
  add_macro(P, "gay", new_macro(std_gay))