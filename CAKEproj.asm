.data
promptmesg: .asciiz "\nEnter a word: "
scoremesg: .asciiz "\nScore: "
screenclear: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n"
commfoundmesg: .asciiz "Commands: 1-shuffle, 2-quit\nFound words: "
exitmesg: .asciiz "Goodbye, thanks for playing!\n"
errormesg: .asciiz "Error: Invalid word.\n"
usedwordmesg: .asciiz "Error: Word already used.\n"
wordFoundmesg: .asciiz "Found one!\n"
commOne: .word 0x31
commTwo: .word 0x32
newLine: .word 0x0A
input: .space 10
board: .asciiz "a b c\nd e f\ng h i\n"
fout: .asciiz "board.txt"
reservedspace: .space 2048

.text
init:
	jal loadDictionary # load dictionary
main:
	li $v0, 4
	la $a0, screenclear	# clear the previous screen
	syscall
	la $a0, board
 	li $v0, 4
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
	la $a0, newLine
	syscall
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
	# open file syscall
    li $v0, 13
    # load filename
    la $a0, fout
    # open for reading
    li $a1, 0
    # mode is ignored
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

	addi $s0, $s0, 1
	#Generate Random Number between 0-3
	li $a1, 3
	li $v0, 42
	syscall
	
	#Store Random Number into $t1
	move $t1, $a0

	#Branch to Corresponding Shuffle
	beq $s0, 4, shuffleExit
	beq $t1, 0, shuffle1
	beq $t1, 1, shuffle2
	beq $t1, 2, shuffle3
	beq $t1, 3, shuffle4

 
shuffle1:
	#Load board into registers
 	la $t4, board
 	lb $t0, 0($t4)
 	lb $t1, 2($t4)
 	lb $t2, 4($t4)
 	lb $t3, 6($t4)
 	lb $t5, 10($t4)
 	lb $t6, 12($t4)
 	lb $t7, 14($t4)
 	lb $t8, 16($t4)
 
 	#Store shuffled registers into board
 	sb $t0, 16($t4)
 	sb $t1, 14($t4)
 	sb $t2, 12($t4)
 	sb $t3, 10($t4)
 	sb $t5, 6($t4)
 	sb $t6, 4($t4)
 	sb $t7, 2($t4)
 	sb $t8, 0($t4)
    j shuffle
 
shuffle2:
	#Load board into registers
 	la $t4, board
 	lb $t0, 0($t4)
 	lb $t1, 2($t4)
 	lb $t2, 4($t4)
 	lb $t3, 6($t4)
 	lb $t5, 10($t4)
 	lb $t6, 12($t4)
 	lb $t7, 14($t4)
 	lb $t8, 16($t4)
 
 	#Store shuffled registers into board
  	sb $t0, 10($t4)
 	sb $t1, 12($t4)
 	sb $t2, 14($t4)
 	sb $t3, 16($t4)
 	sb $t5, 0($t4)
 	sb $t6, 2($t4)
 	sb $t7, 4($t4)
 	sb $t8, 6($t4)
     	j shuffle
 
shuffle3:
	#Load board into registers
 	la $t4, board
 	lb $t0, 0($t4)
 	lb $t1, 2($t4)
 	lb $t2, 4($t4)
 	lb $t3, 6($t4)
 	lb $t5, 10($t4)
 	lb $t6, 12($t4)
 	lb $t7, 14($t4)
 	lb $t8, 16($t4)
 	
  	#Store shuffled registers into board
 	sb $t0, 4($t4)
 	sb $t1, 6($t4)
 	sb $t2, 0($t4)
 	sb $t3, 2($t4)
 	sb $t5, 14($t4)
 	sb $t6, 16($t4)
 	sb $t7, 10($t4)
 	sb $t8, 12($t4)
    j shuffle
 
shuffle4:
	#Load board into registers
 	la $t4, board
 	lb $t0, 0($t4)
 	lb $t1, 2($t4)
 	lb $t2, 4($t4)
 	lb $t3, 6($t4)
 	lb $t5, 10($t4)
 	lb $t6, 12($t4)
 	lb $t7, 14($t4)
 	lb $t8, 16($t4)
 	
  	#Store shuffled registers into board
 	sb $t0, 2($t4)
 	sb $t1, 0($t4)
 	sb $t2, 6($t4)
 	sb $t3, 4($t4)
 	sb $t5, 12($t4)
 	sb $t6, 10($t4)
 	sb $t7, 16($t4)
 	sb $t8, 14($t4)
    j shuffle

shuffleExit:
	j main

processing:
	# process the user input
	jal stringLength
	move $t2, $v0
	add $t3, $zero, 4
	slt $t1, $t2, $t3
	beq $t1, 1, invalidString	# if string length is < 4
	# check uses the center letter on the board
	# check uses only board letters 0 or 1 times each
	# at any point, if it fails jump or branch to invalidString
	# check if the word has been used already
	# if word has already been used
	li $v0, 4
	la $a0, usedwordmesg
	syscall
	# else, valid word that hasn't already been used
	# add to list
	# update score
	li $v0, 4
	la $a0, wordFoundmesg
	syscall
	
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
	# jr $ra	# ?? option a ??
	 j main		# ?? option b ??

printfound:
	la $t0, reservedspace # load reserved space string into new

foundLoop:
	lb   $t1, 0($t0)
	beq  $t1, $zero endFound

	addi $t0, $t0, 1
	j foundLoop

endFound:
	la $t1 reservedspace
	sub $t3, $t0, $t1 #$t3 now contains the length of the string
	
	li $v0, 1
	la $a0, ($t3)	# print the length of reservedspace
	syscall
	
	jr $ra

exit:
	li $v0, 4		# if it's not command 2, 'exit', we skip this and go on to the processing
	la $a0, exitmesg	# say goodbye
	syscall
	li $v0, 10
	syscall
