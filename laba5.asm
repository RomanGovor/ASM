name "lab5"
;������� 13
.model tiny

.data  
;/----------------------------------------������-------------------------------------/  
Cmd_line_length         db ?                 ;��������� ������
Cmd_line                db 127 dup('$')
count_of_cmd_word       db 3

Name_of_file            db 50 dup('$')   
File_id                 dw 0h 
File_size               dw 0h

New_name_of_file        db '\',13 dup(0),0

New_file_id             dw 0h 

Error_opening_file_str  db 0Ah,0Dh,"No such file!!!$",                           0Ah,0Dh,'$'
File_opened_str         db 0Ah,0Dh,"File is opened!$",                           0Ah,0Dh,'$'  
File_closed_str         db 0Ah,0Dh,"File is closed!$",                           0Ah,0Dh,'$'
Cmd_error_str           db 0Ah,0Dh,"Bad arguments in command line...",           0Ah,0Dh,'$'
Word_was_found_str      db 0Ah,0Dh,"Word is found!$",                            0Ah,0Dh,'$'
Error_moving_str        db 0Ah,0Dh,"Error moving pointer...$",                   0Ah,0Dh,'$'   
Word_not_found_str      db 0Ah,0Dh,"Word not found!",                            0Ah,0Dh,'$' 
space                   db 0Ah,0Dh,'$' 
Big_word_str            db 0Ah,0Dh,"Error! Word over 50 symbols................",0Ah,0Dh,'$'
Count_reading_byte      dw 3Ch 

Starting_position_buf   dw 0h
Last_position_buf       dw 0h
File_buffer             db 200 dup ('$')
Size_of_file_buffer     dw 0h 
New_buffer_size         dw 0h
Substring_buffer_size   dw 0h

Punctuation_marks       db " .,!",09H,0Dh,0Ah

Old_word                db 54 dup ('$') 
Size_old_word           dw 0
New_word                db 54 dup ('$')                       
Size_new_word           dw 0 

Current_byte_pos_high   dw 0h 
Current_byte_pos_low    dw 0h 

New_byte_pos_high       dw 0h 
New_byte_pos_low        dw 0h 

Read_bytes              dw 0h 
Check_byte              dw 0h
argc                    db 0h

Max_size_of_word       equ 50
.code     

;/------------------------------------�������---------------------------------------/
Print_str_macro macro out_str       ;������ ������ ������
    pusha
    mov ah,09h
    mov dx,offset out_str
    int 21h 
    popa
endm  

Close_file_macro macro File_idi      ;�������� �����
    pusha
    mov bx, File_idi                 ;�������� ����������� �����
    xor ax, ax                     
    mov ah, 3Eh                      ;������� �������� �����
    int 21h          
    popa
endm  

;/----------------------------------start------------------------------------------/
start:
    call Get_argument_from_cmd     ;��������� ���������� �� ��������� ������
    call Open_file                 ;�������� �����
    mov File_id, ax                ;��������� id ����� �� ax 
    call Get_size_of_file          ;��������� ������� �����
    call Create_new_file           ;�������� ������ �����
   
Main_cycle:   
    cmp File_size,0h               ;���� ������ ����� 0
    je Close_file_and_exit_program    
    call Read_information_from_file;������ ���������� � �����
    call Filter_file_buffer        ;������ �������
    Print_str_macro File_buffer    ;������ ������
    
    call Checking_buffer           ;�������� � ������ ���� � ������ 
    Print_str_macro File_buffer
                                                  
    call Write_buf_into_file       ;������ ������ � ����
    mov ax,Read_bytes
    sub File_size,ax
    
    cmp File_size,0h               ;���� �� ������ �����
jne Main_cycle
    
Close_file_and_exit_program: 
    Close_file_macro File_id        ;�������� ����� 
    Print_str_macro File_closed_str ;����� ������ � �������� �����
    Close_file_macro New_file_id       
    
    call Delete_file
     
    xor ax, ax
    mov ah, 56h                         ;������� ���������������� �����
    lea dx, New_name_of_file
    lea di, Name_of_file
    int 21h       
  
