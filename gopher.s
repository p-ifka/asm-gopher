#include "const.h"

	.section .data

rec_buf_len:
	.long 32
socket_fail_msg:
	.ascii "socket creation failed: %d\n\0"
socket_success_msg:
	.ascii "created socket successfully\n\0"
bind_fail_msg:
	.ascii "bind failed: %d\n\0"
bind_success_msg:
	.ascii "bound socket successfully\n\0"
listen_fail_msg:
	.ascii "listen failed: %d\n\0"
listen_success_msg:
	.ascii "server listening\n\0"
accept_fail_msg:
	.ascii "accept failed: %d\n\0"
accept_success_msg:
	.ascii "server accepted\n\0"		
	
	
	
msg:
	.ascii "the value of x is %d\n\0"

	.section .text
	.globl main
	.globl func


	.type main, @function
main:				# main function
	xor %edi, %edi
1:				# write zeroed buffer to stack of length rec_buf_len
	cmp rec_buf_len, %edi	
	jge 1f
	pushw $0		
	inc %edi		
	inc %edi		
	jmp 1b			
1:
				#-# push arguments for socket socket
				# >(int domain, int type, int protocol)
	pushl $0		# int protocol
	pushl $SOCK_STREAM	# int type 
	pushl $AF_INET		# int domain
	
	movl $SOCKET_CALL, %eax
	movl $SYS_SOCKET, %ebx	
	movl %esp, %ecx
	int $0x80		# call socket ()
	addl $12, %esp		# clear args from stack

	cmpl $0x0, %eax		# check for error
	jge socket_fail_f
socket_fail_t:			# show socket fail message and quit
	pushl %eax
	pushl $socket_fail_msg
	call printf
	jmp exit_err
socket_fail_f:			# socket didn't fail
	movl %eax, %esi
	pushl $socket_success_msg 
	call printf
	addl $4, %esp
	
				#-# push sockaddr values to stack
	pushl $0x0		# char sin_zero[8]
	pushl $0x0		# ^
	pushl $INADDR_ANY	# struct in_addr sin_addr
	pushw $0x901f		# in_port_t sin_port : 0x46(70) in network byte order
	pushw $AF_INET		# sa_family_t sin_family
	movl %esp, %ebx
				#-# push arguments for bind
				# >(int sockfd, const struct sockaddr *addr, socklen_t addrlen) 
	pushl $16		# sizeof struct sockaddr (16 bytes - 128 bits)
	pushl %ebx		# pointer to sockaddr
	pushl %esi		# sockfd (return value from socket())

	movl $SOCKET_CALL, %eax		
	movl $SYS_BIND, %ebx
	movl %esp, %ecx	
	int $0x80		# call bind()
	addl $24, %esp
	

	cmp $0x0, %eax
	jge bind_fail_f
bind_fail_t:			# show bind fail msg and quit
	pushl %eax
	pushl $bind_fail_msg
	call printf
	jmp exit_err
bind_fail_f:			# bind didn't fail
	pushl $bind_success_msg	
	call printf
	addl $4, %esp

				#-# push arguments for listen
				# >(int sockfd, int backlog)
	pushl $5
	pushl %esi

	movl $SOCKET_CALL, %eax
	movl $SYS_LISTEN, %ebx
	movl %esp, %ecx
	int $0x80		# call listen()

	cmp $0x0, %eax
	jge listen_fail_f
listen_fail_t:			# show listen fail msg and quit
	pushl %eax
	pushl $listen_fail_msg
	call printf
	jmp exit_err
listen_fail_f:			# listen didn't fail
	pushl $listen_success_msg
	call printf
	addl $4, %esp

	subl $0x10, %esp	# allocate space for sockaddr
	movl %esp, %eax
				#-# push arguments for accept
				# >(int sockfd, struct sockaddr *_Nullable restrict addr, socklen_t *_Nullable restrict addrlen)
	pushl $0x10
	pushl %esp
	pushl %eax
	pushl %esi

	movl $SOCKET_CALL, %eax
	movl $SYS_ACCEPT, %ebx
	movl %esp, %ecx
	int $0x80		# call accept()
	addl $28, %esp

	cmp $0x0, %eax
	jge accept_fail_f
accept_fail_t:			# show accept fail msg and quit
	pushl %eax
	pushl $accept_fail_msg
	call printf
	jmp exit_err
accept_fail_f:			# accept didn't fail
	pushl $accept_success_msg
	call printf
	addl $4, %esp

	
	
	
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
	
