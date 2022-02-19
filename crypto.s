.macro encode chr, max, dec
	mov w5, \chr
	mov w12, \max
	sub x12, x12, #2
	mov w16, \dec
	
	mov x4, x1
	mov x6, x16
1:
	ldrb w5, [x0], #1
	cmp w5, #11
	b.lt 3f
	
	ldrb w3, [x16, x15]
	sub w3, w3,  #31
	
	add w5, w5, w3
	cmp w5, #126	// Tilda
	b.gt 2f
	b 3f

2:
	sub w5, w5, w3
	add w3, w3, #32	// Space
	neg w5, w5
	add w5, w5, #127
	sub w5, w3, w5
	mov x3, x6

3:
	strb w5, [x1], #1
	cmp x15, x12
	b.le 4f
	mov x15,  #0
	b 1b
	
4:
	add x15, x15, #1
	cmp w5, #0
	b.ne 1b
	sub  x0, x1, x4

.endm

.macro decode chr, max, dec
	mov w5, \chr
	mov w12, \max
	sub x12, x12, #2
	mov w16, \dec

	mov x4, x1
	mov x6, x16

1:
	ldrb w5, [x0], #1
	cmp w5, #11
	b.lt 3f
	
	ldrb w3, [x16, x15]
	sub w3, w3, #31
	
	sub w5, w5, w3
	cmp w5, #32
	b.lt 2f
	b 3f

2:
	add w5, w5, #95	

3:
	strb w5, [x1], #1
	cmp x15, x12
	b.le 4f
	mov x15, #0
	b 1b

4:
	add x15, x15, #1
	cmp w5, #0
	b.ne 1b
	sub  x0, x1, x4

.endm
