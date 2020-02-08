[BITS 16]
[ORG 0x7c00]

   mov ax, 0x00  ;make it zero
   mov ds, ax  ;https://stackoverflow.com/questions/5364270/concept-of-mov-ax-cs-and-mov-ds-ax
   cld   ;Clears the direction flag; affects no other flags or registers. Causes all subsequent string operations to increment the index registers, (E)SI and/or (E)DI, used during the operation.
 
   mov si, MSG          ;SI is a CPU register
   call BIOS_PRINT_FUNC ;calling BIOS_PRINT FUNC
 
INFINITE_LOOP: ;Executes at the end
   jmp INFINITE_LOOP
 
MSG:
   db 'Welcome to Flyke OS', 0   ;db = data byte
 
BIOS_PRINT_FUNC:
   lodsb                ;Loads bytes from SI register // getting MSG BYTE
   or al, al            ;zero=end of str
   jz DONE              ;jump to DONE, get out of the function (break)
   mov ah, 0x0E
   mov bh, 0
   int 0x10             ;Display interrupt
   jmp BIOS_PRINT_FUNC  ;LOOP

DONE:
   ret
 
   times 510-($-$$) db 0
   db 0x55
   db 0xAA