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
	   
main: lw $t9,0xC74($28)		# t9: status submit
	  bne $t9,$s1,main      # loop to read whether status
	  lw $t0,0xC72($28)		# t0: number		0,1,2,3,4,5,6,7			
	  beq $s0,$t0,first
	  beq $s1,$t0,second
	  beq $s2,$t0,third
	  beq $s3,$t0,fourth
	  beq $s4,$t0,fifth
	  beq $s5,$t0,sixth
	  beq $s6,$t0,seventh
	  beq $s7,$t0,eighth

first: addi $t1,$zero,0		# t1: count variable
	   addi $t2,$zero,0     # t2: address count variable

loop1: lw $t8,0xC73($28)    # t8: data submit
	   bne $t8,$s1,loop1
	   lw $t3,0xC70($28)    # t3: the number of input data
	   
	   sw $t3,0xC60($28)    # debug

readData: beq $t1,$t3,Exit
		  ori $v0,$zero,	1
		  addi $v1,$zero,0

while1: addi $v1,$v1,1			# meaningless loop
	   bne $v0,$v1,while1
		
	   addi $v0,$zero,0
	   addi $v1,$zero,0
	   
	  # jal nopLoop



		  lw $t8,0xC73($28)
		  bne $t8,$s1,readData
		  addi $t1,$t1,1    # add one
		  lw $t4,0xC70($28) # t4: the value of input data (8bit!!!)
		  
		  sw $t4,0xC60($28) # debug
		  
		  sw $t4,0($t2)
		  addi $t2,$t2,4
		  j readData
		  
second: addi $t6,$zero,0   # t6: index

hardcopy2: beq $t6,$t3,copyFinish2
		  sll $t1,$t3,2
		  sll $t7,$t6,2
		  lw $t5,0($t7)
		  add $t7,$t7,$t1
		  sw $t5,0($t7)

		  addi $t6,$t6,1   # index++
		  j hardcopy2



copyFinish2:	sw $zero,0xC60($28)
			sw $zero,0xC61($28)
			addi $t5,$t3,0     # t3: n,  t5: the first address of the array
			sll $t5,$t5,2
			addi $t6,$zero,0   # t6: i
			addi $t7,$zero,0   # t7: j
		
foroutloop2: slt $t1,$t6,$t3
			 beq $t1,$zero,debug2
			 addi $t7,$t6,-1
			
forinloop2: slti $t2,$t7,0
			bne $t2,$zero,innerLoopExit2
			sll $t2,$t7,2    
			
			add $t2,$t2,$t5   # t2 : j     the first address of dataset 1
			lw $v0,0($t2)     # array[j]
			lw $v1,4($t2)	  # array[j+1]
			
			sltu $a0,$v1,$v0  # if (array[j+1] < array[j])
			beq $a0,$zero,innerLoopExit2
			sw $v0,4($t2)
			sw $v1,0($t2)    # swap
			
			addi $t7,$t7,-1  # j--
			
			addi $v0,$zero,0
			addi $v1,$zero,0
			addi $a0,$zero,0
			
			j forinloop2
			

innerLoopExit2: addi $t6,$t6,1    # i++
			    j foroutloop2
			    

debug2: #lw $26,16($zero)
		#sw $26,0xC62($28)
		#lw $26,20($zero)
		#sw $26,0xC61($28)
		#lw $26,24($zero)
		#sw $26,0xC60($28)
		j Exit
			 
			 
third: sw $zero,0xC60($28)
	   sw $zero,0xC61($28)
	   sw $zero,0xC62($28)
	   sll $t5,$t3,2       # t3: n = n << 2    the whole length of the array
	   add $t5,$t5,$t5     # t3: n,  t5: the first address of the dataset 2
	   addi $t6,$zero,0   # t6: i
	   
