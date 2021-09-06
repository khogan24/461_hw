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
