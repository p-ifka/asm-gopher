	.section .text

	.globl str_len
	.globl str_cmp
	
	.type str_len, @function
### str_len (char *str) << return(->%eax) the length of data from pointer *str until the first null byte >>
str_len:
	pushl %ebp		# save ebp
	pushl %esi		# save esi
	pushl %ebx		# save ebx
	movl %esp, %ebp		

	movl 16(%ebp), %ebx	# *str into ebx
	xor %esi, %esi		# set esi to 0
1:
	cmpb $0x0, (%ebx, %esi, 1)
	je 1f			# byte = 0 : jump to end
	inc %esi
	jmp 1b			# byte != 0 : jump to start
1:				# null byte found: end function
	movl %esi, %eax
	movl %ebp, %esp
	pop %ebx		# restore ebx
	popl %esi		# restore esi
	popl %ebp		# restore ebp
	ret			# ENDOF str_len 


	.type str_cmp, @function
### str_cmp (char *s1, char *s2)
str_cmp:
	pushl %ebp
	pushl %ebx
	pushl %ecx
	pushl %esi
	movl %esp, %ebp

	movl 16(%ebp), %eax	# s1
	movl 20(%ebp), %ebx	# s2
	xor %esi, %esi
1:

	movb (%eax, %esi, 1), %ch # next char of s1 -> %ch
	movb (%ebx, %esi, 1), %cl # next char of s2 -> %cl
	
	inc %esi		
	cmp $0, %ch
	je s1_end

	cmp %ch, %cl
	je 1b
	cmp %ch, %cl
	jg strcmp_more
	jmp strcmp_less
s1_end:
	cmp $0, %cl
	je strcmp_eq
	jmp strcmp_less
	
strcmp_less:			# s1 < s2
	movl $-1, %eax
	jmp 1f
strcmp_eq:			# s1 = s2
	movl $0, %eax
	jmp 1f
strcmp_more:			# s1 > s2
	movl $1, %eax
	jmp 1f
1:
	movl %ebp, %esp
	popl %esi
	popl %ecx
	popl %ebx
	popl %ebp
	ret
	
