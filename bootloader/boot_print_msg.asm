MSG:
   db 'Welcome to Flyke OS', 10, 13, 0   ;db = data byte 
   ;10, 13 are CPU instructions. Look at the ASCII table for values of 10,13 -> LS, CR
   ;One means newline, kinda like '\n' and the other is to go at the beginning of the line.
   
BIOS_PRINT_FUNC:
   lodsb                ;Loads bytes from SI register // getting MSG BYTE
   or al, al            ;zero=end of str
   jz DONE              ;jump to DONE, get out of the function (break)
   mov ah, 0x0E         ;int =10/ ah =0 x0e -> BIOS tele - type output
   mov bh, 0
   int 0x10             ;Display interrupt
   jmp BIOS_PRINT_FUNC  ;LOOP

DONE:
   ret                  ;Finish the co-routine branch and go back to the main