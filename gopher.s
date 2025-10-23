#include "const.h"

	.section .data


	
rec_buf_len:
	.long 32
port:
	.short 70


default_page:
	.ascii "1floodgap home\t/home\tgopher.floodgap.com\t70\r\nitext\tfake\t(NULL)\t0\r\n.\0"


help_msg:
	.ascii "Usage:\n"\
	" %s [options] [src-dir]\n\n"\
	"start gopher server. serve files from src-dir.\n\n"\
	"Options:\n"\
	" -h, --help         display this help\n"\
	" -t, --test         run server on port 8080\n"\
	"\0"
unknown_char_option_msg:
	.ascii "invalid option --  %c\n"\
	"try \'%s -h\' for more information\n\0"

unknown_word_option_msg:
	.ascii "invalid option --  %s\n"\
	"try \'%s -h\' for more information\n\0"

	
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
fmtstr_s:
	.ascii "s: %s\n\0"
fmtstr_d:
	.ascii "d: %d\n\0"
newline:
	.ascii "\n\0"

	.section .text
	.globl main
	.globl parse_args
	.globl hton_w

	.type parse_args, @function
### parse_args (int argc, char *argv) << read arguments >>
parse_args:

	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx	# argc 
	movl 12(%ebp), %ecx	# argv
	
	movl 0(%ecx), %ecx

	pushl %ecx		# save program name pointer
	call str_len
	addl %eax, %ecx		# move forward to next argument 
	inc %ecx
	
	movl $1, %esi
	subl $4, %esp
	#  pushl %ebx
	#  pushl $fmtstr_d
	#  call printf
	#  movl %edi, 4(%esp)
	#  call printf
	#  addl $8, %esp


1:				# for edi=0; edi<argc; edi++
	cmp %ebx, %esi
	jge 1f

	cmpb $45, 0(%ecx)
	je parse_option_arg
	jmp parse_next_arg

	parse_option_arg:
		xor %edx, %edx
		movb 1(%ecx), %dl # move next character into %dl
		cmpb $0x68, %dl	# lowercase h
		je option_help
		cmpb $0x74, %dl	# lowercase d
		je option_test_port
		jmp coption_unknown
		

	option_help:		# help option
		pushl 4(%esp)
		pushl $help_msg
		call printf
		jmp exit_success

	coption_unknown:	# unknown character argument
		pushl 4(%esp)	# program name
		pushl %edx	# option letter
		pushl $unknown_char_option_msg
		call printf
		jmp exit_err
	option_test_port:	# test port option
		
	
	parse_next_arg:
	
	movl %ecx, 0(%esp)
	call strlen
	addl %eax, %ecx
	inc %ecx
	inc %esi
	jmp 1b
	
	
	
1:
	pushl %esi
	pushl $fmtstr_d
	call printf
	addl $8, %esp
	
	movl %ebp, %esp
	popl %ebp
	ret
	


	
	## pushl %ebp
	## movl %esp, %ebp

	## movl 8(%ebp), %ebx	# argc
	## movl 12(%ebp), %ecx	# argv


	
	## ## pushl %eax
	## ## pushl $msg
	## ## call printf
	## ## addl $4, %esp
	
	## xor %esi, %esi
	## inc %esi
	## xor %edx, %edx
	## movl 0(%ecx), %ecx	# ebx now points to *argv[0]
	## pushl %ecx		# save program name pointer
	## pushl $fmtstr_s
	## call printf
	
	## pushl %ecx
	## call str_len
	## ## addl %eax, %ecx
	## ## inc %ecx
	## addl $4, %esp

	## call printf
	
	## 1:			# loop for each arg
	## cmp %ebx, %esi
	## jge 1f


	## ## movl 4(%esp), %ecx
	## ## call printf
	## ## cmpb $45, 0(%ecx)	# check if first char of arg is '-'
	## ## je parse_option_arg	# if first char is '-', parse as option
	## ## jmp parse_arg_next
	

	## ## parse_option_arg:
	## 	## movb 1(%ecx), %dl # get next char of arg
	## 	## cmpb $45, %dl	  # if char is also '-' parse as word
	## 	## je parse_option_word
	## 	## cmpb $104, %dl	# if char is 'h', display help
	## 	## je option_help
	## 	## cmpb $99, %dl	# if char is 'c', do nothing, continue
	## 	## je parse_arg_next
	## 	## jmp option_unknown

	## ## parse_option_word:
		
	## ## option_help:
	## 	## pushl $help_msg
	## 	## call printf
	## 	## jmp exit_success

	## ## option_unknown:
	## 	## pushl %edx
	## 	## pushl $unknown_char_option_msg
	## 	## call printf
	## 	## jmp exit_err
		
	
	
	## #  pushl %ebx
	## #  call printf
	## #  movl $newline, 0(%esp)
	## #  call printf
	## #  addl $4, %esp
	
	## parse_arg_next:
	
	## inc %esi
	## ## addl $4, %ecx
	## ## jmp 1b
	
	## 1:			

	## movl %ebp, %esp
	## popl %ebp
	## ret
	

	.type hton_w, @function
	hton_w:			# hton_w (short x) << return short x in reverse byte order >>
		pushl %ebp
		movl %esp, %ebp
		xor %eax, %eax
		movb 8(%ebp), %ah
		movb 9(%ebp), %al

		popl %ebp
		ret
	
	
	.type main, @function
main:				# main function
	xor %edi, %edi
	
	pushl 8(%esp)		# argv (+8 from %esp)
	pushl 8(%esp)		# argc (+4 from %esp)
	call parse_args

	

	#  movl 0(%ebx), %ebx
	#  pushl %ebx
	#  call str_len
	#  addl %eax, %ebx
	#  inc %ebx
	#  pushl %ebx
	#  push $fmtstr_s
	#  call printf





	
	jmp exit_success
	## pushl 8(%esp)		# argv (+8 from %esp)
	## pushl 8(%esp)		# argc (+4 from %esp)
	## call parse_args
	## addl $8, %esp


1:				# write zeroed buffer to stack of length rec_buf_len

	cmp rec_buf_len, %edi
	jge 1f
	pushw $0
	inc %edi
	inc %edi
	jmp 1b
1:
				#-# push arguments fxor socket socket
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
	pushw $0x4600		# in_port_t sin_port : 0x46(70) in network byte order
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

accept_loop:	
	movl $SOCKET_CALL, %eax
	movl $SYS_ACCEPT, %ebx
	movl %esp, %ecx
	int $0x80		# call accept()


	cmp $0x0, %eax
	jge accept_fail_f
accept_fail_t:			# show accept fail msg and quit
	pushl %eax
	pushl $accept_fail_msg
	call printf
	jmp exit_err
accept_fail_f:			# accept didn't fail
	movl %eax, %edi
	
	pushl $accept_success_msg
	call printf
	addl $4, %esp

	pushl $default_page
	call str_len
	movl %eax, %edx
	addl $4, %esp

	movl $0x4, %eax
	movl %edi, %ebx
	movl $default_page, %ecx
	int $0x80

	movl $0x6, %eax		# close()
	movl %edi, %ebx		# close client connection
	int $0x80		# call close()

	jmp accept_loop
	
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

