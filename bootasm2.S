.code16
.globl start

start:
    jmp     real_start


real_start:

    movw    $stage_two_running_msg, %si  # Display our boot message
    call    cons_writeline
    mov     %dx, %si
    cmp     $0, (%si) 
    jnz     Floppy_write
    jmp     HDD_write

boot_device:
    .byte    0


HDD_write:
    movw 	$HDD_msg, %si
    call    cons_writeline

Floppy_write:
    movw 	$floppy_msg, %si
    call    cons_writeline

HDD_msg:
    .string "Boot from HDD"

floppy_msg:
    .string "Boot from Floppy"

stage_two_running_msg:
    .string "Stage Two is booting"

cons_write:
    movb    $0x0e, %ah           # 0x0e is the INT 10h BIOS call to output the value contained in AL to screen

cons_write_rpt:
    movb    (%si), %al          # Load the byte at the location contained in the SI register into AL   
    inc     %si                 # Add 1 to the value in SI
    cmp     $0, %al             # Compare the value in AL with 0
    jz      cons_write_done     # If it is zero, then we are done
    int     $0x10               # Output the character in AL to the screen
    jmp     cons_write_rpt      # and continue

cons_write_done:                # Something that is called will never return 
    ret                         # until a 'ret' instruction is encountered.  Labels do 
                                # not give a program any structure.  They just give a 
                                # memory location a name that we can use in our code. 

cons_write_crlf:
    movb    $0x0e, %ah          # Output CR
    movb    $0x0d, %al
    int     $0x10
    movb    $0x0a, %al          # Output LF
    int     $0x10
    ret

cons_writeline:
    call    cons_write
    call    cons_write_crlf
    ret  