Exit_of_program:                   ;�������� ��������� � �������� ���� �� ������� ���� �� ���� 
Check_flag:
    cmp Check_byte, 1
    je exit
    Print_str_macro Word_not_found_str
    
exit:           
    mov ah,4Ch
    mov al,00h
    int 21h 

;/------------------------------PROC-----------------------------------------------/ 

;/---------------------------------------------------------------------------------/
Get_argument_from_cmd proc   ;��������� ���������� �� ��������� ������
    pusha
    cld                      ;��� ������ ��������� ���������
    
    mov ax,@data             ;��������� �������� ������
    mov es,ax
    
    xor cx,cx                ;��������� ��������
    mov cl,ds:[80h]          ;�������� 80h �� ������ PSP
    mov Cmd_line_length,cl   ;��������� ����� ��������� ������
    mov si,82h
    lea di,Cmd_line
    rep movsb                ;��������� ��������� ������(��������� ������ �� DS:SI � ES:DI)

    xor cx,cx                ;��������� ��������
    xor ax,ax
    mov cl,Cmd_line_length   ;�������� ��������� ������
    
    
    lea si,Cmd_line          ;�������� �������� ��������� ������
    lea di,Name_of_file      ;�������� �������� �������� �����
    call Get_word_from_cmd   ;��������� ��� ����� �� ��������� ������
    
    
    lea di,Old_word          ;�������� �������� �����, ������� ����� ��������
    call Get_word_from_cmd   ;��������� ������������ ����� 
    
    cmp Old_word,'$'         ;���� ������������ ����� ����
    je Error_from_cmd
    push si
    lea si,Old_word          ;�������� �������� ������� �����
    call Get_word_size       ;��������� ������� ����������� �����
    
    mov Size_old_word,ax     ;��������� ������� ������� ����� � ����������
    pop si 
    
    lea di,New_word          ;�������� �������� ������ �����
    call Get_word_from_cmd   ;��������� ������ �����
    
    cmp New_word,'$'         ;���� �� ������� �����
    je Error_from_cmd 
   
    lea si,New_word 
    call Get_word_size       ;��������� ������� ������ �����
    mov Size_new_word,ax     ;��������� ������� ������ ����� � ����������
    
    Print_str_macro Cmd_line
    Print_str_macro space
    Print_str_macro Name_of_file
    Print_str_macro space
    Print_str_macro Old_word
    Print_str_macro space
    Print_str_macro New_word
    
    popa
    ret                       ;����� �� ���������

Error_from_cmd:               ;���� ������ ������ � ��������� �������
    Print_str_macro Cmd_error_str
    jmp Exit_of_program     
            
Get_argument_from_cmd endp 

;/-----------------------------------------------------------------------------------------------------/
Get_word_from_cmd proc        ;��������� ����� �� ��������� ������
    push ax
    push cx
    push di 
    xor ax,ax  
    
Skip_spaces:                   ;������� �������� � ��������� ������
    mov al,[si]           
    cmp al,' '               
    jne Loop_getting          
    inc si                   
    jmp Skip_spaces              
    
Loop_getting:
    mov al,[si]                  ;�������� ������� �� �������� ��������� ������
    
    cmp al,' '                   ;���� ������
    je End_getting    
    cmp al,09h                   ;���� TAB
    je End_getting    
    cmp al,0Ah                   ;���� ����� ������
    je End_getting    
    cmp al,0Dh                   ;���� �������� ������� � ������
    je End_getting    
    cmp al,00h                   ;���� NULL
    je End_getting               ;���������� ������ ������
    
    mov [di],al                  ;������ ������� � ������������ ������
    inc si                       ;����������������� ���������
    inc di
loop Loop_getting  

End_getting:
    mov [di],0                   ;��������� ���� � �����
    inc si
            
    pop di
    pop cx
    pop ax
    ret
Get_word_from_cmd endp

;/---------------------------------------------------------------------------------------/
Get_word_size proc              ;��������� ������� �����                 
	push bx                     
	push si                   
	                            
	xor ax, ax                  
                                
