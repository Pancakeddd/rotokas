import lex

type
  Node* = ref object of RootObj
    name*: string

  Number* = ref object of Node
    value*: float 

  Symbol* = ref object of Node
    value*: string

  Sexpr* = ref object of Node
    exprs*: seq[Node]