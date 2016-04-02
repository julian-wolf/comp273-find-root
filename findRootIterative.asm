# Julian Wolf
# 260506607

	.text
	.globl findRoot
	
findRoot:

	subi	$sp, $sp, 32	# save the variable registers used by the calling function
	sw	$s7, 28($sp)
	sw	$s6, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 08($sp)
	sw	$s1, 04($sp)
	sw	$s0, 00($sp)

	subi	$sp, $sp, 12	# save the argument registers used by the calling function
	sw	$a2, 08($sp)
	sw	$a1, 04($sp)
	sw	$a0, 00($sp)
	
#
# actual function body begins here
#



return:

#
# actual function body ends here
#

	lw	$a2, 08($sp)	# reset the argument registers used within the function
	lw	$a1, 04($sp)
	lw	$a0, 00($sp)
	addi	$sp, $sp, 12

	lw	$s7, 28($sp)	# reset the variable registers used within the function
	lw	$s6, 24($sp)
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 08($sp)
	lw	$s1, 04($sp)
	lw	$s0, 00($sp)
	addi	$sp, $sp, 32

	jr	$ra		# jump back to the calling program