Counting:                  
	mov bl, [si]           
	cmp bl, 0                    ;���� ���� �� ����
	je End_counting             
                               
	inc si                  
	inc ax                       ;����������������� ����� �����                                              
	jmp Counting           
	                            
End_counting:
    cmp ax,Max_size_of_word
    jge End_get_word_size
    Print_str_macro Big_word_str             
    jmp exit
End_get_word_size:                        
	pop si                      
	pop bx                     
	ret                         
Get_word_size endp                          

;/---------------------------------------------------------------------------------------/   
Open_file proc                    ;��������� �������� �����
    push dx
    mov dx,offset Name_of_file    ;�������� �������� �����, ������� ������� �������
    mov ax, 3D02h                 ;3D - ������� �������� ������������� �����, 02 - ����� ������ � ������
    int 21h       
    jc Error_opening_file         ;���� ���������� ���� ��������(CF)
    jmp Success_opened 
    
Error_opening_file:          
    Print_str_macro Error_opening_file_str
    pop dx
    jmp Exit_of_program           ;����� �� ��������� 
    
Success_opened:                   ;������ �������
    Print_str_macro File_opened_str  
    pop dx
    ret
Open_file endp   

;/--------------------------------------------------------------------------------------/
Read_information_from_file proc   ;������ ���������� �� �����
    push bx
    push cx
    push dx
    
    call Set_position_in_file      ;��������� �������
    
    mov bx, File_id                ;�������� ��������� id
    mov ah, 3Fh                                             
    mov cx,Count_reading_byte      ;���-�� ���� ��� ������ 
    mov dx, offset File_buffer     ;�������� ����� ��� �����
    int 21h   
    
    mov Read_bytes, ax             ;���������� ���������� ����������� ������
    dec ax
    mov Size_of_file_buffer,ax     ;�������� ������������ ������� ������
    mov New_buffer_size,ax
    mov Substring_buffer_size,ax 

    mov ax,Count_reading_byte  
    clc                            ;����� ����� ��������
    add Current_byte_pos_low,ax    ;��������� �������������� ������
    jc All_low_bytes               ;���� �������� ������������ � 2 �����
    jmp End_reading_file 
    
All_low_bytes:                     ;��������� �������� �����
    inc Current_byte_pos_high

End_reading_file:                  ;���������� ������ �����
    pop dx
    pop cx
    pop bx
    ret
Read_information_from_file endp

;/--------------------------------------------------------------------------------/
Set_position_in_file proc           ;��������� ������� ������� � ����� 
    pusha
      
    mov bx, File_id                 ;�������� id �����
    mov al, 00h                     ;��������� �� ������ �����
    xor cx, cx                        
    mov dx, Current_byte_pos_low    ;��������� �������� �� ����� CX:DX  
    mov cx, Current_byte_pos_high        
    mov ah, 42h  
    int 21h
    
    jc Error_set                    ;���� CF ������������� �� ������
    jmp Success_set                 ;��� �������� ��������� �������
    
Error_set:
    Print_str_macro Error_moving_str 
    jmp Exit_of_program

Success_set:        
    popa    
    ret
Set_position_in_file endp

;/-------------------------------------------------------------------------------/
Filter_file_buffer proc            ;��������� ��������� �������
    pusha
    lea si,File_buffer             ;��������� �������� ������� �����
    add si,Count_reading_byte      ;����������� �������
    dec si 
    
Cycle_of_filter:
    cmp [si],'$'                  ;���� ����� ������
    je Filter_is_done
   
    cmp [si],00h                  ;���� ������ ������
    je Filter_is_done
   
    cmp [si],' '                  ;���� ������
    je Filter_is_done
   
    mov [si],'$'                  ;��������� ������� � ����� �������������� ������
    dec si
    dec Current_byte_pos_low      ;����������������� ������� ������� � �����
    dec Read_bytes                ;����������������� �������� ������
    jmp Cycle_of_filter 
                                  ;���������� ����������
Filter_is_done:    
    popa
    ret
Filter_file_buffer endp    
 
