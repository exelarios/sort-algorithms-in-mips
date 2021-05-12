# Authors: Bradley Carlson, Saharat Chokboonanun, Deric Kwok, Nigel Fang
# Description: Types of Sorting Algorthims

.data


# We can maybe implement a way for user to input their custom array after we finish implementing all the algorithms.
array: .word 2, 5, 1, 9, 30, 4, 25, 10, 40, 56, 23, 17, 8, 3, 6
size: .word 15

prompt1: .asciiz "Which sorting algorithm do you want to run?\n"
invalidInput: .asciiz "Invalid input, please try again."
option1: .asciiz "1. Selection Sort\n"
option2: .asciiz "2. Quick Sort\n"
option3: .asciiz "3. Bubble Sort\n"
option4: .asciiz "4. Something Sort\n"
testPrompt1: .asciiz "Hello"
newLine: .asciiz "\r\n"

.text
main:

menu:
	
	# display welcome message
	la $a0, prompt1
	li $v0, 4
	syscall
	
	# display options
	la $a0, option1
	li $v0, 4
	syscall
	
	la $a0, option2
	li $v0, 4
	syscall
	
	la $a0, option3
	li $v0, 4
	syscall
	
	la $a0, option4
	li $v0, 4
	syscall
	
	# ask for input
	li $v0, 5
	syscall
	move $a0, $v0
	
	# if statements depending on the user's input.
	beq $a0, 1, choice1
	beq $a0, 2, choice2
	beq $a0, 3, choice3
	beq $a0, 4, choice4
	beq $a0, 0, exit
	
	# If none if the conditionals meet, we will just prompt invalid input.
	la $a0, invalidInput
	li $v0, 4
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	j menu

choice1:
	jal selectionSort
	j exit

choice2:
	jal quickSort
	j exit
	
choice3:
	jal bubbleSort
	j exit
	
choice4:
	j exit

selectionSort:
	add $sp, $sp, -4
	sw $ra, 4($sp)
	
	la $a0, testPrompt1
	li $v0, 4
	syscall
	
	addi $sp, $sp, 4
	jr $ra

quickSort:
	la $a0, testPrompt1
	li $v0, 4
	syscall
bubbleSort:
	la $a0, array		# a0 = array base address 
	la $a1, array
	li $t0, -1		# t0 is index, start at -1 bc addi at start of out_loop
	li $t1, 0		# t1 is index2	
	li $t2, 15		# t2 is length of array
	li $s0, 14		# s0 = array length - 1
	li $s1, 14		# s1 = array length - 1 - index
	
	out_loop:
		addi $t0, $t0, 1		# index++
		bge $t0, $t2, finish_sort	# if index >= array length - 1, exit loop	
		j in_loop			# go to inner loop
	
	in_loop:
		li $t1, 0			# index2 = 0
		la $a0, array
		sub $s1, $s0, $t0		# calc array length - index - 1 once per outer loop run
		j in_loop_content		# go to inner loops content
		
	in_loop_content:
		bge $t1, $s1, out_loop		# if index2 >= array length - 1 - index, exit to outer loop
		lw $t4, 0($a0)			# t4 = array[index2]
		lw $t5, 4($a0)			# t5 = array[index2 + 1]
		bgt $t4, $t5, swap		# if ( array[index2] > array[index2 + 1], then swap
		addi $a0, $a0, 4		# increment base address
		addi $t1, $t1, 1		# index2++
		bge $t1, $s1, out_loop		# check if the increment made t1 > s1
		blt $t1, $s1, in_loop_content	# if index2 < array length - index - 1, go back to top of inner loop
	swap:
		sw $t4, 4($a0)			# array[index2 + 1] = array[index2]
		sw $t5, 0($a0)			# array[index2] = array[index2 + 1]
		addi $a0, $a0, 4		# increment base address
		addi $t1, $t1, 1		# index2++
		j in_loop_content
		
	finish_sort:
		jr $ra
		
exit_loop:
	bge $t6, 15, exit		# if we reach end of array (15 words), exit program
	lw $t2, 0($a1)			# t2 = array[current]
	addi $a1, $a1, 4		# increment base address to next word
		
	li $v0, 1			# 1 is syscall code for print int
	move $a0, $t2			# t2 is to be printed
	syscall				# print t2
		
	li $a0, 32			# 32 is the space character so array is readable
	li $v0, 11			# 11 is syscall code to print character
	syscall				# print space character
	
	addi $t6, $t6, 1		# increment counter 
	j exit_loop			# go back to beginning of loop
		
exit:
	li $v0, 10			# 10 is syscall code for exit
	syscall				# exit
