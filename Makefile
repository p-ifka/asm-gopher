.PHONY: test
all:
	cpp gopher.s build/gopher.procd.s
	as -32 build/gopher.procd.s -o build/gopher.obj 
	gcc -m32 -no-pie build/gopher.obj -o a.out
test:
	cpp test.s build/test.procd.s
	as -32 build/test.procd.s -o build/test.obj 
	gcc -m32 -no-pie build/test.obj -o a.out
