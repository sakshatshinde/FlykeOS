[BITS 16]
[ORG 0x7c00]

mov ax, 0x00  ;make it zero
mov ds, ax  ;https://stackoverflow.com/questions/5364270/concept-of-mov-ax-cs-and-mov-ds-ax
cld   ;Clears the direction flag; affects no other flags or registers. Causes all subsequent string operations to increment the index registers, (E)SI and/or (E)DI, used during the operation.
 
mov si, MSG          ;SI is a CPU register
call BIOS_PRINT_FUNC ;calling BIOS_PRINT FUNC
 
INFINITE_LOOP: ;Executes at the end
   ;call BIOS_PRINT_FUNC  ****UNCOMMENT FOR FUN**** //Prints garbage 
   jmp INFINITE_LOOP
 

 
%include "boot_print_msg.asm"
 
   times 510-($-$$) db 0      ; Padding the magic number with 0's
   db 0x55                    ; Magic
   db 0xAA                    ; Number