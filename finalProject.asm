# Author: Nigel Fang 
# Date: 5/4/2021
# Description Final Project
# Bubble Sort algo
#
# for ( index = 0; index < array length - 1; index++ )
#	for ( index2 = 0; index2 < array length - index - 1; index2++ )
#		if ( array[index2] > array[index2 + 1] )
#			swap

.data 
Array: .word 2,5,1,9,30,4,25,10,40,56,23,17,8,3,6
.text
main:
	la $a0, Array		# a0 = array base address 
	la $a1, Array
	li $t0, -1		# t0 is index, start at -1 bc addi at start of out_loop
	li $t1, 0		# t1 is index2	
	li $t2, 15		# t2 is length of array
	li $s0, 14		# s0 = array length - 1
	li $s1, 14		# s1 = array length - 1 - index
	
	out_loop:
		addi $t0, $t0, 1		# index++
		bge $t0, $t2, exit_loop		# if index >= array length - 1, exit loop	
		j in_loop			# go to inner loop
	
	in_loop:
		li $t1, 0			# index2 = 0
		la $a0, Array
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

	