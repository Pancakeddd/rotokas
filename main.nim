import lex, parse, interpret, environment, node, type, strformat, environment, libs/stdlib

proc load_roto_file(filename: string) =
  let fc = readFile(filename)

  var l = Lexer(lexobj: fc, strpointer: 0)
  let toks = get_next_march(l)

  var p = Parser(parseobj: toks, tokpointer: 0)
  let nodes = parse_next(p)
  echo fmt_node(nodes)

  var env = new_environment()
  load_stdlib(env)
  var td = TreeDescender(env: env)
  tree_s_expr(td, cast[Sexpr](nodes))

load_roto_file("test.lisp")