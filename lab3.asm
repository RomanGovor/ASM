name 'lab3'

.model small
.stack 100h  
.code    

jmp start

Output_string_proc proc                ;��������� ������ ������
    mov ah, 09h
    int 21h
    ret
Output_string_proc endp
                        
                        
                        
Input_array_length_proc proc           ;��������� ����� ����������� �������
    mov cx, 1 
    
Input_array_length_loop:
    mov dx, offset Input_lenght_str                
    call Output_string_proc
                 
    push cx
    call Input_element_proc            ;����� ��������� ����� ��������
    pop cx
    
    cmp size_,0
    jle Length_error                   ;���� ������ 0  
    
    cmp size_,30 
    jg Length_error                    ;���� ������ 30
    
    jmp End_input_length

loop Input_array_length_loop 
                                       ;���� �� ���������� ��������
Length_error:
    ;xor ax,ax
    inc cx

    jmp Input_array_length_loop 
    
End_input_length:

ret
endp
          
       
Bubble_proc proc near        ;��������� ����������
    New_array equ di           
    cmp cx, 1
    jle End_of_sort          ;���� � ������� 1 �������
    mov dx, si               
    dec cx                   
    
First_cicle:
    push cx                  
    mov bx, size_
    add bx, dx               
    dec bx                   ;�������� ������ + size_ - 1
    
    sub bx, si
    mov cx, bx
    mov di, dx               ;��������� ������� �� ������ ����� ������
    
Second_cicle:
    mov ax, New_array[di+2] 
    cmp New_array[di], ax  
    jle Return_to_loop       ;���� ������ �������� ������� ������ �������, �� �������
    
Swap:                        ;������
    mov bx, New_array[di]
    mov ax, New_array[di+2]
    mov New_array[di], ax
    mov New_array[di+2], bx 
   
Return_to_loop:    
    add di,2                 ;��� �� 2 ����� ������� ����������� �����
loop Second_cicle 
    inc si
    pop cx
loop First_cicle   
    
End_of_sort:
    ret                      ;������� �� ���������
endp Bubble_proc

       
       
       
       
Output_array_proc proc near
    push bp                  ;��������� ������� ��������� �����
    mov bp, sp 
    
Print_array:
      mov ax, ds:[di]        ;�������� �������� � �������
      mov bx, ds:[di]
      cmp bx, 0              ;���� ����, �� ������ 
      jne Turn_over  
      
      mov dl, bl              
      mov ah, 2
      add dl, 30h            ;����������� 48 � ������ � ax
      int 21h   
      
      mov dl, 020h           ;���������� �������
      add di,2
      int 21h 
       
      loop Print_array
      jmp end_print_array  
     
add_minus:
      push ax                 ;��������� � ���� �������� �� ax
       
      mov ah, 2
      mov dl, '-'             ;��������� � �� ������
      int 21h     
      
      pop ax                  ;������� �� �� �����
      neg ax
      jmp end_add_minus  
      
Turn_over:
      neg ax                  ;��������� ����� ����� �� �������������
      jns add_minus           ;���� ����������� ����(�������������), �� ������� �������� �����
      
end_add_minus:       
      neg ax    
      
sign2:       
      neg bx                  ;��������� ����� bx �� �������������
      js sign2                ;���� �����
      push cx                 ;��������� � ���� ������������ ������� �������
      mov si, 0               ;������� �������� ���� � �����
      xor dx, dx              ;��������� dx
      push bx                 
      mov bx, 10              ;�������� �������
      mov cx, 5               ;������������ ���������� ��������
      
Size_of_number:               ;��������� ������� ������ �����
      cmp ax, 10              ;���� �������� ������ 10
      jl Increment_counter_of_actual_size
      div bx                  ;������� �������� ������������ �� bx c ������� � ��������
      xor dx, dx
      inc si                  ;������������� si
loop Size_of_number           ;���� cx
      
Increment_counter_of_actual_size: 
    pop bx                    ;���������� �������� �������� ����
    inc si   
       
Getting_number:     
      mov ax, bx 
      mov cx, si              ;����������� � ������� �������� ���-�� �������� �����
      dec cx 
      push bx
      mov bx, 10              ;����������� �������� �������
      
Div_on_ten:                   ;������� ������ �� 10
     cmp cx, 0                ;���� �������� �������� ������� 0
     je End_of_div
     div bx                   ;������� ������������ �� bx � ������� � ��������
     xor dx, dx               ;��������� �������
     loop Div_on_ten  
     
