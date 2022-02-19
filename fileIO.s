.equ O_RONLY, 0
.equ O_WONLY, 1
.equ O_CREAT, 0100
.equ O_EXCL, 0200
.equ S_RW, 0666
.equ AT_FDCWD, -100
.equ BUFFERLEN, 250

	.macro  openFile fileName, flags
		mov x0, #AT_FDCWD
		ldr x1, =\fileName
		mov x2, #\flags
		mov x3, #S_RW
		mov x8, #56
		svc 0
		.endm

	.macro readFile fd, buffer, length
		mov x0, \fd
		ldr x1, =\buffer
		mov x2, #\length
		mov x8, #63
		svc 0
		.endm

	.macro writeFile, fd, buffer,  length
		mov x0, \fd
		ldr x1, =\buffer
		mov x2, \length
		mov x8, #64
		svc 0
		.endm

	.macro flushClose fd
		mov x0, \fd
		mov x8, #82
		svc 0
		mov x0, \fd
		mov x8, #57
		svc 0
		.endm
