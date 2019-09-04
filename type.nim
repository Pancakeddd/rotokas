type
  ObjectType* = ref object of RootObj

  ObjectNumber* = ref object of ObjectType
    value: float

proc object_tostring*(O: ObjectType): string =
  return "WIP" 