;/---------------------------------------------------------------------------/
Get_size_of_file proc             ;��������� ������� �����
    pusha    
    xor cx,cx                     ;��������� ��������� � ����
    xor dx,dx
    mov ah,42h                    ;����������� ��������� ������/������
    mov al,02h                    ;����������� ��������� ������������ ����� �����
    mov bx,File_id                ;�������� id �����
    int 21h 
    mov File_size,ax              ;��������� ������� ����� � ������ �� ������ �����
    popa 
    ret
Get_size_of_file endp  

;/-----------------------------------------------------------------------------/ 
Checking_buffer proc              ;����� �������� ����� � ������
    pusha
    lea si,File_buffer            ;�������� �������� ��������� ������

Loop_serching_word:
    mov Starting_position_buf,si  ;�������� ��������� ������� ������(����� ���������������� �� �����)    
    lea di,Old_word               ;�������� �������� ������� �����
    mov cx,Size_old_word          ;�������� �������  ������� �����
    REPE cmpsb                    ;��������� ���� ������� �����. ��������� ���������(DS:SI � ES:DI)
        
    cmp cx,0h                     ;���� CX ���������, �� ��������, ��� ����� �������
    ;je Word_found
    je Check_on_substring
    
Skip_symbol:               ;;;;;;;;;;;;;;;;;;;;
    sub cx,Size_old_word
    not cx                        ;������� � �������� ���
    inc cx                        ;��������� ������� �����
    sub New_buffer_size,cx 
    sub Substring_buffer_size,cx  ;�������� ����� ������ ������������ ������������ �������
    
    cmp File_size,0h              ;���� ���������� ������ �����
    je If_end_buffer    
    lea di,Punctuation_marks      ;�������� �������� ������ ����������
    
Loop_skip_punctuation:            ;���� �������� ���� ������ ����������
    cmpsb                         ;���� ���������� ���� ���������� 
    je Loop_serching_word
                                  
    dec si                        ;���������� ������
    cmp [si],'$'                  ;���� ��������� ����� ������
    je If_end_buffer
    
    cmp [si],0                    ;���� ��������� ����� ������(�������� ������ 0)    
    je If_end_buffer
    
    cmp [di],0Ah                  
    je Loop_serching_word
jne Loop_skip_punctuation 

Check_on_substring:               ;�������� ��� ����� ���������� ����� ��������� ������ �� �������� ������ 
    cmp [si], ' '
    je Check_on_symbol_before_word
    cmp [si], 0Ah
    je Check_on_symbol_before_word
    cmp [si], 0
    je Check_on_symbol_before_word
    cmp [si], 09h
    je Check_on_symbol_before_word   
    cmp [si], '.'
    je Check_on_symbol_before_word     
    cmp [si], ','
    je Check_on_symbol_before_word  
    cmp [si], 0Dh
    je Check_on_symbol_before_word
    
    jmp Skip_symbol               ;���� �� �� �����(�������� ����� �������� ����������)

This_is_word:                     ;����� �������
	pop si
    jmp Word_found
    
Check_on_symbol_before_word:      ;�������� ��� �� ���� �� ���������� �����
	push si   
    sub si, Size_old_word
    dec si
    
    cmp [si], ' '
    je This_is_word
    cmp [si], 0Ah
    je This_is_word
    cmp [si], 0
    je This_is_word
    cmp [si], 09h
    je This_is_word   
    cmp [si], '.'
    je This_is_word 
    cmp [si], ','
    je This_is_word
    
    
    ;add si, Size_old_word
    pop si 
     
    jmp Skip_symbol
   
Word_found:                       ;����� ������ ����� �������
    Print_str_macro Word_was_found_str   
    call Edit_buf_length          ;��������� ����� ����� ������
    mov Check_byte, 1             ;���� ����, ��� ����� �������
    
    call Change_old_word_to_new             
    cmp File_size,0h              ;���� �� ������, �� ������� � ���� 
    je If_end_buffer
    jne Loop_serching_word  
    
If_end_buffer:
    dec si                        ;���������� �������� ��������� �������� ������
    cmp [si],00h                  ;���� ���������� ������ ������ - �����
    je End_check 
    jne Clear_buffer  

