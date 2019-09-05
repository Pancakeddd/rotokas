import strformat

const
  NAME* = "rotokas"
  VERSION* = "0.1"

proc rotokas_log*(s: string) =
  echo fmt"{NAME}: {s}"