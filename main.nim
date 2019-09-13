import lex, parse, interpret, environment, node, type, strformat, environment, libs/stdlib

proc load_roto_file(filename: string) =
  let fc = readFile(filename)

  var l = Lexer(lexobj: fc, strpointer: 0)
  let toks = get_next_march(l)

  var p = Parser(parseobj: toks, tokpointer: 0)
  load_stdlib_macros(p)
  let nodes = parse_all(p)
  echo fmt_nodes(nodes)

  var env = new_environment()
  load_stdlib(env)
  var td = TreeDescender(env: env)
  evaluate_all(td, nodes)

load_roto_file("test.lisp")