.data
promptmesg: .asciiz "\nEnter a word: "
scoremesg: .asciiz "\nScore: "
screenclear: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n"
commfoundmesg: .asciiz "Commands: 1-shuffle, 2-quit\nFound words: "
exitmesg: .asciiz "\nGoodbye, thanks for playing!\n"
errormesg: .asciiz "Error: Invalid word.\n"
usedwordmesg: .asciiz "Error: Word already used.\n"
notLong: .asciiz "Word less that 4 letters.\n"
wordFoundmesg: .asciiz "Found one!\n"
notContain: .asciiz "The input is not contained in the board.\n"
noMid: .asciiz "No middle used in word.\n"
yesMid: .asciiz "Middle used in word.\n"
contain: .asciiz "The input is contained in the board. \n"
commOne: .word 0x31			# a 1 in ascii hex
commTwo: .word 0x32			# a 2 in ascii hex
unusedMark: .word 0x2E		# a . in ascii hex
#usedMark: .word 0x2A		# a * in ascii hex
usedMark: .ascii "*"
endDictMark: .word 0x66		# an f in ascii hex
newLine: .word 0x0A
input: .space 10
board: .asciiz "a b c\nd e f\ng h i\n"
boardP: .space 20
fout: .asciiz "board.txt"
reservedspace: .byte 0:4096

.text
init:
	jal loadDictionary # load dictionary
	li $v0, 30	# fetch the current system time
	syscall
	move $s7, $a0	# now $s6 has the low order 32 bits of time in ms, we don't need the upper 32 for realistic game lengths
main:
	la $a0, reservedspace
 	li $v0, 4
 	syscall
	li $v0, 4
	la $a0, commfoundmesg
	syscall
	jal printfound	# print the currently found set of words
	#li $v0, 4
	#la $a0, scoremesg
	#syscall
	#li $v0, 1
	#add $a0, $s7, $zero		# assuming score is in $s7
	#syscall		# display the score
	li $v0, 4
	la $a0, newLine
	syscall
	li $v0, 4
	la $a0, promptmesg
	syscall
getInput:
	li $v0, 8	# get the input
	la $a0, input
	li $a1, 10
	syscall

	lb $t1, 0($a0)	# get first char into $t1
	lw $t2, commOne
	
	li $v0, 4
	la $a0, screenclear	# clear the previous screen
	syscall
	
	beq $t1, $t2, shuffle	# if command 1
	lw $t2, commTwo
	bne $t1, $t2, processing	# else if not command 2
	j exit		# if command 2, exit program
	
loadDictionary:
	li $v0, 13     # open file syscall num
	la $a0, fout   # load filename
	li $a1, 0	# open for reading
       li $a2, 0       # mode is ignored
       syscall
    
       move $s6, $v0      # move file descriptor to $s6

       li $v0, 14
       move $a0, $s6
       la $a1, reservedspace
       li $a2, 1024
       syscall
       
       # separate board from wordlist
       la $t1, reservedspace
       addi $t1, $t1, 19
       li $t2, '\0'
       sb $t2, ($t1)
       
close:
       li $v0, 16      # close file
       move $a0, $s6
       syscall
    
       jr $ra
    
shuffle:
	# Initialize shuffle counter to 0
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
 	la $t4, reservedspace
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
 	la $t4, reservedspace
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
 	la $t4, reservedspace
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
 	la $t4, reservedspace
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
	add $s0, $zero, $zero
	j main

processing:
	# process the user input
	jal copyBoard
	jal stringLength
	jal containsCenter
	jal contains
	
	# check if the word has been used already
	# if word has already been used
	# else, valid word that hasn't already been used
	# add to list
	# update score
	j main
	
	# check uses only board letters 0 or 1 times each
	# at any point, if it fails jump or branch to invalidString
	# check if word is contained in board (includes checking for duplicate letters)
	
dictionary:
	# check if the word has been used already
	la $a0, input
	
	jal checkDict
		# v0 will contain a 0 if not in the dictionary, a 1 if it's a valid new word, and a 2 if
			# it's a valid word that's already been used
	beqz $v0, invalidString
	bne $v0, 1, validWord
	li $v0, 4
	la $a0, usedwordmesg	# if word has already been used
	syscall
validWord:	# else, valid word that hasn't already been used
	# update as found
	# update score
	li $v0, 4
	la $a0, wordFoundmesg
	syscall
	
	j main
	
copyBoard:
	la $t1, reservedspace
	la $t2, boardP
	
transfer:
	lb $t3, ($t1)
	sb $t3, ($t2)
	
	#Move  to next board character
	addi $t1, $t1, 2
	addi $t2, $t2, 1
	
	beqz $t3, copyExit
	j transfer
	
copyExit:
	jr $ra

contains:
	#Load addresses into registers
	la $t1, boardP
	la $t2, input	
	
	li $t6, 0
	li $t0, 1
	lb $t5, newLine
loadInputs:	
	#Load first character into registers
	lb $t3, ($t1)
	lb $t4, ($t2)

	#if end of input or board exit
	beq $t4, $t5, contained
	beq $t6, $s3, contained
	beqz $t3, notContained
	
	#if input char is contained in board move, to next input char
	beq $t4, $t3, inputNext
	
	#otherwise go to next board char
	j boardNext
	
