section .data
    prompt db "Enter a number (0-12): ", 0       ; Prompt message
    result_msg db "Factorial: ", 0              ; Result message
    newline db 10, 0                            ; Newline character

section .bss
    num resb 1                                  ; Reserve space for user input
    result resb 4                               ; Reserve space for the result

section .text
    global _start

_start:
    ; Prompt the user
    mov eax, 4                                  ; sys_write syscall
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, prompt                             ; Address of prompt
    mov edx, 24                                 ; Length of prompt
    int 0x80                                    ; Call kernel

    ; Read user input
    mov eax, 3                                  ; sys_read syscall
    mov ebx, 0                                  ; File descriptor (stdin)
    mov ecx, num                                ; Buffer for input
    mov edx, 1                                  ; Max input size
    int 0x80                                    ; Call kernel

    ; Convert ASCII input to integer
    movzx eax, byte [num]                       ; Load user input
    sub eax, '0'                                ; Convert ASCII to integer
    mov ebx, eax                                ; Store input in EBX for later use

    ; Call factorial subroutine
    push eax                                    ; Push the input onto the stack
    call factorial                              ; Call the factorial subroutine
    add esp, 4                                  ; Clean up the stack

    ; Output result
    mov [result], eax                           ; Store the result in memory
    mov eax, 4                                  ; sys_write syscall
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, result_msg                         ; Address of result message
    mov edx, 10                                 ; Length of result message
    int 0x80                                    ; Call kernel

    ; Convert result to ASCII and output
    mov eax, [result]                           ; Load the factorial result
    call print_number                           ; Print the result

    ; Add newline
    mov eax, 4                                  ; sys_write syscall
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, newline                            ; Address of newline character
    mov edx, 1                                  ; Length of newline
    int 0x80                                    ; Call kernel

    ; Exit program
    mov eax, 1                                  ; sys_exit syscall
    xor ebx, ebx                                ; Exit code 0
    int 0x80                                    ; Call kernel

; Factorial Subroutine
factorial:
    ; Input: Number in EAX
    ; Output: Factorial in EAX

    push ebp                                    ; Save base pointer
    mov ebp, esp                                ; Set up stack frame
    push ebx                                    ; Save EBX (used in calculation)
    push ecx                                    ; Save ECX (used in loop)

    cmp eax, 1                                  ; Base case: if n <= 1
    jle .base_case                              ; Jump if n <= 1

    mov ebx, eax                                ; Store n in EBX
    dec eax                                     ; n - 1
    push eax                                    ; Push n - 1 onto the stack
    call factorial                              ; Recursive call
    add esp, 4                                  ; Clean up the stack

    mul ebx                                     ; Multiply result with n
    jmp .end                                    ; Skip base case handling

.base_case:
    mov eax, 1                                  ; Factorial of 0 or 1 is 1

.end:
    pop ecx                                     ; Restore ECX
    pop ebx                                     ; Restore EBX
    mov esp, ebp                                ; Restore stack pointer
    pop ebp                                     ; Restore base pointer
    ret                                         ; Return to caller

; Subroutine to Print Numbers
print_number:
    ; Input: EAX contains the number to print
    ; Uses: ECX and EDX for digit extraction

    push eax                                    ; Save EAX
    push ebx                                    ; Save EBX
    push ecx                                    ; Save ECX
    push edx                                    ; Save EDX

    mov ecx, 10                                 ; Divisor for decimal system
    xor ebx, ebx                                ; Clear EBX (used for digit storage)
    xor edx, edx                                ; Clear EDX (remainder)

.next_digit:
    div ecx                                     ; EAX / 10, remainder in EDX
    push edx                                    ; Save remainder (digit)
    inc ebx                                     ; Count digit
    test eax, eax                               ; Check if EAX is 0
    jnz .next_digit                             ; Continue if not 0

.print_loop:
    pop edx                                     ; Get the next digit
    add dl, '0'                                 ; Convert to ASCII
    mov [temp], dl                              ; Store the digit
    mov eax, 4                                  ; sys_write syscall
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, temp                               ; Address of digit
    mov edx, 1                                  ; Length of digit
    int 0x80                                    ; Call kernel
    dec ebx                                     ; Decrement digit count
    jnz .print_loop                             ; Continue if more digits

    ; Restore registers
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret                                         ; Return to caller
