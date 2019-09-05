import tables

type
  ObjectType* = ref object of RootObj

type
  Environment* = object
    stack*: seq[ObjectType]
    env*: Table[string, ObjectType]
    previous_env*: ref Environment

proc new_environment*: ref Environment =
  var e = new(Environment)
  e.stack = newSeq[ObjectType]()
  e.env = Table[string, ObjectType]()
  e.previous_env = nil
  return e

proc new_environment*(env: ref Environment): ref Environment =
  var e = new(Environment)
  e.stack = newSeq[ObjectType]()
  e.env = Table[string, ObjectType]()
  e.previous_env = env
  return e

proc define_in_env*(E: var ref Environment, s: string, obj: ObjectType) =
  E.env[s] = obj

proc exists_in_env*(E: var ref Environment, s: string): bool =
  if E.env.hasKey(s):
    return true
  elif E.previous_env != nil:
    return exists_in_env(E.previous_env, s)
  else:
    return false

proc get_in_env*(E: var ref Environment, s: string): ObjectType =
  if E.env.hasKey(s):
    return E.env[s]
  elif E.previous_env != nil:
    return get_in_env(E.previous_env, s)
  else:
    return nil

proc push_env*(E: var Environment, obj: ObjectType) = E.stack.add(obj)
proc pop_env*(E: var Environment): ObjectType =
  if len(E.stack) > 0:
    return E.stack.pop()
  else:
    return nil