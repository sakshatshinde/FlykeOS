[BITS 16]
[ORG 0x7c00]

mov ax, 0x00   ; Make it zero
mov ds, ax     ; https://stackoverflow.com/questions/5364270/concept-of-mov-ax-cs-and-mov-ds-ax
cld            ; Clears the direction flag; affects no other flags or registers. Causes all subsequent string operations to increment the index registers, (E)SI and/or (E)DI, used during the operation.
 
mov si, MSG          ; SI is a CPU register
call BIOS_PRINT_FUNC ; calling BIOS_PRINT FUNC
 
mov bp, 0x8000       ; set the stack safely away from us
mov sp, bp

mov bx, 0x9000    ; es:bx = 0x0000:0x9000 = 0x09000
mov dh, 2         ; read 2 sectors
                  ; the bios sets 'dl' for our boot disk number
                  ; if you have trouble, use the '-fda' flag: 'qemu -fda file.bin'

call LOAD_DISK             ; Loading in the disk // boot_disk.asm

mov dx, [0x9000]           ; retrieve the first loaded word, 0x0002 //ZeroTwo
call BIOS_PRINT_HEX_FUNC
;call BIOS_PRINT_FUNC      ; uncomment for looking at the ASCII

mov dx, [0x9000 + 512]     ; first word from second loaded sector, 0x0016 //Hiro
;call BIOS_PRINT_FUNC      ; uncomment for looking at the ASCII
call BIOS_PRINT_HEX_FUNC

INFINITE_LOOP:             ;Executes at the end
   ;call BIOS_PRINT_FUNC   ****UNCOMMENT FOR FUN**** //Prints garbage 
   jmp INFINITE_LOOP

jmp INFINITE_LOOP

 
%include "boot_print_msg.asm"
%include "boot_disk.asm"
%include "boot_print.asm"
%include "boot_print_hex.asm"

 
   times 510-($-$$) db 0      ; Padding the magic number with 0's
   db 0x55                    ; Magic
   db 0xAA                    ; Number

   times 256 dw 0x0002        ; sector 2 = 512 bytes // ZeroTwo reference
   times 256 dw 0x0016        ; sector 3 = 512 bytes // Code 016 reference 

   ; We know that BIOS will load only the first 512 - byte sector from the disk ,
   ; so if we purposely add a few more sectors to our code by repeating some
   ; familiar numbers , we can prove to ourselfs that we actually loaded those
   ; additional two sectors from the disk we booted from.