End_check:                        ;���������� ��������
    mov File_size,0h
    mov cx,Size_old_word          ;�������� ������� ������� �����
    sub cx,Size_new_word           
    sub si,cx
    dec si       
    
Clear_buffer:                     ;������� ������
    mov [si],0h
    inc si
loop Clear_buffer       
    popa
    ret
Checking_buffer endp    

;/-----------------------------------------------------------------------------/
Update_info_buf_size proc           ;���������� ���������� � ������� ��������� ������
    pusha
    lea si,File_buffer              ;��������� �������� ��������� ������
    mov Size_of_file_buffer,000h    ;��������� ������� ��������� ������
    
Loop_update_size:
    inc si
    inc Size_of_file_buffer         ;������� �����������
    cmp [si],00h                    ;���� �� ����� ������
     
    jne Check_on_end_buf            ;���� �� ����� �����
    jmp End_update_size     
    
Check_on_end_buf:    
    cmp [si],'$'
    jne Loop_update_size
    mov [si],00h                    ;��������� ���� � ����� ������
    jmp End_update_size 
    
End_update_size:                    ;���������� ��������
    popa
    ret
Update_info_buf_size endp     

;/----------------------------------------------------------------------------------/       
Change_old_word_to_new proc             ;������ ������� ����� �� �����
    mov si,Starting_position_buf        ;�������� ������� � ������� ������� ����������� ������
    mov di,si
    mov cx,Size_new_word                ;�������� ������� ������ �����
    
Check_start_pos:
    cmp [si],' '                        ;���� �������� ����� �������
    je Word_is_changed                  ;���������� ������
    cmp [si],'!'
    je Word_is_changed
    cmp [si],09H                        ;���� ������� ����� ���
    je Word_is_changed  
    
Get_pos_end_word:                       ;��������� ������� ����� �����
    cmp [si],0Dh                        ;���� ���������� ������� �� ����� ������    
    je If_met_enter
    inc si                              ;��������� ������� � ������
    dec Substring_buffer_size           ;
    cmp [si],00h
    je End_of_word_was_found            ;���� �� ��������������� ����
    cmp [si],'!'
    je End_of_word_was_found            ;���� �� ���
    cmp [si],09H 
    je End_of_word_was_found            ;���� �� �������
    cmp [si],','                        
    je End_of_word_was_found            ;���� �� ������
    cmp [si],' '
    jne Get_pos_end_word 
    
End_of_word_was_found:      
    mov ax, Size_old_word                       
    cmp Size_new_word,ax
    ja Add_to_right                     ;���� ����� ����� �� ������� ������
    cld                                 ;����� ����� �����������
    jmp Add_to_left                     ;���� ������
    
Add_to_right:                           ;���������� ����� ������(���� ����� ����� ������)
    mov Substring_buffer_size,0h
    
Loop_find_end_buf_right:                ;���� ������ ����� ������ � �������� ����� ��������� ��� ��������
    inc si
    inc Substring_buffer_size                             
    cmp [si],00                         ;����� ����� ������
    jne Loop_find_end_buf_right
    mov cx,Substring_buffer_size        ;��������� ������� ������ ���������(��� ����� ������, ������� ����� �����������)
    inc cx
    mov di,si                           ;�������� ������� ��������� ������
    add di,Size_new_word
    sub di,Size_old_word                ;����������� �������� �������� ���� ��� ��������
    
    std                                 ;��������� ����� �����������(����������� � �������� �������)
    jmp Substring_wrapping   
    
Add_to_left:                            ;���������� ����� �����(���� ����� ����� ������)
    cmp [si],00h                        ;���� ����� ������
    je Substring_wrapping 
    push si
    mov Substring_buffer_size,0h 
    
Loop_find_end_buf_left:                 ;���� ������ ����� ������ � �������� ����� ��������� ��� �������� 
    inc si
    inc Substring_buffer_size
    cmp [si],00
    jne Loop_find_end_buf_left
    mov cx,Substring_buffer_size
    pop si
    add di,Size_new_word                ;���������� �������� ������ �����
    