End_of_div:                   ;���������� ������� �������
     push ax                  ;������� � ���� ��������
     mov dl, al
     mov ah, 2
     add dl, 30h              ;���������� � �������� 48
     int 21h  
     
     pop ax
     mov cx, si               ;�������� ������ ��������� ����� �����
     dec cx   
     
Inverse_multi:
    cmp cx, 0                 
    je Completed_inverse_multi
    mul bx
loop Inverse_multi 
     
Completed_inverse_multi: 

   pop bx
   sub bx, ax   
   dec si                      ;���������� ������� ����� �� 1
   cmp si, 0                   ;���� ������� ����� �����������
   jne Getting_number          ;�������� ���������� ������� �����
    
   pop cx                      ;��������� �� ����� ������� �������
   add di,2                    ;��� ������� 2 ����� 
   mov ah, 2
   mov dl, 020h                ;����������� ������� � �����������
   int 21h  
      
loop Print_array  
   
end_print_array:
    mov sp, bp 
    pop bp
    ret  
Output_array_proc endp         ;���������� ������      



                               ;/*----------------------------INPUT LENGTH--------------------------------------------*/ 

Input_element_proc proc near
    push bp                    ;��������� ������� ��������� �����
    mov bp, sp 

Entering_number1: 
    xor bx, bx                  ;�������� �������� �������� ���� 
    
    mov ah, 0Ah     
    mov offset buffer1, buf_size_length ;�������� ��� ����� ������������ ������
    mov dx, offset buffer1
    int 21h                     ;������ ������
    
    mov dx, 0   
    mov si, 2 
    cmp buffer1[si], 0Dh         ;�������� �� ����� ������
    je Uncorrect_value1
     
    cmp buffer1[si], '-'         ;���� ���������� �����
    je Uncorrect_value1
      
    cmp buffer1[si], '0'         ;���� ����
    je only_zero_check1
     
    jmp Validating_value1  
    
only_zero_check1:                
    cmp buffer1[si+1],0          ;���� �� ����� ������
    je Uncorrect_value1
    
    cmp buffer1[si+1], 0Dh       ;���� �� ����� ������
    jne Next_byte1
    je Uncorrect_value1  
     
Validating_value1:               ;�������� ����������� �����
    cmp buffer1[si], 0Dh         ;���� ����� �����
    je Number_processing1
    cmp buffer1[si], '9'         ;���� ������� ������� ������ 9
    jg Uncorrect_value1
    cmp buffer1[si], '0'         ;���� ������� ������� ������ 0
    jl Uncorrect_value1
    inc dx                       ;�������������� ����� ������ �����
       
Next_byte1:                      ;��������� ����
    inc si
    jmp Validating_value1   
    
Number_processing1:              ;��������� �����
     cmp dx, 2
     jl Small_number1            
     mov si, 2 
     
If_positivie_number1:            ;���� ������������� �����
     cmp buffer1[si], '3'        ;������������ ��������� ������
     jg Uncorrect_value1
     jl Small_number1
     inc si
     
     cmp buffer1[si], '0'
     jg Uncorrect_value1
     jle Small_number1 
         
Small_number1: 
    mov cx, dx   
    dec dx
    mov si, 2 
    
Check_on_zero1:    
    cmp buffer1[si], '0'
    jne Convertation_on_number1  ;���� �� �������
    inc si 
                           ;/*----------------convertation---------------*/
Convertation_on_number1:         ;�����������
    cmp buffer1[si], 0Dh         ;���� ��������� ����� �������
    je �onversion_completion1
    xor ax, ax                   ;��������� ��������
    mov al, buffer1[si]          ;������ �������
    sub ax, 30h                  ;�������� ���� ������ 0
   
    push cx
    mov cx, dx  
    push dx   
    push bx                     ;������� � ���� ����������� �������� �����
    mov bx, 10  
    
Mul_on_ten1:                     ;��������� ���������� �������� �����
    cmp cx, 0
    je End_of_mul1
    mul bx                      ;��������� AX �� BX � ������� � ��������
    dec cx                      ;���������� ���������� ��������
    jmp Mul_on_ten1 
     
