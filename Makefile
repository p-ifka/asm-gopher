all:
	cpp gopher.s gopher.procd.s
	as -32 gopher.procd.s -o gopher.obj 
	gcc -m32 -no-pie  gopher.obj -o a.out