boardNext:
	#increase board address to next character
	addi $t1, $t1, 1	
	j loadInputs

inputNext:
	#remove byte and increase input address to next character
	sb $t0, ($t1)
	addi $t2, $t2, 1
	addi $t6, $t6, 1
	#reset board address
	la $t1, boardP
	j loadInputs
	
notContained:
	#display notContains message
	li $v0, 4
	la $a0, notContain
	syscall
	j invalidString
contained:
	#display contains message
	li $v0, 4
	la $a0, contain
	syscall
	j containExit
containExit:
	jr $ra
	
containsCenter:
	#Load addresses into registers, and load center character
	la $t1, boardP
	la $t2, input
	lb $t3, 4($t1)
	lb $t5, newLine
getMid:
	#Load input character into register
	lb $t4, ($t2)
	
	#branch statements
	beq $t3, $t4, containsMid
	beq $t4, $t5, invalidCenter	
	
	#continue to next input character
	j nextMid
	
nextMid:
	#Increment to next input character
	addi $t2, $t2, 1 
	j getMid
	
invalidCenter:
	#Display message and jump to invalid string
	li $v0, 4
	la $a0, noMid
	syscall	
	j invalidString

containsMid:
	#display input and return to processing
	li $v0, 4
	la $a0, yesMid
	syscall
	jr $ra
	
checkDict:	# use lb to iterate over the word vs the word in the dictionary
	# address of input word is in $a0
	la $t0, reservedspace	# put address of dictionary into $t0
dictLoop:
	add $t6, $zero, $zero
	# lb for letter
	lb $t5, ($t0)
	lw $t3, endDictMark
	bne $t5, $t3 inDict	# if first char is f
	addi $v0, $zero, 2
	j closeDict
inDict:
	add $t1, $t0, $zero	# put offset of dictionary address into $t1
	add $t1, $t1, 1
	add $t2, $a0, $zero	# put offset of input address into $t2
	lw $t3, unusedMark
	bne $t3, $t5, dictElse	# else if first char is .
	add $v0, $zero, $zero
	j dictChecking
dictElse:
	addi $v0, $zero, 1
dictChecking:
	lb $t3, ($t1)
	lb $t4, ($t2)
	bne $t3, $t4, nonmatch	# if they match, increment offsets and check next
	addu $t1, $t1, 1
	addu $t2, $t2, 1
	addu $t6, $t6, 1
	beq $t6, 9, closeDict
	j dictChecking
nonmatch:	# if they don't
	addu $t0, $t0, 10
	j dictLoop
closeDict:
	bne $v0, 1, dictDone
	lb $t1, usedMark
	sb $t1, ($t0)
dictDone:
	jr $ra


stringLength:
	#initialize counter
	li $t0, 0
	la $t5, input
	
strLenLoop:
	lb $t1, ($t5) # load a character into t1
	lw $t2, newLine
	beqz $t1, exitStrLen
	beq $t1, $t2, exitStrLen	# exit the loop if we have a newLine character
	addi $t5, $t5, 1 #load increment string pointer
	addi $t0, $t0, 1 #increment count
	j strLenLoop
	
exitStrLen:
	slti $t1,$t0, 4
	move $s3, $t0
	beq $t1, 1, invalidLength
	jr $ra

invalidLength:
	li $v0, 4
	la $a0, notLong
	syscall
	

invalidString:
	li $v0, 4
	la $a0, errormesg
	syscall
	# jr $ra	# ?? option a ??
	j main		# ?? option b ??

printfound:
	la $t0, reservedspace # load reserved space string address into $t0
	addi $t0, $t0, 19
	addi $t4, $zero, 0x2A # * char
	addi $t6, $zero, 0x7C # | char

foundLoop:
	lb   $t1, 0($t0)
	beq $t1, $t6, endFound # branch if $t1 is | indicating end of file
	bne $t1, $t4, notUsed # branch if $t1 is not equal to *
	
	addi $t0, $t0, 1
	lb $t1, 0($t0)
printWord:	 # print characters until space reached
	li $v0, 11
	la $a0, ($t1)
	syscall
	
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	addi $t5, $zero, 0x20
	bne $t1, $t5, printWord
	# print space separating words
	addi $t1, $zero, 0x20
	li $v0, 11
	la $a0, ($t1)
	syscall
	
	j foundLoop
	
notUsed:
	addi $t0, $t0, 1
	j foundLoop

endFound:
	jr $ra

exit:
	li $v0, 30	# fetch the current system time
	syscall
	sub $t3, $a0, $s7	# now $t3 will have the time since the round started (in ms) as long as the game takes < ~49 days
	div $t1, $t3, 60000	# $t1 now has the length of the game in min
	
	# get the number of words found into $t0
	
	div $s7, $t0, $t1
	li $v0, 4
	la $a0, scoremesg
	syscall
	li $v0, 1
	add $a0, $s7, $zero		# assuming score is in $s7
	syscall		# display the score
	li $v0, 4
	la $a0, exitmesg	# say goodbye
	syscall
	li $v0, 10
	syscall
