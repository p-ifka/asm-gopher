.PHONY: test gopher str
all: str gopher

str:
	as -32 str.s -o build/str.obj

gopher:
	cpp gopher.s build/gopher.procd.s
	as -32 build/gopher.procd.s -o build/gopher.obj
	gcc -m32 -no-pie build/gopher.obj build/str.obj -o a.out
test:
	cpp test.s build/test.procd.s
	as -32 build/test.procd.s -o build/test.obj
	as -32 str.s -o build/str.obj 
	gcc -m32 -no-pie build/test.obj build/str.obj -o a.out
