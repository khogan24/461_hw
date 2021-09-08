.code16
.globl start
start:
cmp $0x80, %dl
mov $0x1, %ah
jne stop
mov hello, %si

mov $hello, %si
mov $0x0e, %ah

print:
	lodsb #loads si to al, and increments si
	cmp $0, %al # arent null-terminated string great?
	je user_in
	int $0x10
	jmp print

user_in:
#read in
	mov $0x0, %si
	mov $0x00, %ah
	int $0x16

#switch to video mode
mov $0x00, %ah
mov $0x13, %al
int $0x10

read_disk:
#set DAP:

mov $data_access_packet, %ax # move address of dap to ds:di 0x00 + addr of dap
#mov %ax, %ds:(%di)
mov %ax, %si

#call read
#mov $0x0, %al
mov $0x42, %ah
mov $0x80, %dl #drive id
int $0x13 #read from disk

cmp $0x0, %ah
jne stop
r:
jmp r

mov 0x00, %cx
mov %ah, %al
stop:
	movw $0xA000 , %ax  # How many 0s should it have?
	add %cx, %ax
	movw %ax, %ds  # In i8086 you cannot move im directly to a *s register. (movw %0xA000, %ds)
	movw $0, %di   # The first pixel at the top-left corner of the screen
	movb %al, %ds:(%di) # After this instruction you can see the tiny white dot there. (maximize window to make it more visible)
	inc %cx
jmp stop

hello:
	.string "Welcome to xv6@UIC. Press any key to continue"

data_access_packet:
	 .byte 0x10,0x00
blkcnt:
	.word 0x07d # how many to read, 125 / 0x7d
db_add: # read to
	.word 0x0	  #offset
	.word 0xa000 # segment
d_lba : # where on disk we start reading
	.long 1
	.long 0

DAPS:
  .byte 0x10               # Size of Structure (16 bytes, always this for DAPS)
        .byte 0                  # Always 0
        .byte 0x7d                  # Number of Sectors to Read (1x512)
        .byte 0                  # Always 0 
addr:   .word 0xa000             # Target Location for Reading To (0x8000 = 0x0800:0x0000)  
segm:   .word 0x0000             # Page Table (0, Disabled)
lba0:   .long 1                  # Read from 2nd block (code I want to load)
    .long 0                  # Large LBAs, dunno what this does


.org 0x1fe
.word 0xAA55
