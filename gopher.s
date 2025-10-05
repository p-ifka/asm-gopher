
#define AF_UNIX 1
#define SOCK_STREAM 1	
#define AF_INET 2

	
	.section .data

rec_buf_len:
	.long 32
#af_unix:			## socket domain for machine-local communication
#	.long 1
#af_inet:			## socket domain for ipv4
#	.long 2
#sock_stream:			## socket type 
#	.long 1
socket_fail_msg:
	.ascii "socket creation failed: %d\n\0"
	
msg:
	.ascii "the value of x is %d\n\0"

	.section .text
	.globl main
	.globl func


	.type main, @function
main:				#- main function
	xor %edi, %edi
1:				## write zeroed buffer to stack of length rec_buf_len
	cmp rec_buf_len, %edi	
	jge 1f
	pushw $0		
	inc %edi		
	inc %edi		
	jmp 1b			
1:
	movl $0x167, %eax	## syscall socket ( family, type, protocol )
	movl $AF_INET, %ebx	## int family
	movl $SOCK_STREAM, %ecx	## int type
	movl $0, %edx		## int protocol
	int $0x80
	
#	pushl $0		## int protocol
#	pushl sock_stream	## int type 
#	pushl af_inet		## int domain
#	call socket		## call socket(af_inet, sock_stream, 0)
#	addl $6, %esp		## clear arguments from stack
	
	cmpl $-1, %eax		## check for error
	jle socket_fail_t
	jmp socket_fail_f
socket_fail_t:			## print socket_fail_msg and jump to exit_err
	pushl %eax
	pushl $socket_fail_msg
	call printf
	jmp exit_err
socket_fail_f:
	
	movl %eax, %ebx		## move return value of socket
				 ## to the first argument of bind
	
	movl $0x14b, %eax	## syscall
	
	
	
	
	
exit_success:	
	movl $0x1, %eax
	movl $0, %ebx
	int $0x80
	ret
exit_err:
	movl $0x1, %eax
	movl $1, %ebx
	int $0x80
	ret
	
