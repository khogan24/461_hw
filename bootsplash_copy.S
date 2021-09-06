.code16
.globl start
start:
movb $0x0e, %ah
movb hello, %al  # what is moved into %al ?
movb $0,    %bh
movb $7,    %bl
int $0x10

#move into vram segment
movw 0xa000, %ds
movw 0x0000, %di
movb $0xf,  %ds:(%di)

#now 0x0 should refer to 0xa000
#now open file, load into mem

stop:
jmp stop

hello:
.string "Hello World!"

.org 0x1fe
.word 0xAA55
