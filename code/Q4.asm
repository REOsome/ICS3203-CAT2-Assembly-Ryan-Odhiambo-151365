section .data
    sensor_value db 0                  ; Simulated sensor value (e.g., water level)
    motor_status db 0                  ; Motor status: 0 = OFF, 1 = ON
    alarm_status db 0                  ; Alarm status: 0 = OFF, 1 = ON
    prompt db "Enter sensor value (0-100): ", 0
    motor_on_msg db "Motor is ON", 10, 0
    motor_off_msg db "Motor is OFF", 10, 0
    alarm_triggered_msg db "ALARM is TRIGGERED!", 10, 0
    alarm_off_msg db "ALARM is OFF", 10, 0

section .bss
    input_buffer resb 4                ; Reserve space for user input

section .text
    global _start

_start:
    ; Prompt the user to enter the sensor value
    mov eax, 4                         ; sys_write syscall
    mov ebx, 1                         ; File descriptor (stdout)
    mov ecx, prompt                    ; Address of the prompt message
    mov edx, 30                        ; Length of the prompt message
    int 0x80                           ; Call kernel

    ; Read user input
    mov eax, 3                         ; sys_read syscall
    mov ebx, 0                         ; File descriptor (stdin)
    mov ecx, input_buffer              ; Address of the input buffer
    mov edx, 4                         ; Max input size
    int 0x80                           ; Call kernel

    ; Convert ASCII input to integer
    movzx eax, byte [input_buffer]     ; Load first character from the input buffer
    sub eax, '0'                       ; Convert ASCII to integer
    mov [sensor_value], al             ; Store the sensor value in memory

    ; Read sensor value and determine action
    mov al, [sensor_value]             ; Load sensor value into AL
    cmp al, 75                         ; Compare sensor value to high threshold (75)
    ja high_water_level                ; Jump if sensor value > 75 (too high)

    cmp al, 25                         ; Compare sensor value to moderate threshold (25)
    ja moderate_water_level            ; Jump if 25 < sensor value <= 75

    ; Low water level: Turn the motor ON
    mov byte [motor_status], 1         ; Set motor status to ON
    mov byte [alarm_status], 0         ; Set alarm status to OFF
    jmp output_status                  ; Jump to output status

moderate_water_level:
    ; Moderate water level: Turn the motor OFF
    mov byte [motor_status], 0         ; Set motor status to OFF
    mov byte [alarm_status], 0         ; Set alarm status to OFF
    jmp output_status                  ; Jump to output status

high_water_level:
    ; High water level: Trigger the alarm
    mov byte [motor_status], 0         ; Set motor status to OFF
    mov byte [alarm_status], 1         ; Set alarm status to ON
    jmp output_status                  ; Jump to output status

output_status:
    ; Output motor status
    mov al, [motor_status]             ; Load motor status
    cmp al, 1                          ; Check if motor is ON
    je motor_is_on                     ; Jump if motor is ON
    mov eax, 4                         ; sys_write syscall
    mov ebx, 1                         ; File descriptor (stdout)
    mov ecx, motor_off_msg             ; Address of "Motor is OFF" message
    mov edx, 13                        ; Length of message
    int 0x80                           ; Call kernel
    jmp check_alarm_status             ; Jump to check alarm status

motor_is_on:
    mov eax, 4                         ; sys_write syscall
    mov ebx, 1                         ; File descriptor (stdout)
    mov ecx, motor_on_msg              ; Address of "Motor is ON" message
    mov edx, 12                        ; Length of message
    int 0x80                           ; Call kernel

check_alarm_status:
    ; Output alarm status
    mov al, [alarm_status]             ; Load alarm status
    cmp al, 1                          ; Check if alarm is ON
    je alarm_is_triggered              ; Jump if alarm is ON
    mov eax, 4                         ; sys_write syscall
    mov ebx, 1                         ; File descriptor (stdout)
    mov ecx, alarm_off_msg             ; Address of "Alarm is OFF" message
    mov edx, 13                        ; Length of message
    int 0x80                           ; Call kernel
    jmp end_program                    ; Jump to end the program

alarm_is_triggered:
    mov eax, 4                         ; sys_write syscall
    mov ebx, 1                         ; File descriptor (stdout)
    mov ecx, alarm_triggered_msg       ; Address of "Alarm is TRIGGERED!" message
    mov edx, 22                        ; Length of message
    int 0x80                           ; Call kernel

end_program:
    ; Exit the program
    mov eax, 1                         ; sys_exit syscall
    xor ebx, ebx                       ; Exit code 0
    int 0x80                           ; Call kernel
