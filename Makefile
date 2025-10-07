all:
	cpp gopher.s build/gopher.procd.s
	as -32 build/gopher.procd.s -o build/gopher.obj 
	gcc -m32 -no-pie build/gopher.obj -o a.out
