import environment, type, node, error, strformat, parseutils

type
  TreeDescender* = object
    env*: ref Environment

proc get_number*(E: var ref Environment, i: int): ObjectNumber =
  let p = getfrom_env(E, i)
  if p != nil and p of ObjectNumber:
    return cast[ObjectNumber](p)
  else:
    return nil

proc get_string*(E: var ref Environment, i: int): ObjectString =
  let p = getfrom_env(E, i)
  if p != nil and p of ObjectString:
    return cast[ObjectString](p)
  else:
    return nil

proc evaluate_next(T: var TreeDescender, node: Node)

proc tree_num*(T: var TreeDescender, num: Number) = 
  let num = new_numberobj(num.value)
  push_env(T.env, num)

proc tree_str*(T: var TreeDescender, str: String) = 
  let str = new_stringobj(str.value)
  push_env(T.env, str)

proc tree_sym*(T: var TreeDescender, sym: Symbol) =
  if exists_in_env(T.env, sym.value):
    let sym = get_in_env(T.env, sym.value)
    push_env(T.env, sym)
  else:
    throw_runtime_error(fmt"Expected an existant value for symbol '{sym.value}'")

proc tree_s_expr*(T: var TreeDescender, expr: Sexpr) =
  if len(expr.exprs) > 0:
    let first = expr.exprs[0]
    if is_symbol(first):
      let first_sym = cast[Symbol](first)
      if exists_in_env(T.env, first_sym.value):
        var fun = get_in_env(T.env, first_sym.value)
        if fun of ObjectFunction:
          var fun_td = TreeDescender(env: new_environment(T.env))
          for arg in expr.exprs[1..^1]:
            evaluate_next(fun_td, arg)
          var ffun = cast[ObjectFunction](fun)
          ffun.fptr(fun_td.env)
          transfer_env_stack(fun_td.env, T.env)
        else:
          throw_runtime_error(fmt"Expected '{first_sym.value}' to be of function type")
      else:
        throw_runtime_error(fmt"Can't find command '{first_sym.value}'")


proc evaluate_next(T: var TreeDescender, node: Node) =
  if node of Number:
    tree_num(T, cast[Number](node))
  elif node of String:
    tree_str(T, cast[String](node))
  elif node of Sexpr:
    tree_s_expr(T, cast[Sexpr](node))
  elif node of Symbol:
    tree_sym(T, cast[Symbol](node))
    

proc evaluate_all*(T: var TreeDescender, nodes: seq[Node]) =
  for node in nodes:
    evaluate_next(T, node)