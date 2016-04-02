# Julian Wolf
# 260506607

	.text
	.globl findRoot

findRoot:

	subi	$sp, $sp, 24	# save the variable registers used by the calling function
	swc1	$f26, 20($sp)
	swc1	$f25, 16($sp)
	swc1	$f24, 12($sp)
	swc1	$f23, 08($sp)
	swc1	$f22, 04($sp)
	swc1	$f21, 00($sp)

	subi	$sp, $sp, 12	# save the argument registers used by the calling function
	swc1	$f14, 08($sp)
	swc1	$f13, 04($sp)
	swc1	$f12, 00($sp)

	subi	$sp, $sp, 4	# keep track of where this call is in the stack
	sw	$ra, 0($sp)

#
# actual function body begins here
#

# initialize main variables

	mov.s	$f20, $f12	# $f20 holds the lower bound, "a"
	mov.s	$f22, $f13	# $f22 holds the upper bound, "c"

	mov.s	$f23, $f14	# $f23 holds the system epsilon, "e"

	mtc1	$zero, $f4
	cvt.s.w	$f24, $f4	# $f24 holds floating point 0

	addi	$t0, $zero, 2
	mtc1	$t0, $f4
	cvt.s.w	$f25, $f4	# $f25 holds floating point 2

loopFindRoot:

# loop to find the root of the polynomial (block ends at return)

	add.s	$f4, $f20, $f22
	div.s	$f21, $f4, $f25	# $f21 holds the middle point, "b"

	mov.s	$f12, $f21
	jal	evaluate
	mov.s	$f26, $f0	# $f26 holds "p(b)"

# check if the root is at "b" (block ends at bNotARoot)

	c.eq.s	$f26, $f24
	bc1f	bNotARoot	# if "p(b) != 0", then move to the next branch

	j	return		# otherwise, if "p(b) == 0", return "b"

bNotARoot:

# check if "abs(a - c) < e" (block ends at notAtEpsilon)

	sub.s	$f4, $f22, $f20	# see if "c - a" is positive
	c.le.s	$f4, $f24
	bc1f	absValueFound	# if so, "abs(c - a) = c - a"

	sub.s	$f4, $f20, $f22	# otherwise, "abs(c - a) = a - c"

absValueFound:

	c.lt.s	$f4, $f23
	bc1f	notAtEpsilon	# if "abs(a - c) >= e", then move to the next branch

	j	return		# otherwise, if "abs(a - c) < e", return "b"

notAtEpsilon:

# check what the sign of "p(a) * p(b)" is (block ends at keepLooping)

	mov.s	$f12, $f20
	jal	evaluate	# $f0 holds "p(a)"

	mul.s	$f4, $f0, $f26	# $f4 holds "p(a) * p(b)"
	c.le.s	$f4, $f24
	bc1t	cGetsB

aGetsB:

	mov.s	$f20, $f21	# if "p(a) * p(b) > 0", set "a = b"
	j	keepLooping

cGetsB:

	mov.s	$f22, $f21	# otherwise, if "p(a) * p(b) <= 0", set "c = b"

keepLooping:

	j	loopFindRoot

return:

	mov.s	$f0, $f21

#
# actual function body ends here
#

	lw	$ra, 0($sp)	# reset the location in the call stack
	addi	$sp, $sp, 4

	lwc1	$f14, 08($sp)	# reset the argument registers used within the function
	lwc1	$f13, 04($sp)
	lwc1	$f12, 00($sp)
	addi	$sp, $sp, 12

	lwc1	$f26, 20($sp)	# reset the variable registers used within the function
	lwc1	$f25, 16($sp)
	lwc1	$f24, 12($sp)
	lwc1	$f23, 08($sp)
	lwc1	$f22, 04($sp)
	lwc1	$f21, 00($sp)
	addi	$sp, $sp, 24

	jr	$ra		# jump back to the calling program