End_of_mul1:                     ;���������� ��������� ���-�� ��������
    pop bx                      ;��������� ��������
    pop dx                      ;
    dec dx                      ;���������� ��������
    pop cx
    inc si                      ;�������������� �������
    add bx, ax                  ;���������� ���������� ����������� � ���������� bx
    jmp Convertation_on_number1 
                                 ;/*---------------------------------------*/
�onversion_completion1: 
    mov si, 2
    
Positive_value1:                 ;���� ������������� ��������
    pop cx                       ;��������� ����������� �������
    mov size_,bx
    
    jmp End_input_element
    
Uncorrect_value1:   
    mov dx, offset Error_lenght_str               
    call Output_string_proc
        
    mov ax, '$' 
    mov dx, offset buffer1       ;��������� ����� ������
    mov cx, 9               
               
End_input_element:
    mov sp, bp 
    pop bp
    ret  
Input_element_proc endp   
 
       
       
       
 
start: 
    mov ax, @data
    mov ds, ax   
      
    call Input_array_length_proc  
      
    mov dx, offset Enter_array_str                
    call Output_string_proc 
    
    mov cx, size_                ;�������� � ������ �������� ������ �������
    mov di, 0  
    
Entering_number: 
    xor bx, bx                  ;�������� �������� �������� ���� 
    
    mov ah, 0Ah     
    mov offset buffer, buf_size ;�������� ��� ����� ������������ ������
    mov dx, offset buffer
    int 21h                     ;������ ������
    
    push cx                     ;������� � ���� ������ �������
    mov dx, 0   
    mov si, 2 
    cmp buffer[si], 0Dh          ;�������� �� ����� ������
    je Uncorrect_value 
    cmp buffer[si], '-'         ;���� ���������� �����
    je If_minus  
    cmp buffer[si], '0'         ;���� ������ ��� �����
    je only_zero_check 
    jmp Validating_value  
    
If_minus:                       ;���� ���������� �����
    inc si
    cmp buffer[si], 0Dh
    je Uncorrect_value
    cmp buffer[si], '0'         
    je Next_byte 
    jmp Validating_value  
    
only_zero_check:                ;���� ���������� ���� ��� �����
    cmp buffer[si+1], 0Dh        ;���� �� ����� ������
    jne Next_byte 
    xor bx, bx                  ;��������� ��������
    mov bl, buffer[si] 
    sub bl, 30h 
    mov array[di], bx   
    
    mov ah, 2
    mov dl, bl                  ;������ ������� � dl
    int 21h
    
    add di, 2                   ;��� � 2 �����
    loop Entering_number  
     
Validating_value:               ;�������� ����������� �����
    cmp buffer[si], 0dh
    je Number_processing
    cmp buffer[si], '9'         ;���� ������� ������� ������ 9
    jg Uncorrect_value
    cmp buffer[si], '0'         ;���� ������� ������� ������ 0
    jl Uncorrect_value
    inc dx                      ;�������������� ����� ������ �����
       
Next_byte:                      ;��������� ����
    inc si
    jmp Validating_value   
    
Number_processing:              ;��������� �����
     cmp dx, 5
     jl Small_number            ;���� ������ 5 ��������
     mov si, 2 
     cmp buffer[si], '-'        ;���� ����� ������ �� �����
     jne If_positivie_number    
     inc si                     ;���� ������������� ����� 
     
If_positivie_number:            ;���� ������������� �����
     cmp buffer[si], '3'        ;������������ ��������� ������
     jg Uncorrect_value
     jl Small_number
     inc si
     
     cmp buffer[si], '2'
     jg Uncorrect_value
     jl Small_number
     inc si  
     
     cmp buffer[si], '7'
     jg Uncorrect_value
     jl Small_number
     inc si   
     
     cmp buffer[si],'6'
     jg Uncorrect_value
     jl Small_number
     inc si  
     
     cmp buffer[si], '7'
     jg Uncorrect_value
     jle Small_number 
         
Small_number: 
    mov cx, dx                  ;�������� ���-�� ���� �����
    dec dx
    mov si, 2 
    
    cmp buffer[si], '-'         ;���������� � �������
    jne Check_on_zero           ;���� �� �����
    inc si
   
    cmp buffer[si], '0'                    
    jne Convertation_on_number  ;���� �� ����
    inc si
   
    jmp Convertation_on_number   
    
Check_on_zero:    
    cmp buffer[si], '0'
    jne Convertation_on_number  ;���� �� �������
    inc si 
                           ;/*----------------convertation---------------*/
