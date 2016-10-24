.data
promptmesg: .asciiz "Enter a word: "
scoremesg: .asciiz "Score: "
screenclear: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n"
commfoundmesg: .asciiz "Commands: 1-shuffle, 2-quit\nFound words: \n"
exitmesg: .asciiz "Goodbye, thanks for playing!\n"
commOne: .byte '1'
commTwo: .byte '2'
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
	li $v0, 8	# get the input
	la $a0, input
	li $a1, 10
	syscall
	lw $t1, 0($a0)	# get first char into $t1
	lw $t2, commOne
	beq $t1, $t2, shuffle	# if command 1
	lw $t2, commTwo
	bne $t1, $t2, processing	# else if command 2
	li $v0, 4		# if it's not command 2, 'exit', we skip this and go on to the processing
	la $a0, exitmesg	# say goodbye
	syscall
	li $v0, 10
	syscall
shuffle:
	# shuffle the board
	
processing:
	# process the user input
	j main
	
	
printfound:
