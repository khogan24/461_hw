.code16
.globl start
start:
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
#write to screen
	mov $0x0e, %ah
	int $0x10

#switch to video mode
mov $0x00, %ah
mov $0x13, %al
int $0x10

mov $0x42, %ah #func arg for read
mov $0x42, %dl # HDD 1
int $0x13 #read from disk

movw $0x04, %ds:(%si)

hello:
.string "Welcome to xv6@UIC. Press any key to continue"

.org 0x1fe
.word 0xAA55


/*
.code16
.globl start
start:
#save drive number
mov %dl, %ax
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
#write user in text to screen
	mov $0x0e, %ah
	int $0x10

#set video mode
mov $0x00, %ah
mov $0x13, %al
int $0x10

read_disk:
mov $0x42, %ah
mov $0x0, %dl
mov %2, %cl #start read at sector ax image starts at 513 bit	
mov %0x05, %al #read 5 sectors
# now set the address of where data is read into
# needs to be in 0xa000, for video ram
mov $0xa000, %bx
mov %bx, %es
mov $0x1234, %bx
int $0x13

#set video mode read to vram
mov $0, %di
movb %al, %ds:(%di)
int $0x10

cmp $0x05, %al
jne read_err # check carry flag and jump, used primarily for debugging

stop:
jmp stop

read_err:
movw $0xA000, %ax  # How many 0s should it have?
movw %ax, %ds  # In i8086 you cannot move imm directly to a *s register. (movw %0xA000, %ds)
movb $0xf, %al # A white pixel
movw $0, %di   # The first pixel at the top-left corner of the screen
movb %al, %ds:(%di) # After this instruction you can see the tiny white dot there. (maximize window to make it more visible)


hello:
.string "Welcome to xv6@UIC. Press any key to continue"

.org 0x1fe
.word 0xAA55
*/