Convertation_on_number:         ;�����������
    cmp buffer[si], 0Dh         ;���� ��������� ����� �������
    je �onversion_completion
    xor ax, ax                  ;��������� ��������
    mov al, buffer[si]          ;������ �������
    sub ax, 30h                 ;�������� ���� ������ 0
   
    push cx
    mov cx, dx  
    push dx   
    push bx                     ;������� � ���� ����������� �������� �����
    mov bx, 10  
    
Mul_on_ten:                     ;��������� ���������� �������� �����
    cmp cx, 0
    je End_of_mul
    mul bx                      ;��������� AX �� BX � ������� � ��������
    dec cx                      ;���������� ���������� ��������
    jmp Mul_on_ten 
     
End_of_mul:                     ;���������� ��������� ���-�� ��������
    pop bx                      ;��������� ��������
    pop dx                      
    dec dx                      ;���������� ��������
    pop cx
    inc si                      ;�������������� �������
    add bx, ax                  ;���������� ���������� ����������� � ���������� bx
    jmp Convertation_on_number 
                                 ;/*---------------------------------------*/
�onversion_completion: 
    mov si, 2
    cmp buffer[si], '-'         ;���� ������������� �����
    jne Positive_value 
    neg bx                      ;������ ���� �� �������������
    
Positive_value:                 ;���� ������������� ��������
    pop cx                      ;��������� ����������� �������
    mov array[di], bx           ;���������� � ������ ���������� �����
    add di,2                    ;��� 2 �����
    mov ah, 2
    mov dl, 020h                ;������
    int 21h
    
    loop Entering_number        ;���� ���� �� ���� � �������� cx
    jmp end_insert
    
Uncorrect_value:   
    mov dx, offset Incorrect_value_str               
    call Output_string_proc
        
    mov ax, '$' 
    mov dx, offset buffer       ;��������� ����� ������
    mov cx, 9 
    
    pop cx
    jmp Entering_number 
                                ;/*---------------------------------------*/
end_insert:
    lea si, array               ;��������� �������� �������
    lea di, array
    mov cx, size_  
    call Bubble_proc 

    mov dx, offset Sorted_array_str                
    call Output_string_proc  

    lea di, array               ;���������� ��������������� ������
    mov cx, size_                ;��������� ������ �������

    call Output_array_proc

Serching_median:
    mov dx, offset Median_str                
    call Output_string_proc
    
    mov ax, size_               ;�������� ������� �������
    xor dx, dx                  ;������� �������� ������ �������
    mov bx, 2                   ;��������
    div bx                      ;����� �� �� � ������� � �������
                                ;������� ������������ � dx
    cmp dx, 1
                   
    je Odd_value                ;���� ���� �������
      
    mul bx                      ;��������� ������� ������� ���������
    mov di, ax     
    mov ax, array[di]           ;������ � ������� �������� � �������,� �� ������������ ������� �����
    mov bx, array[di-2]
    cmp ax, bx 
    
    je Even_value               ;���� �������� �����
    xor dx, dx
   
    cmp ax, 0                   ;��������� ������� ����� � �������
    jl Check_left               ;���� ������ ������ ����
    cmp bx, 0               
    jle Add_numbers             ;���� ����� ����� ������ ��� ����� ����
    jmp Sub_positive_numbers    ;���� ��� ������ ����
                 
Check_left:                     ;
    cmp bx, 0                   ;���� ������ ��� �����
    jge Add_numbers                    
    jmp Sub_positive_numbers                
                                    
Add_numbers:                    ;�����������                                       
     neg bx                     ;�� bx �������������   
     cmp ax, bx                     
     jl print_minus             ;���� ���������� �������� bx ������ ax
                      
back:                           ;���� ax ������   
     neg bx                     ;������� � ��� ���
     add ax, bx                 
         
Signed_:                                  
     neg ax                          
     js Signed_                 ;�������� �� ����     
     mov bx, 2                      
     idiv bx                    ;������� �� ������    
     push dx                        
     jmp Even_value                
                                    
Sub_positive_numbers:           ;���������     
    cmp ax, bx                      
                                    
ax_bx:                              
    sub ax, bx                  ;��������� �� �������� ����� �������    
    push bx                         
    mov bx, 2                       
    idiv bx                     ;������� �� ������     
    pop bx                          
    add ax, bx                  ;�������� ������� ���������� ����� � bx    
    cmp dx, 1                       
    jne not_add_1               ;���� ������    

