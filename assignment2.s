.intel_syntax noprefix

.section .data
    input:  .asciz "Enter n: %d"    # Format string for scanf (reads an integer)
    output: .asciz "sum = %f\n"  	# Format string for printf (prints a double)

    n:   .int 0               	  	# Integer variable n
    sum: .double 1.0          		# Double variable sum
    one: .double 1.0          	  	# Double variable one
    inv: .double 1.0          	  	# Double variable inv

.section .text	
    .global _main	

_main:
    push OFFSET n      				# Push the address of n for scanf
    push OFFSET input 				# Push the format string for scanf
    
	call _scanf        				# Call scanf to read an integer from the user
    add esp, 8         				# Adjust the stack pointer

    mov ecx, n                		# Copy the value of n to ecx for loop control

loop_n:
    fild dword ptr n          		# Load n as an integer into the FPU
    fld qword ptr one         		# Load one into the FPU
    fdiv qword ptr inv        		# Divide one by inv (1/inv) and push the result
    fadd                      		# Add the result to the value in the FPU

    fmul qword ptr sum        		# Multiply sum by the value in the FPU
    fstp qword ptr sum        		# Store the result back to sum

    fld qword ptr one         		# Load one into the FPU
    fadd qword ptr inv        		# Add inv to one and push the result
    fstp qword ptr inv        		# Store the result back to inv

    dec dword ptr n           		# Decrement the value of n

    cmp dword ptr n, 0        		# Compare n to 0
    jne loop_n                		# Jump to loop_n if n is not equal to 0

    push [sum+4]              		# Push the high 32-bits of sum for printf
    push sum                  		# Push the low 32-bits of sum for printf
    push OFFSET output        		# Push the format string for printf
    
	call _printf              		# Call printf to print the result
    add esp, 12               		# Adjust the stack pointer

    ret                       		# Return from the main function

