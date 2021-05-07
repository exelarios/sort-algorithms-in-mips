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
option3: .asciiz "3. Something Sort\n"
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
	
exit:
	li $v0, 10
	syscall
	