forloop3rd: slt $t1,$t6,$t3
			beq $t1,$zero,debug3  # t1: the index of dataset 1
			sll $t1,$t6,2
			add $t8,$t1,$zero   # the index of dataset 0
			add $t1,$t1,$t5     # the index of dataset 2
			
			lw $v0,0($t8)    # array[i]
			
			andi $t4,$v0,0x0080
			srl $t4,$t4,7
			
			# slt $t1,$v0,$zero
			# sw $v0,0($t1)
			beq $t4,$s1,negative
			         
			sw $v0,0($t1)
			addi $t6,$t6,1     # positive
			j forloop3rd
			

negative: xori $v0,$v0,0x00ff
		  addiu $v0,$v0,1
		  ori $v0,$v0,0xff80
	  
		  lui $v1,0xffff
		  or $v0,$v0,$v1
		  
		  sw $v0,0($t1)
		  
		  addi $t6,$t6,1
		  j forloop3rd
		  
		  
debug3: #lw $26,32($zero)
		#sw $26,0xC62($28)
		#lw $26,36($zero)
		#sw $26,0xC61($28)
		#lw $26,40($zero)
		#sw $26,0xC60($28)
		j Exit
			 
			 
			 
fourth: sw $zero,0xC60($28)
	   sw $zero,0xC61($28)
	   sw $zero,0xC62($28)
	   addi $t6,$zero,0   # t6: index

hardcopy4: beq $t6,$t3,copyFinish4
		  sll $t1,$t3,2
		  sll $t7,$t6,2
		  add $t4,$t1,$t1
		  add $t7,$t7,$t4   # the first address of dataset 2
		  lw $t5,0($t7)    
		  add $t7,$t7,$t1   # the first address of dataset 3
		  sw $t5,0($t7)

		  addi $t6,$t6,1   # index++
		  j hardcopy4



copyFinish4:	sw $zero,0xC60($28)
			sw $zero,0xC61($28)
			sw $zero,0xC62($28)

			sll $t4,$t3,2
			addi $t5,$zero,0
			add $t5,$t5,$t4
			add $t5,$t5,$t4
			add $t5,$t5,$t4      # t5: the first address of dataset 3
			addi $t6,$zero,0   # t6: i
			addi $t7,$zero,0   # t7: j
		
foroutloop4: slt $t1,$t6,$t3
			 beq $t1,$zero,debug4
			 addi $t7,$t6,-1
			
forinloop4: slti $t2,$t7,0
			bne $t2,$zero,innerLoopExit4
			sll $t2,$t7,2    
			
			add $t2,$t2,$t5   # t2 : j     the index of dataset 3
			lw $v0,0($t2)     # array[j]
			lw $v1,4($t2)	  # array[j+1]
			
			slt $a0,$v1,$v0  # if (array[j+1] < array[j])
			beq $a0,$zero,innerLoopExit4
			sw $v0,4($t2)
			sw $v1,0($t2)    # swap
			
			addi $t7,$t7,-1  # j--
			
			addi $v0,$zero,0
			addi $v1,$zero,0
			addi $a0,$zero,0
			
			j forinloop4
			

innerLoopExit4: addi $t6,$t6,1    # i++
			    j foroutloop4
			    

debug4: #lw $26,48($zero)
		#sw $26,0xC62($28)
		#lw $26,52($zero)
		#sw $26,0xC61($28)
		#lw $26,56($zero)
		#sw $26,0xC60($28)
		j Exit	


fifth: sw $zero,0xC61($28)
	   sw $zero,0xC62($28)
	   addi $t5,$t3,0     # t3: n,  t5: the first address of the array
	   sll $t6,$t5,2
	   sll $t5,$t5,2
	   
	   lw $a2,0($t5)      # a2: min element

	   add $t5,$t5,$t6
	   addi $t5,$t5,-4
	   
	   lw $a3,0($t5)	  # a3: max element
	   
	   sub $a2,$a3,$a2    # a3 - a2
	   
	   andi $t6,$a2,0xffff
	   sw $t6,0xC60($28)
	   
	   lui $t6,0xffff
	   
	   and $t6,$t6,$a2
	   srl $t6,$t6,16
	   sw $t6,0xC61($28)
	   
	   addi $a2,$zero,0
	   addi $a3,$zero,0
	   
	   j Exit
	   

