EXE=papua.exe

all: compile execute

compile:
	nim -d:release c main.nim

execute:
	main.exe