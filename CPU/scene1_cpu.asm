.data 0x0000
	buf: .word 0x0000
.text 0x0000
start:
	lui $t1,0xFFFF
        ori  $t7,$t1,0xF000
		and  $t2, $zero, $zero
		addi  $t2,$zero,1

	ori $s0,$zero,0
	ori $s1,$zero,1
	ori $s2,$zero,2
	ori $s3,$zero,3
	ori $s4,$zero,4
	ori $s5,$zero,5
	ori $s6,$zero,6
	ori $s7,$zero,7
switled:

	#sw20==1,confirm instruction
	confirm:
	lw    $t1,0xC72($t7)
	sll   $t1,$t1,3
	srl	  $t1,$t1,7
	bne	  $t1,$t2,confirm
	
	lw    $t1,0xC72($t7)
	srl   $t1,$t1,5
	beq   $t1,$s0,zzz
	beq   $t1,$s1,zzo
	beq   $t1,$s2,zoz
	beq   $t1,$s3,zoo
	beq   $t1,$s4,ozz
	beq   $t1,$s5,ozo
	beq   $t1,$s6,ooz
	beq   $t1,$s7,ooo
zzz:
	lw   $t1,0xC70($t7)
	and  $t3, $zero, $zero
	and  $t4, $zero, $zero
	   loop1:
      and $t3,$t1,1
      sll $t4,$t4,1
      add $t4,$t4,$t3
      srl $t1,$t1,1
      bne $t1,$zero,loop1
	bne $t4,$t1,shownot
	#led 18 is binary palindrome
	lw   $t1,0xC70($t7)
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero)
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,30
	sw   $t1,0xC62($t7)
	j switled
	
	
	shownot:
	lw   $t1,0xC70($t7)
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero)
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
zzo:
	lw $t5,0xC70($t7)
	
	lw    $t1,0xC70($t7)
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	
	sw    $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	
	#sw16==1,read b
	zzoo:
	lw    $t1,0xC72($t7)
	sll   $t1,$t1,7
	srl   $t1,$t1,7
	bne	  $t1,$t2,zzoo
	
	lw    $t6,0xC70($t7)
	
	lw    $t1,0xC70($t7)
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	
	sw    $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
zoz:
	and  $t1,$t5,$t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
zoo:
	or  $t1,$t5,$t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
ozz:
	xor  $t1,$t5,$t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
	
ozo:
	sllv $t1, $t5, $t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
ooz:
	srlv $t1, $t5, $t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
ooo:
	srav $t1, $t5, $t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
	