sixth: sw $zero,0xC61($28)
	   sw $zero,0xC62($28)
	   addi $t5,$t3,0     # t3: n,  t5: the first address of the array
	   
	   sll $t5,$t5,2
	   addi $t6,$t5,0
	   add $t5,$t5,$t6
	   add $t5,$t5,$t6
	   
	   lw $a2,0($t5)      # a2: min element

	   add $t5,$t5,$t6
	   addi $t5,$t5,-4
	   
	   lw $a3,0($t5)	  # a3: max element
	   
	   sub $a2,$a3,$a2    # a3 - a2
	   
	   andi $t6,$a2,0xffff
	   sw $t6,0xC60($28)
	   
	   lui $t6,0xffff
	   
	   and $t6,$t6,$a2
	   srl $t6,$t6,16
	   sw $t6,0xC61($28)
	   
	   addi $a2,$zero,0
	   addi $a3,$zero,0
	   
	   j Exit


seventh: sw $zero,0xC60($28)
		 sw $zero,0xC61($28)
		 sw $zero,0xC62($28)
		 lw $t8,0xC73($28)    # t8: data submit
	   	 bne $t8,$s1,seventh
	     lw $t4,0xC70($28)    # t4: which number of dataset
	     
	     ori $v0,$zero,	1
		 addi $v1,$zero,0

while7: addi $v1,$v1,1			# meaningless loop
	    bne $v0,$v1,while7
		
	    addi $v0,$zero,0
	    addi $v1,$zero,0
	     
	     
readIndex: lw $t8,0xC73($28)
	       bne $t8,$s1,readIndex
	       lw $t5,0xC70($28)  # t5: the index want to search
	       
	       # sll $t6,$t3,2
	       # addi $t1,$t6,0
	       sll $t1,$t3,2
	       addi $t7,$zero,0   # t7 is a count variable
	       addi $t6,$zero,0
	       
calSetNum: beq $t7,$t4,init
		   add $t6,$t6,$t1   # t6: the base address of the index
		   addi $t7,$t7,1
		   j calSetNum
	       
init: addi $t7,$zero,0
calIndex: beq $t7,$t5,showData
	      addi $t6,$t6,4
	      addi $t7,$t7,1
	      j calIndex
	      

showData: lw $t2,0($t6)
		  andi $t2,$t2,0x00ff # take the lower 8 bits of the result
		  sw $t2,0xC60($28)
		  j Exit
		  

eighth: sw $zero,0xC60($28)
		sw $zero,0xC61($28)
		sw $zero,0xC62($28)
		lw $t8,0xC73($28)
		bne $t8,$s1,eighth
		lw $t4,0xC70($28)  # t4: the index want to search
		addi $t5,$zero,0
	    

dataset0: sw $zero,0xC62($28)
		  sw $t4,0xC61($28)
		  sll $t5,$t4,2
		  lw $t1,0($t5)
		  sw $t1,0xC60($28)
		  
		  
		  	  
# meaningless loop (about 5 seconds)
			 lui $30,0x0216
			 ori $30,$30,0x0ec0
			 addi $t2,$zero,0 # (count variable)
			 
fiveSeconds: beq $t2,$30,dataset2
			 addi $t2,$t2,1
			 j fiveSeconds


dataset2: sw $s2,0xC62($28)
		  sw $t4,0xC61($28)
		  sll $t5,$t4,2
		  sll $t6,$t3,3        # the first address of the dataset 2
		  add $t5,$t5,$t6
		  lw $t1,0($t5)
		  sw $t1,0xC60($28)
		  j Exit
		  
		  
		  
Exit: 
	  j main
	  
	  
	  
	  
	  

nopLoop: ori $v0,$zero,5
		 addi $v1,$zero,0

bubble: addi $v1,$v1,1
		bne $v0,$v1,bubble
		
		addi $v0,$zero,0
		addi $v1,$zero,0
		
		jr $ra
	   
	   
	   
