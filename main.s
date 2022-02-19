.include "fileIO.s"
.include "crypto.s"

.equ BUFFERLEN, 250
.equ length, 13

.global _start

_start:
	openFile fileK, 0200
	adds x0, xzr, x0
	b.mi _errorKey

	openFile fileK, O_RONLY
	adds x17, xzr, x0

_counting:
	readFile x17, char, BUFFERLEN
	ldr x0, =char
	ldrb w13, [x0, x4]
	cmp w13, #11
	b.lt _cont
	add x4, x4, #1
	b _counting

_cont:
	mov x13, x4

	openFile fileI, 0200
	adds x0, xzr, x0
	b.pl _encoding

	openFile fileO, 0200
	adds x0, xzr, x0
	b.pl _decoding
	b _errorIn

_encoding:
	mov x1, #1
	mov w2, #length
	writeFile x1, encoding, x2
	openFile inFile, O_RONLY
	adds x11, xzr, x0
	openFile fileK, O_RONLY
	adds x10, xzr, x0
	openFile outFile, O_CREAT+O_WONLY
	adds x9, xzr, x0

_enc:
	readFile x10, values, BUFFERLEN

	readFile	X11, buffer, BUFFERLEN
	MOV		X7, X0
	MOV		X1, #0

	LDR		X0, =buffer
	STRB		W1, [X0, X7]
	LDR		X1, =outBuf

	ldr x14, =values
	
	encode w0, w13, w14

	writeFile	X9, outBuf, X7

	flushClose x11
	flushClose x10
	flushClose x9
	b _exit
	
_decoding:
	mov x1, #1
	mov w2, #length
	writeFile x1, decoding, x2
	openFile outFile, O_RONLY
	adds x11, xzr, x0
	openFile fileK, O_RONLY
	adds x10, xzr, x0
	openFile inFile, O_CREAT+O_WONLY
	adds x9, xzr, x0

_dec:
	readFile x10, values, BUFFERLEN

	readFile	X11, buffer, BUFFERLEN
	MOV		X7, X0
	MOV		X1, #0

	LDR		X0, =buffer
	STRB		W1, [X0, X7]
	LDR		X1, =outBuf
	
	ldr x14, =values

	decode w0, w13, w14

	writeFile	X9, outBuf, X7

	flushClose x11
	flushClose x10
	flushClose x9
	b _exit

_errorIn:
	mov x1, #1
	mov w2, #errorInSize
	writeFile x1, error_in, x2
	b _exit

_errorKey:
	mov x1, #1
	mov w2, #errorKeySize
	writeFile x1, error_key, x2
//	b _exit

_exit:	MOV     X0, #0
        MOV     X8, #93
        SVC     0

.data
encoding:	.asciz "Encoding...\n"
decoding:	.asciz "Decoding...\n"
error_in:		.asciz "First, create that file: 'unsafe.txt'\n"
errorInSize= 	.-error_in
error_key:		.asciz "First, create that file: 'key.txt'\n"
errorKeySize= 	.-error_key
fileK:		.asciz "key.txt"
fileI:		.asciz "unsafe.txt"
fileO:		.asciz "ciphered.txt"
inFile:  	.asciz "unsafe.txt"
outFile: 	.asciz "ciphered.txt"
values:		.fill BUFFERLEN + 1, 1, 0
char:		.fill BUFFERLEN + 1, 1, 0 
buffer:		.fill BUFFERLEN + 1, 1, 0
outBuf:		.fill BUFFERLEN + 1, 1, 0
