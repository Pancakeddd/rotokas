import rotokas, strformat, lex, node

proc safe_quit(q: int) =
  GC_fullcollect()
  quit(q)

proc throw_lex_error*(str: string, pos: int) =
  rotokas_log(fmt"lex err {str} at {pos}")
  safe_quit(1)

proc throw_runtime_error*(str: string) =
  rotokas_log(fmt"runtime error {str}")
  safe_quit(1)