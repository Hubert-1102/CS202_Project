.data 0x0000				      		
buf: .word 0x0000

.text 0x0000						
start: lui $1,0xFFFF			
       ori $28,$1,0xF000
	   ori $s0,$zero,0
	   ori $s1,$zero,1
	   ori $s2,$zero,2
	   ori $s3,$zero,3
	   ori $s4,$zero,4
	   ori $s5,$zero,5
	   ori $s6,$zero,6
	   ori $s7,$zero,7	
	   
main: lw $t8,0xC74($28)		# t8: status submit
	  bne $t8,$s1,main      # loop to read whether status
	  lw $t1,0xC72($28)		#t1: number		0,1,2,3,4,5,6,7
	  beq $s0,$t1,first
	  beq $s1,$t1,second
	  beq $s2,$t1,third
	  beq $s3,$t1,fourth
	  beq $s4,$t1,fifth
	  beq $s5,$t1,sixth
	  beq $s6,$t1,seventh
	  beq $s7,$t1,eighth
	  		 
first: lw $t9,0xC73($28)    # t9: submit
	   bne $t9,$s1,first    # loop to read whether submit
	   
	   lw $t0,0xC70($28)         # the low 8 bits
	   lw $t2,0xC71($28)         # the high 8 bits
	   sll $t2,$t2,8
	   or $t0,$t0,$t2
	   	   	   
	   
	   lw $t9,0xC73($28)		 # t9: submit
	   bne $t9,$s1,first        # loop to read whether submit
	   sw $t0,0xC60($28)    # show the lower 8 bits
	   srl $t4,$t0,8
	   sw $t4,0xC61($28)		# show the higher 8 bits
	   addi $t2,$t0,0
	   addi $t3,$zero,0

loop1: beq $t2,$zero,judge
	   sll $t3,$t3,1
	   andi $t4,$t2,1
	   or $t3,$t3,$t4
	   srl $t2,$t2,1
	   j loop1

judge: sw $s0,0xC62($28)
       bne $t0,$t3,Exit
	   sw $s1,0xC62($28)
	   j Exit
	   
	   
second: sw $zero,0xC62($28)
	    beq $t7,$s2,Exit         # t7: count variable

loop2: lw $t9,0xC73($28)		# t9: submit
	   bne $t9,$s1,loop2        # loop to read whether submit
	   beq $t7,$s0,read1   #40
	   beq $t7,$s1,read2   #41
	   
read1: lw $t2,0xC70($28)
	   lw $t4,0xC71($28)
	   sll $t4,$t4,8
	   or $t2,$t2,$t4
	   sw $t2,0xC60($28)    # show the low 8 bits
	   srl $t4,$t2,8
	   sw $t4,0xC61($28)		# show the high 8 bits
	   addi $t7,$t7,1
	   j second

read2: lw $t3,0xC70($28)
	   lw $t4,0xC71($28)
	   sll $t4,$t4,8
	   sw $t3,0xC60($28)
	   srl $t4,$t3,8
	   sw $t4,0xC61($28)
	   addi $t7,$t7,1
	   j second

	   
third: sw $zero,0xC62($28)
	   and $t4,$t2,$t3      # a & b
	   sw $t4,0xC60($28)
	   srl $t4,$t4,8
	   sw $t4,0xC61($28)
	   j Exit
	   
fourth: sw $zero,0xC62($28)
		or $t4,$t2,$t3
		sw $t4,0xC60($28)
		srl $t4,$t4,8
	    sw $t4,0xC61($28)
		j Exit
		
fifth: sw $zero,0xC62($28)
	   xor $t4,$t2,$t3
	   sw $t4,0xC60($28)
	   srl $t4,$t4,8
	   sw $t4,0xC61($28)
	   j Exit
	   
sixth: sw $zero,0xC62($28)
	   sllv $t2,$t2,$t3   # t2 : a t3 : b
	   sw $t2,0xC60($28)
	   srl $t4,$t2,8
	   sw $t4,0xC61($28)
	   j Exit
	   
seventh: sw $zero,0xC62($28)
		 srlv $t2,$t2,$t3
		 sw $t2,0xC60($28)
		 srl $t4,$t2,8
	     sw $t4,0xC61($28)
		 j Exit
		 
eighth: sw $zero,0xC62($28)
		srav $t2,$t2,$t3
		sw $t2,0xC60($28)
		srl $t4,$t2,8
	    sw $t4,0xC61($28)
		j Exit
	   
Exit: 
	  j main
