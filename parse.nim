import lex, node, strformat, strutils, macros, tables

type
  Parser* = object
    parseobj*: seq[Token]
    tokpointer*: int
    macros*: Table[string, MacroDef]

proc add_macro*(P: var Parser, str: string, M: MacroDef) =
  P.macros[str] = M

proc parse_next*(P: var Parser): Node

proc in_range(P: Parser): bool =
  if P.tokpointer+1 <= len(P.parseobj):
    return true
  return false

proc next(P: var Parser) {.inline.} =
  P.tokpointer += 1

proc peek(P: Parser): Token {.inline.} = P.parseobj[P.tokpointer]

proc is_value(T: Token): bool =
  case T.name:
    of "Number", "Symbol", "String":
      return true
    else:
      return false

proc symbol(P: var Parser): Symbol =
  return Symbol(value: peek(P).value)

proc number(P: var Parser): Number =
  return Number(value: parseFloat(peek(P).value))

proc str(P: var Parser): String =
  return String(value: peek(P).value)

proc s_expression(P: var Parser): Node =
  var exprs: seq[Node]
  var exp = parse_next(P)
  while in_range(P):
    exprs.add(exp)
    if peek(P).value == ")":
      break
    else:
      exp = parse_next(P)
  next(P)
  if exprs[0] != nil and exprs[0] of Symbol:
    if P.macros.hasKey(exprs[0].Symbol.value):
      #echo P.macros[exprs[0].Symbol.value].transformer(exprs)
      return P.macros[exprs[0].Symbol.value].transformer(exprs)
    
  return Sexpr(exprs: exprs)

proc parse_next*(P: var Parser): Node =
  if not in_range(P):
    return Node(name: "Eot")
  
  let p = peek(P)

  if p.name == "Paren" and p.value == "(":
    next(P)
    return s_expression(P)

  if p.name == "Symbol":
    let sym = symbol(P)
    next(P)
    return sym

  if p.name == "String":
    let sym = str(P)
    next(P)
    return sym

  if p.name == "Number":
    let sym = number(P)
    next(P)
    return sym

  return Node()

proc parse_all*(P: var Parser): seq[Node] =
  var ast: seq[Node]
  while true:
    let x = parse_next(P)
    if x.name != "Null" and x.name != "Eot":
      ast.add(x)
    else:
      break
  return ast

proc fmt_node*(node: Node): string =
  var str: string
  if node of Sexpr:
      str.add "( "
      for node in Sexpr(node).exprs:
        str.add(fmt_node(node))
      str.add ")"
  elif node of Symbol:
    str.add Symbol(node).value
  elif node of Number:
    str.add $Number(node).value
  elif node of String:
    str.add String(node).value
  else:
    str.add "!UNKNOWN!"
  str.add " "
  return str

proc fmt_nodes*(nodes: seq[Node]): string =
  var str: string

  for node in nodes:
    str.add(fmt_node(node))

  return str