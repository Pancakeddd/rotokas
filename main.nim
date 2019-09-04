import lex, parse, strformat

var l = Lexer(lexobj: "(+ 10 (- x (* x x)))", strpointer: 0)
let toks = get_next_march(l)

for tok in toks:
  echo fmt"{tok.name}, {tok.value}, {tok.pos}"

var p = Parser(parseobj: toks, tokpointer: 0)
let nodes = parse_next(p)
echo fmt_node(nodes)