section .data
    prompt db "Enter a number: ", 0    ; Prompt message
    positive_msg db "POSITIVE", 0     ; Message for positive number
    negative_msg db "NEGATIVE", 0     ; Message for negative number
    zero_msg db "ZERO", 0             ; Message for zero

section .bss
    num resb 4                        ; Reserve space for input number

section .text
    global _start                     ; Entry point

_start:
    ; Prompt user for input
    mov eax, 4                        ; sys_write syscall
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, prompt                   ; Message address
    mov edx, 15                       ; Message length
    int 0x80                          ; Call kernel

    ; Read user input
    mov eax, 3                        ; sys_read syscall
    mov ebx, 0                        ; File descriptor (stdin)
    mov ecx, num                      ; Buffer to store input
    mov edx, 4                        ; Max input size
    int 0x80                          ; Call kernel

    ; Convert input from ASCII to integer
    mov eax, [num]                    ; Load input into EAX
    sub eax, 48                       ; Convert ASCII to integer

    ; Check if the number is zero
    cmp eax, 0                        ; Compare EAX to 0
    je print_zero                     ; Jump to print_zero if EAX == 0

    ; Check if the number is negative
    js print_negative                 ; Jump to print_negative if EAX < 0

    ; Otherwise, it's positive
    jmp print_positive                ; Unconditional jump to print_positive

print_positive:
    mov eax, 4                        ; sys_write syscall
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, positive_msg             ; Address of "POSITIVE"
    mov edx, 8                        ; Message length
    int 0x80                          ; Call kernel
    jmp exit                          ; Exit the program

print_negative:
    mov eax, 4                        ; sys_write syscall
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, negative_msg             ; Address of "NEGATIVE"
    mov edx, 8                        ; Message length
    int 0x80                          ; Call kernel
    jmp exit                          ; Exit the program

print_zero:
    mov eax, 4                        ; sys_write syscall
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, zero_msg                 ; Address of "ZERO"
    mov edx, 4                        ; Message length
    int 0x80                          ; Call kernel

exit:
    mov eax, 1                        ; sys_exit syscall
    xor ebx, ebx                      ; Exit code 0
    int 0x80                          ; Call kernel
