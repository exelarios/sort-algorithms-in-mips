# Authors: Bradley Carlson, Saharat Chokboonanun, Deric Kwok, Nigel Fang
# Description: Types of Sorting Algorthims

.data
#array: .word 2, 5, 1, 9, 30, 4, 25, 10, 40, 56, 23, 17, 8, 3, 6
#size: .word 15

prompt1: .asciiz "Which sorting algorithm do you want to run?\n"
prompt2: .asciiz "Enter the array size: "
prompt3: .asciiz "Please enter the element: "
invalidInput: .asciiz "Invalid input, please try again."
option1: .asciiz "1. Selection Sort\n"
option2: .asciiz "2. Quick Sort\n"
option3: .asciiz "3. Bubble Sort\n"
option4: .asciiz "4. Something Sort\n"
testPrompt1: .asciiz "Hello"
newLine: .asciiz "\r\n"
space: .ascii " "

.text
main:

# $s0 array size
# $s1 base address for array

menu:
	# display the prompt to enter the array size
	la $a0, prompt2
	li $v0, 4
	syscall
	
	# read the array size
	li $v0, 5
	syscall
	move $s0, $v0
	
	sll $t0, $s0, 2		# the size * 4 to get the number of bytes
	
	# dynamic memory allocation
	move $a0, $t0
	li $v0, 9
	syscall
	move $s1, $v0
	
	li $t1, 0	# i
	populate_array_loop:
		beq $t1, $s0, continue_menu
		
		# ask for input
		la $a0, prompt3
		li $v0, 4
		syscall
		
		# read input
		li $v0, 5
		syscall
		move $t2, $v0
		
		sll $t3, $t1, 2		# t3 = i * 4; offset
		add $s2, $t3, $s1	# $s2 (new base address) = offset + current base @
		sw $t2, 0($s2)		# save the element in memory
		addi $t1, $t1, 1	# increment i
		
		j populate_array_loop
		
continue_menu:
	jal print
	
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
	jal print
	j exit

choice2:
	jal quickSortStart
	j exit
	
choice3:
	jal bubbleSort
	j exit
	
choice4:
	j exit

