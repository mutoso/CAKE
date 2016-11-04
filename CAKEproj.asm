.data
promptmesg: .asciiz "\nEnter a word: "
scoremesg: .asciiz "Score: "
screenclear: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n"
commfoundmesg: .asciiz "Commands: 1-shuffle, 2-quit\nFound words: \n"
exitmesg: .asciiz "Goodbye, thanks for playing!\n"
errormesg: .asciiz "Error: Invalid word.\n"
usedwordmesg: .asciiz "Error: Word already used.\n"
commOne: .word 0x31
commTwo: .word 0x32
newLine: .word 0x0A
input: .space 10
board: .space 19
fout: .asciiz "board.txt"
reservedspace: .space 2048

.text
main:
	jal loadDictionary # load dictionary
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
	lb $t1, 0($a0)	# get first char into $t1
	lw $t2, commOne
	beq $t1, $t2, shuffle	# if command 1
	lw $t2, commTwo
	bne $t1, $t2, processing	# else if not command 2
	j exit		# if command 2, exit program
	
loadDictionary:
    li $v0, 13
    la $a0, fout
    li $a1, 0
    li $a2, 0
    syscall
    move $s6, $v0

    li $v0, 14
    move $a0, $s6
    la $a1, reservedspace
    li $a2, 1024
    syscall
    
    # prints results of file
    la $a0, reservedspace
    li  $v0, 4
    syscall
    
    close:
    li $v0, 16
    move $a0, $s6
    syscall
    
    jr $ra

shuffle:
	# shuffle the board
	j main
	
processing:
	# process the user input
		# if string length is <4
	jal stringLength
	move $t2, $v0
	add $t3, $zero, 4
	slt $t1, $t2, $t3
	beq $t1, 1, invalidString
	# continue processing
	j main
	
stringLength:
	add $t0, $t0, $zero	# initialize count to 0
strLenLoop:
	lb $t1, 0($a0) # load a character into t1
	lw $t2, newLine
	beq $t1, $t2, exitStrLen	# exit the loop if we have a newLine character
	beq $t1, $zero exitStrLen	# exit the loop if we have a null character
	addi $a0, $a0, 1 #load increment string pointer
	addi $t0, $t0, 1 #increment count
	j strLenLoop
exitStrLen:
	move $v0, $t0
	jr $ra
	
invalidString:
	li $v0, 4
	la $a0, errormesg
	syscall
	# jr $ra	# ???
	# j main	# ???

printfound:
	jr $ra

exit:
	li $v0, 4		# if it's not command 2, 'exit', we skip this and go on to the processing
	la $a0, exitmesg	# say goodbye
	syscall
	li $v0, 10
	syscall