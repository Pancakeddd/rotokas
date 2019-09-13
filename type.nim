import environment

type
  ObjectNumber* = ref object of ObjectType
    value*: float

  ObjectString* = ref object of ObjectType
    value*: string

  ObjectFunction* = ref object of ObjectType
    fptr*: proc(E: var ref Environment)

proc new_numberobj*(i: int): ObjectNumber =
  result = new(ObjectNumber)
  result.value = cast[float](i)

proc new_numberobj*(f: float): ObjectNumber =
  result = new(ObjectNumber)
  result.value = f

proc new_stringobj*(s: string): ObjectString =
  result = new(ObjectString)
  result.value = s

proc new_funcobj*(fun: proc(E: var ref Environment)): ObjectFunction =
  result = new(ObjectFunction)
  result.fptr = fun

proc object_tostring*(O: ObjectType): string =
  if O of ObjectNumber:
    return $O.ObjectNumber.value
  elif O of ObjectString:
    return O.ObjectString.value
  elif O of ObjectFunction:
    return "Func Pointer"