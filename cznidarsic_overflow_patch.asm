.data
    str: .asciiz "You've earned an A+!"
    buffer: .space 28
    
.text
    li $v0,8
    la $a0, buffer
    li $a1, 28 #changed this from 28 to 12
    move $t0,$a0
    syscall #read String input from user
    
    move $a0, $t0
    jal print #jump and link to the "print:" function
    
    li $v0, 10
    syscall #exit program
    
    print:
    	addi $sp, $sp, -20
    	sw $ra, 36($sp) #save the return address to the stack
    	sw $a0, 32($sp) #save a0 to the stack
    	
    	addi $t4, $sp, 0
    	la $t1, ($a0) #load address of the buffer stored in $a0
    	
    	load_str:
	    lbu $t2, ($t1)
	    slti $t3, $t2, 1
	    beq $t2, 48, null #if $t2 == 48, branch to "null:" function
	    
	    resume:
    	    	
    	    	sb $t2, 0($t4)
    	    	addi $t4, $t4, 1
    	    	addi $t1, $t1, 1
    	    	bne $t3, 1, load_str #if $t3 != 1, jump back up to "load_str:". This is the main loop condition
    	    	#to iterate across all characters in the user input
    	
    	    li $v0, 4
    	    syscall
    
    	    lw $ra 36($sp) #reinstate the return address from the stack (patched)
    	    lw $a0 32($sp) #reinstate old contents of $a0 from the stack (patched)
    		
    	    null:
    		addi $t2, $t2, -48
    		j resume #jump back to "resume:"

print_a: #potentially malicious function
    la $a0, str
    li $v0, 4
    syscall #print the message stored in str
