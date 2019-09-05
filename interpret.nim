import environment, type, node, error, strformat, parseutils

type
  TreeDescender* = object
    env*: ref Environment

proc pop_number*(E: var Environment): ObjectNumber =
  let p = pop_env(E)
  if p != nil and p of ObjectNumber:
    return cast[ObjectNumber](p)
  else:
    return nil

proc evaluate_next(T: var TreeDescender, node: Node)

proc tree_num*(T: var TreeDescender, num: Number) = 
  let num = new_numberobj(num.value)
  push_env(T.env[], num)

proc tree_s_expr*(T: var TreeDescender, expr: Sexpr) =
  if len(expr.exprs) > 0:
    let first = expr.exprs[0]
    if is_symbol(first):
      let first_sym = cast[Symbol](first)
      if exists_in_env(T.env, first_sym.value):
        var fun = get_in_env(T.env, first_sym.value)
        if fun of ObjectFunction:
          for arg in expr.exprs[1..^1]:
            evaluate_next(T, arg)
          var ffun = cast[ObjectFunction](fun)
          ffun.fptr(T.env[])
        else:
          throw_runtime_error(fmt"Expected '{first_sym.value}' to be of function type")
      else:
        throw_runtime_error(fmt"Can't find command '{first_sym.value}'")


proc evaluate_next(T: var TreeDescender, node: Node) =
  if node of Number:
    tree_num(T, cast[Number](node))
  elif node of Sexpr:
    tree_s_expr(T, cast[Sexpr](node))