add_1:                           
    cmp ax, 0                       
    jg not_add_1                ;���� ������ ����, �� �� ������������ �������    
    inc ax                          

not_add_1:                         
    push dx                         
    jmp Even_value               

print_minus:                        
    push ax                         
    push dx                         
    mov ah, 2                   ;���������� ������    
    mov dl, '-'                     
    int 21h                         
    pop dx                          
    pop ax                          
jmp back                            
;jmp Even_value                  
    
Odd_value:                      ;���� ������ ������� �������� �����
    mov dx, 0  
    push dx
    mov med_num, ax             
    mul  bx                     ;��������� ������� �������� ��������
    mov di, ax     
    mov ax, array[di]           ;������ �������� �������� � �������
     
Even_value:                     ;���� ������ ������� ������ �����
     mov bx, ax                 ;��������� �������� �������
     cmp bx, 0                  ;����  �� ����
     jne Check_on_positive 

Zero_result:   
     mov dl, bl
     mov ah, 2
     add dl, 30h                ;������ ���� �� dl
     int 21h 
    
     jmp Print_remainder        
      
add_minus1:                     ;���� ������� ������������� �����
      push ax   
      mov ah, 2
      mov dl, '-'               ;���������� ������
      int 21h 
      
      pop ax 
      jmp sign21  
      
Check_on_positive:  
      neg ax                     ;��������� ����� SF
      jns add_minus1             ;���� ���� ������
      neg ax
       
                                  ;/*---------------------------------------*/
sign21:       
      neg bx
      js sign21
      mov si, 0       
      xor dx, dx                 ;��������� �������
      push bx 
      mov bx, 10                 ;��������
      mov cx, 5                  ;�������� ������������� ���-�� �������� �����
      
size1:                           ;��������� ���-�� �������� �����
      cmp ax, 10
      jl Increment_counter_of_actual_size1
      div bx                     ;�������
      xor dx, dx                 
      inc si                     ;������� ��������
loop size1     
      
Increment_counter_of_actual_size1: 
    pop bx      
    inc si      
    
Getting_number1:                 ;��������� �����
      mov ax, bx 
      mov cx, si                 ;�������� ������������ ������� �����
      dec cx 
      push bx
      mov bx, 10                 ;��������
      
Div_on_ten1:                     ;������� �������� ����� �� 10
     cmp cx, 0
     je End_of_div1
     div bx
     xor dx, dx 
     loop Div_on_ten1   
     
End_of_div1:                     ;���������� �������
     push ax                     ;��������� ��������
     mov dl, al
     mov ah, 2
     add dl, 30h                 ;�������� ����
     int 21h                     ;������� ����������� ��������
     pop ax
     mov cx, si                  ;�������� ��������� ������
     dec cx   
     
Inverse_multi1:                  ;�������� ��������� 
    cmp cx, 0                    
    je Completed_inverse_multi1
    mul bx
    loop Inverse_multi1
      
Completed_inverse_multi1: 
   pop bx
   sub bx, ax                    ;��������� �������� �������
   dec si
   cmp si, 0
   jne Getting_number1           ;���� �� ���������� ������� ������
   
Print_remainder: 
    pop dx                         ;
    cmp dx, 0
    je Close_program 
      
    mov dx, offset remainder               
    call Output_string_proc
   
Close_program:                    ;���������� ������
    mov ax, 4c00h
    int 21h
    
    
.data 
    Enter_array_str      db     0Ah, 0Dh, "Enter array:", 0Ah, 0Dh, '$'
    Sorted_array_str     db     0Ah, 0Dh, "Sorted Array Entered:", 0Ah, 0Dh, '$'
    Input_lenght_str     db     0Ah, 0Dh, "Enter an array size between 1 and 30 : ", 0Ah, 0Dh, '$'
    Error_lenght_str     db     0Ah, 0Dh, "!!!ERROR length!!!", 0Ah, 0Dh, '$'     
    Incorrect_value_str  db     0Ah, 0Dh, "Incorrect value entered:  ",'$'
    Median_str           db     0Ah, 0Dh, "Median of array: $"      
    remainder            db     ".5", '$' 
    
    buf_size equ 7
    buf_size_length equ 3    
    
    med_num              dw     ?
    size_                dw     ?   
    
    buffer               db     7 dup ('$')
    buffer1              db     3 dup ('$') 
    
    array                dw     size_ dup (?)      
end start