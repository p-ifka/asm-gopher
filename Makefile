all:
	as -32 gopher.s -o gopher.obj
	gcc -m32 -no-pie  gopher.obj -o a.out
