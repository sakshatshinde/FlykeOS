LOAD_DISK:
    pusha   ;pushed contents of the general puprose registers onto the stack
    push dx ;Push contents of dx onto the stack for later use

    mov ah, 0x02 ; ah <- int 0x13 function. 0x02 = BIOS READ FUNC
    mov al, dh   ; al <- number of sectors to read (0x01 to 0x80)
    
    mov ch, 0x00 ; ch <- cylinder (0x0 .. 0x3FF, upper 2 bits in 'cl'), In this case its Cylinder 0
    ; dl <- drive number. Our caller sets it as a parameter and gets it from BIOS
    ; (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
    mov cl, 0x02 ; cl <- sector (0x01 .. 0x11)
                 ; 0x01 is our boot sector, 0x02 is the second sector right after the boot sector

    mov dh, 0x00 ; dh <- head number (0x0 .. 0xF). Selecting head 0

    int 0x13      ; BIOS interrupt
    jc disk_error ; if error (stored in the carry bit)

    pop dx
    cmp al, dh    ; BIOS also sets 'al' to the # of sectors read. Compare it.
    jne sectors_error
    popa
    ret


disk_error:
    mov bx, DISK_ERROR_MSG
    call BIOS_PRINT_FUNC

sectors_error:
    mov bx, SECTORS_ERROR
    call BIOS_PRINT_FUNC

disk_loop:
    jmp $ ;loop to current address

DISK_ERROR_MSG: db "Disk read error", 10, 13, 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0