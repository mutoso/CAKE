.data
promptmesg: .asciiz "Enter a word: "
scoremesg: .asciiz "Score: "
nwlnmesg: .asciiz "\n"
tabmesg: .asciiz "\t"
commfoundmesg: .asciiz "Commands: 1-shuffle, 2-quit\nFound words: \n"
exitmesg: .asciiz "Goodbye, thanks for playing!\n"
input: .space 10
templine: .space 8
.text
main:
	#	clear the previous screen
	li $v0, 4
	la $a0, commfoundmesg
	syscall
		#addi $sp, $sp, -8
		#sw $ra, 0($sp)	# save the return value to the stack
	jal printfound	# print the currently found set of words
		#lw $ra, 0($sp)	# now retrieve the return address from the previous call
		#addi $sp, $sp, 8
	li $v0, 4
	la $a0, scoremesg
	syscall
	# display the score
	li $v0, 1
	add $a0, $s7, $zero
	syscall
		#addi $sp, $sp, -8
		#sw $ra, 0($sp)	# save the return value to the stack
	jal printboard	# print the current board
		#lw $ra, 0($sp)	# now retrieve the return address from the previous call
		#addi $sp, $sp, 8
	li $v0, 4
	la $a0, promptmesg
	syscall
	
	
	li $v0, 8
	la $a0, input
	li $a1, 10
	syscall
	# get first char into $t0
	# if command 1
		# beq $t0, 1, shuffle
	# if command 2
		# bne $t0, 2, processing
	#li $v0, 4
	#la $a0, exitmesg
	#syscall
	#li $v0, 4
	#syscall
shuffle:
	# shuffle the board
	
processing:
	# process the user input
	j main
	
	
printfound:

printboard:
	# board stored in array
	# contruct first line in templine
	li $v0, 4
	la $a0, templine
	syscall