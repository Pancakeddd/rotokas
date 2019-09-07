import strutils, re

type
  Token* = object
    name*: string
    value*: string
    pos*: int

type
  Lexer* = object
    lexobj*: string
    strpointer*: int

#proc token_err(L: var Lexer, err: string): Token = Token(name: "Error", value: err, pos: L.strpointer)
proc token_eof(L: var Lexer): Token = Token(name: "Eof", value: "", pos: L.strpointer)

proc in_range(L: var Lexer): bool =
  if L.strpointer+1 <= len(L.lexobj):
    return true
  return false

proc next(L: var Lexer) =
  L.strpointer += 1

proc peek(L: var Lexer): char = L.lexobj[L.strpointer]

proc is_paren(c: char): bool =
  if c == '(' or c == ')':
    return true
  return false

proc is_whitespace(c: char): bool =
  if c == ' ' or c == '\t' or c == '\n' or c.int == 13:
    return true
  return false

proc get_number(L: var Lexer): Token =
  let startvar = L.strpointer
  var str: string
  while in_range(L) and not is_whitespace(peek(L)) and isDigit(peek(L)):
    str.add(peek(L))
    next(L)
  return Token(name: "Number", value: str, pos: startvar)

proc get_string(L: var Lexer): Token =
  let startvar = L.strpointer
  var str: string
  while in_range(L) and peek(L) != '"':
    str.add(peek(L))
    next(L)
  next(L)
  
  return Token(name: "String", value: str, pos: startvar)

proc get_function_token(L: var Lexer): Token =
  let startvar = L.strpointer
  var str: string
  
  while in_range(L) and not is_whitespace(peek(L)) and not is_paren(peek(L)):
    str.add(peek(L))
    next(L)
  return Token(name: "Symbol", value: str, pos: startvar)


proc get_next*(L: var Lexer): Token =
  if not in_range(L):
    return token_eof(L)

  let p = peek(L)

  if is_whitespace(p):
    next(L)
    return get_next(L)

  if isDigit(p):
    return get_number(L)

  if p == '"':
    next(L)
    return get_string(L)

  if is_paren(p):
    let p = Token(name: "Paren", value: $p, pos: L.strpointer)
    next(L)
    return p

  return get_function_token(L)

proc get_next_march*(L: var Lexer): seq[Token] =
  var toks: seq[Token]
  while true:
    var tok = get_next(L)
    if tok.name != "Eof":
      toks.add(tok)
    else:
      break
  
  return toks