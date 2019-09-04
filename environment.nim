import type, tables

type
  Environment = object
    stack: seq[ref ObjectType]
    env: Table[string, ref ObjectType]
    previous_env: ref Environment

proc define_in_env*(E: var Environment, s: string, obj: ref ObjectType) =
  E.env[s] = obj

proc exists_in_env*(E: var Environment, s: string): bool =
  if E.env.hasKey(s):
    return true
  elif E.previous_env != nil:
    return exists_in_env(E.previous_env[], s)
  else:
    return false

proc push_env*(E: var Environment, obj: ref ObjectType) = E.stack.add(obj)
proc pop_env*(E: var Environment): ref ObjectType = E.stack.pop()