.data
promptmesg: .asciiz "Enter a word: "
scoremesg: .asciiz "Score: "
screenclear: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n"
commfoundmesg: .asciiz "Commands: 1-shuffle, 2-quit\nFound words: \n"
exitmesg: .asciiz "Goodbye, thanks for playing!\n"
input: .space 10
board: .space 19
.text
main:
	li $v0, 4
	la $a0, screenclear	# clear the previous screen
	syscall
	li $v0, 4
	la $a0, commfoundmesg
	syscall
	jal printfound	# print the currently found set of words
	li $v0, 4
	la $a0, scoremesg
	syscall
	li $v0, 1
	add $a0, $s7, $zero		# assuming score is in $s7
	syscall		# display the score
	li $v0, 4
	la $a0, board	# print the board
	syscall
	li $v0, 4
	la $a0, promptmesg
	syscall
	#	get the input	
	li $v0, 8
	la $a0, input
	li $a1, 10
	syscall
	# get first char into $t0
		# if command 1
	#beq $t0, 1, shuffle
		# if command 2
	#bne $t0, 2, processing
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