Substring_wrapping:    
    repe movsb                          ;�������� ������ ��� ������� ������ �����
    mov ax,Size_of_file_buffer
    add ax,Size_new_word
    sub ax,Size_old_word
    mov Size_of_file_buffer,ax          ;���������� ������������ ������� ��������� ������
    cld                                 ;����� ����� ��������

Insert_new_word:    
    lea si,New_word                     ;��������� �������� ������ �����
    mov di,Starting_position_buf        ;�������� ��������� ������� ������
    mov cx,Size_new_word
    repe movsb                          ;����������� ����� ������ �� ����� ������
    
    xchg si,di                          ;������� ������ (������� ������� ������� � ����� � si)    
    jmp Word_is_changed
        
If_met_enter:                           ;���� ���������� ENTER
    inc si
    dec Substring_buffer_size
    jmp Get_pos_end_word
          
Word_is_changed:                        ;����������
    ret
Change_old_word_to_new endp  

;/--------------------------------------------------------------------/
Create_new_file proc                    ;�������� ��������������� �����
    pusha
    mov ah, 5Ah                         ;������� �������� �����
    mov cx, 0h                          ;������ ��� ������
    lea dx, New_name_of_file
    int 21h
    mov New_file_id, ax                 ;��������� id ������ �����
              
    popa
    ret
Create_new_file endp

;/--------------------------------------------------------------------/
Rename_file proc                        ;���������������� �����
    pusha
    xor ax, ax
    mov ah, 56h                         ;������� ���������������� �����
    lea dx, New_name_of_file
    lea di, Name_of_file
    int 21h             
    popa
    ret
Rename_file endp  

;/--------------------------------------------------------------------/
Delete_file proc                        ;�������� �����
    pusha
    mov ah, 41h                         ;������� �������� �����
    lea dx, Name_of_file
    int 21h             
    popa
    ret
Delete_file endp 

;/--------------------------------------------------------------------------------/
Edit_buf_length proc                 ;��������� �������� �� ��������� ����� ������
    pusha
    mov ax,New_buffer_size           ;��������� ������ ������� ������
    sub ax,Size_old_word
    add ax,Size_new_word
    mov New_buffer_size,ax           ;��������� ������ ������� ������
    popa
    ret
Edit_buf_length endp 

;/------------------------------------------------------------------------------/
Write_buf_into_file proc             ;������ ����������� ������ � ����� ����
    pusha 
    
    mov bx, File_id
    mov al, 00h                      ;��������� ������� �����
    xor cx, cx                       ;��������� ��������
    
    mov dx, New_byte_pos_low         
    mov cx, New_byte_pos_high         
    mov ah, 42h                       ;��������� ������� �� ������ ����� ������� CX:DX   
    int 21h
    
    mov ah,40h                        ;������� ������ � ����
    mov bx,New_file_id                ;��������� �������������� �����
    call Update_info_buf_size         ;��������� ����������� ���������� � ������� ������
    mov cx,Size_of_file_buffer        ;����� ������ ��� ������

    lea dx,File_buffer                ;������ ������ ������
    int 21h
    
    call Buffer_clearing              ;������� ������
         
    clc                               ;��������� ����� ��������
    add New_byte_pos_low,cx 
    jc Add_new_low_byte               ;���� �������� ������������ � 2 �����, �� ���������� �������� �������
    jmp End_writing
    
Add_new_low_byte:
    inc New_byte_pos_high
    mov New_byte_pos_low,0h     
    
End_writing:                          ;���������� ������
    popa
    ret
Write_buf_into_file endp                                         

;/----------------------------------------------------------------------------------/  
Buffer_clearing proc                   ;������� ������ 
    pusha
    lea si,File_buffer                 
    mov cx,200 
    
Loop_clear:                            ;������� ��������� ������
    mov [si],'$'
    inc si
loop Loop_clear
    
    mov Size_of_file_buffer,0h         ;��������� ����������� ������
    popa
    ret
Buffer_clearing endp    


end start 

