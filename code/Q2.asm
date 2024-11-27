section .data
    prompt db "Enter 5 integers (separated by spaces): ", 0
    output_msg db "Reversed array: ", 0
    array db 5, 0, 0, 0, 0, 0       ; Array to store the integers (first byte holds size)
    temp db 0                        ; Temporary variable for swapping

section .bss
    input resb 20                    ; Buffer for user input

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4                        ; sys_write syscall
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, prompt                   ; Address of the prompt message
    mov edx, 36                       ; Length of the prompt message
    int 0x80                          ; Call kernel

    ; Read user input
    mov eax, 3                        ; sys_read syscall
    mov ebx, 0                        ; File descriptor (stdin)
    mov ecx, input                    ; Buffer to store input
    mov edx, 20                       ; Max input size
    int 0x80                          ; Call kernel

    ; Convert and store input into the array
    mov esi, input                    ; Point to the start of the input buffer
    lea edi, [array + 1]              ; Point to the start of the array (after size byte)
    mov ecx, 5                        ; Number of integers to process

read_loop:
    lodsb                             ; Load a byte from the input buffer
    cmp al, ' '                       ; Check if it's a space
    je skip_space                     ; Skip spaces

    sub al, '0'                       ; Convert ASCII to integer
    stosb                             ; Store the integer in the array
    loop read_loop                    ; Decrement ECX and repeat until 5 numbers are read

skip_space:
    jmp read_loop

    ; Reverse the array in place
    mov esi, array + 1                ; Start of the array
    lea edi, [array + 5]              ; End of the array
    dec edi                           ; Move EDI to the last element
    mov ecx, 2                        ; Number of swaps needed (size / 2)

reverse_loop:
    mov al, [esi]                     ; Load the element at the start
    mov bl, [edi]                     ; Load the element at the end
    mov [esi], bl                     ; Swap: Store the end value at the start
    mov [edi], al                     ; Swap: Store the start value at the end
    inc esi                           ; Move to the next element
    dec edi                           ; Move to the previous element
    loop reverse_loop                 ; Repeat until all swaps are done

    ; Output the reversed array
    mov eax, 4                        ; sys_write syscall
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, output_msg               ; Address of the output message
    mov edx, 17                       ; Length of the output message
    int 0x80                          ; Call kernel

    mov ecx, 5                        ; Number of integers to print
    lea esi, [array + 1]              ; Start of the array

output_loop:
    mov al, [esi]                     ; Load the integer
    add al, '0'                       ; Convert integer to ASCII
    mov [temp], al                    ; Store in temporary location
    mov eax, 4                        ; sys_write syscall
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, temp                     ; Address of the temporary value
    mov edx, 1                        ; Length of one character
    int 0x80                          ; Call kernel

    inc esi                           ; Move to the next element
    loop output_loop                  ; Repeat for all elements

    ; Exit the program
    mov eax, 1                        ; sys_exit syscall
    xor ebx, ebx                      ; Exit code 0
    int 0x80                          ; Call kernel