selectionSort:
	addi $sp, $sp, -44
	sw $a3, 40($sp)
	sw $a2, 36($sp)
	sw $a1, 32($sp)
	sw $t7, 28($sp)
	sw $t6, 24($sp)
	sw $t5, 20($sp)
	sw $t4, 16($sp)
	sw $t3, 12($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	
	# loop through the unsorted array
	li $t0, 0		# i; counter
	subi $t1, $s0, 1	# array length - 1
	
	# find the minium element in unsorted array
	selectionSort_loop:
	
		move $t2, $t0		# min_idx = i
		addi $t3, $t0, 1	# j; inner_loop iterator
		selectionSort_inner_loop:
		
			move $t5, $t3
			sll $t5, $t5, 2
			add $t5, $t5, $s1
			lw $a1, 0($t5)	# arr[j]
			
			move $t6, $t2
			sll $t6, $t6, 2
			add $t6, $t6, $s1
			lw $a2, 0($t6)	# arr[min_idx]
			
			bge $a1, $a2, skip_set_min_idex		# arr[i] >= arr[min_idx]; jump to skip_set_min-idex
			move $t2, $t3
			
			skip_set_min_idex:
							
			addi $t3, $t3, 1
			ble $t3, $s0, selectionSort_inner_loop
		
		move $a3, $t0
		sll $a3, $a3, 2
		add $a3, $a3, $s1	
		lw $t5, 0($a3)		# arr[i]
		
		# arr[min_idx] = arr[i]
		sw $t5, 0($t6)
		
		sw $a2, 0($a3)		#  arr[i] = arr[min_idx]
			
		addi $t0, $t0, 1
		blt $t0, $t1, selectionSort_loop
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	lw $t6, 24($sp)
	lw $t7, 28($sp)
	lw $a1, 32($sp)
	lw $a2, 36($sp)
	lw $a3, 40($sp)
	addi $sp, $sp, 44
	jr $ra

quickSortStart:

	move		$a0, $s1
	addi		$s0, $s0, -1
	move		$a2, $s0
	
	jal 		quickSort
	
	jal		PRINT
	
	j		exit
	
PRINT:
	move		$t0, $s0
	addi		$t0, $t0, 1
	move		$s0, $s1

	
	Loop:
		beq		$t0, $zero, out_print
		

	# printing Array elements
		li		$v0, 1
		lw		$a0, 0($s0)
		syscall
		
		li		$v0, 4
		la		$a0, space
		syscall
	
		addi		$t0, $t0, -1
		addi		$s0, $s0, 4
	
		j		Loop
	out_print:
		# make new line
		li		$v0, 4
		la		$a0, newLine
		syscall
		jr		$ra

quickSort:
	addi		$sp, $sp, -24	
	sw		$s0, 0($sp)	
	sw		$s1, 4($sp)	
	sw		$s2, 8($sp)	
	sw		$a1, 12($sp)	
	sw		$a2, 16($sp)	
	sw		$ra, 20($sp)	

	move	$s0, $a1		# l = left
	move	$s1, $a2		# r = right
	move	$s2, $a1		# p = left

# while (l < r)
while:
	bge		$s0, $s1, done
	
# while (arr[l] <= arr[p] && l < right)
Loop1:
	li		$t7, 4			# t7 = 4
	# t0 = &arr[l]
	mult		$s0, $t7
	mflo		$t0			# t0 =  l * 4bit
	add		$t0, $t0, $a0		# t0 = &arr[l]
	lw		$t0, 0($t0)
	# t1 = &arr[p]
	mult		$s2, $t7
	mflo		$t1			# t1 =  p * 4bit
	add		$t1, $t1, $a0		# t1 = &arr[p]
	lw		$t1, 0($t1)
	# check arr[l] <= arr[p]
	bgt		$t0, $t1, Loop1_done
	# check l < right
	bge		$s0, $a2, Loop1_done
	# l++
	addi		$s0, $s0, 1
	j		Loop1
	
Loop1_done:

# while (arr[r] >= arr[p] && r > left)
Loop2:
	li		$t7, 4			# t7 = 4
	# t0 = &arr[r]
	mult		$s1, $t7
	mflo		$t0			# t0 =  r * 4bit
	add		$t0, $t0, $a0		# t0 = &arr[r]
	lw		$t0, 0($t0)
	# t1 = &arr[p]
	mult		$s2, $t7
	mflo		$t1			# t1 =  p * 4bit
	add		$t1, $t1, $a0		# t1 = &arr[p]
	lw		$t1, 0($t1)
	
	blt		$t0, $t1, Loop2_done	# check arr[r] >= arr[p]
	ble		$s1, $a1, Loop2_done	# check r > left

	addi		$s1, $s1, -1			# r--
	j		Loop2
	
Loop2_done:

# if (l >= r)
	blt		$s0, $s1, If
# SWAP (arr[p], arr[r])
	li		$t7, 4			# t7 = 4
	# t0 = &arr[p]
	mult		$s2, $t7
	mflo		$t6			# t6 =  p * 4bit
	add		$t0, $t6, $a0		# t0 = &arr[p]
	# t1 = &arr[r]
	mult		$s1, $t7
	mflo		$t6			# t6 =  r * 4bit
	add		$t1, $t6, $a0		# t1 = &arr[r]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
# quick(arr, left, r - 1)
	# set arguments
	move		$a2, $s1
	addi		$a2, $a2, -1		# a2 = r - 1
	jal		quickSort
	# pop stack
	lw		$a1, 12($sp)		# load a1
	lw		$a2, 16($sp)		# load a2
	lw		$ra, 20($sp)		# load ra
	
# quick(arr, r + 1, right)
	# set arguments
	move		$a1, $s1
	addi		$a1, $a1, 1		# a1 = r + 1
	jal		quickSort
	# pop stack
	lw		$a1, 12($sp)		# load a1
	lw		$a2, 16($sp)		# load a2
	lw		$ra, 20($sp)		# load ra
	
# return
	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi		$sp, $sp, 24		# Adjest sp
	jr		$ra

If:

# SWAP (arr[l], arr[r])
	li		$t7, 4			# t7 = 4
# t0 = &arr[l]
	mult		$s0, $t7
	mflo		$t6			# t6 =  l * 4bit
	add		$t0, $t6, $a0		# t0 = &arr[l]
# t1 = &arr[r]
	mult		$s1, $t7
	mflo		$t6			# t6 =  r * 4bit
	add		$t1, $t6, $a0		# t1 = &arr[r]
# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
	j		while
	
done:
	lw	$s0, 0($sp)	
	lw	$s1, 4($sp)		
	lw	$s2, 8($sp)		
	addi	$sp, $sp, 24	
	jr	$ra
	
bubbleSort:
	move $a0, $s1		# a0 = array base address 
	move $a1, $s1		# a1 = array base address for exit loop
	li $t0, -1		# t0 is index, start at -1 bc addi at start of out_loop
	li $t1, 0		# t1 is index2	
	move $t2, $s0		# t2 is length of array
	subi $s2, $t2, 1	# s2 = array length - 1
	move $s3, $t2		# s3 = array length - 1 - index
	li $t6, 0		# set t6 to 0 for exit loop
	
	out_loop:
		addi $t0, $t0, 1		# index++
		bge $t0, $t2, exit_loop		# if index >= array length - 1, exit loop	
		j in_loop			# go to inner loop
	
	in_loop:
		li $t1, 0			# index2 = 0
		move $a0, $s1
		sub $s3, $s2, $t0		# calc array length - index - 1 once per outer loop run
		j in_loop_content		# go to inner loops content
		
	in_loop_content:
		bge $t1, $s3, out_loop		# if index2 >= array length - 1 - index, exit to outer loop
		lw $t4, 0($a0)			# t4 = array[index2]
		lw $t5, 4($a0)			# t5 = array[index2 + 1]
		bgt $t4, $t5, swap		# if ( array[index2] > array[index2 + 1], then swap
		addi $a0, $a0, 4		# increment base address
		addi $t1, $t1, 1		# index2++
		bge $t1, $s3, out_loop		# check if the increment made t1 > s3
		blt $t1, $s3, in_loop_content	# if index2 < array length - index - 1, go back to top of inner loop
	swap:
		sw $t4, 4($a0)			# array[index2 + 1] = array[index2]
		sw $t5, 0($a0)			# array[index2] = array[index2 + 1]
		addi $a0, $a0, 4		# increment base address
		addi $t1, $t1, 1		# index2++
		j in_loop_content
		
	exit_loop:
		bgt $t6, $s2, exit		# if we reach end of array, exit program
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
		
print:
	addi $sp, $sp, -8
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	
	li $t0, 0
	print_loop:
		move $t1, $t0
		sll $t1, $t1, 2
		add $t1, $t1, $s1
		lw $t1, 0($t1)
		
		move $a0, $t1
		li $v0, 1
		syscall
		
		la $a0, space
		li $v0, 4
		syscall
	
		addi $t0, $t0, 1
		blt $t0, $s0, print_loop
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
exit:
	li $v0, 10
	syscall
