import environment

type
  ObjectNumber* = ref object of ObjectType
    value*: float

  ObjectFunction* = ref object of ObjectType
    fptr*: proc(E: var Environment)

proc new_numberobj*(i: int): ObjectNumber =
  result = new(ObjectNumber)
  result.value = cast[float](i)

proc new_numberobj*(f: float): ObjectNumber =
  result = new(ObjectNumber)
  result.value = f

proc new_funcobj*(fun: proc(E: var Environment)): ObjectFunction =
  result = new(ObjectFunction)
  result.fptr = fun

proc object_tostring*(O: ObjectType): string =
  if O of ObjectNumber:
    return $O.ObjectNumber.value
  if O of ObjectFunction:
    return "(Function Pointer)"