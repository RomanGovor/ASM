My_segment SEGMENT  
    
ASSUME SS:My_segment,DS:My_segment,CS:My_segment,ES:My_segment
.386   

org 80h                                 ;�������� 80h �� ������ PSP ��� ��������� ���������
Command_length                  db ?    ;����� ��������� ������
Comand_line                     db ?    ;���� ��������� ������
org 100h                                ;������ ��������� �� ����� PSP
   
;/--------------------------start------------------------------------/   
start: 
	JMP Parsing_cmd_lines                 
     
Old_interrupt_09h               dd 0    ;����� ������� 09h
Buffer_to_console               db 4000 dup(0)
File_id                         dw 0
Filename                        db 50 dup (0)
Count_args                      dw 0 
For_error                       dw 00h
Error_with_arguments_str        db 0Dh, 0Ah,"Command line should contain only one parameter!",0Dh, 0Ah,'$'
Resident_str                    db 0Ah, "Resident program working. Copy console - Ctrl + P",'$'
Error_moving_str                db 0Ah,0Dh,"Error moving pointer...$",0Ah,0Dh,'$'   
File_open_error_str             db 0Ah,"Error - opening file --- ",'$'      
File_create_error_str           db 0Ah,"Error - creating file --- ",'$' 
File_close_error_str            db 0Ah,"Error - closing file --- ",'$'       
Create_file_str                 db 0Ah,"The file you entered was not found. File is being created ...",'$'  
File_write_error_str            db 0Ah,"Error - write file --- ",'$' 
File_not_found_str              db "Error - file not found",'$'
Path_not_found_error_str        db "Error - path not found",'$'
Many_files_error_str            db "Error - many files opened",'$'
Access_denied_error_str         db "Error - access denied",'$'
Invalid_access_mode_error_str   db "Error - invalid access mode",'$'   
Unknown_file_id_error_str       db "Error - unknown file id",'$' 
Error_command_line_str          db 0Ah,"Error - could't get file name from cmd arguments",'$'      
                                                        

Parsing_cmd_lines:                   
    call Getting_param_from_command_line ;��������� ������ �����������
    call Check_file 

Install_handler:	
	cli                                 ;��������� ����������
	mov ah, 35h
	mov al, 09h                         ;�������� � ES:BX ����� ������� ����������� 09h    
	int 21h                     
	
	mov word ptr cs:Old_interrupt_09h,bx   ;�������� �����������
	mov word ptr cs:Old_interrupt_09h+2,es ;������� �����������
	
	mov ah, 25h                         ;��������� ������ �����������
	mov al, 09h                         
	lea dx, New_handler                 ;����������� ���������� int 09h
	int 21h 
	sti                                 ;��������� ����������
  	
	mov ah, 09h                         ;�������� ��������
	lea dx, Resident_str                
	int 21h 
 
    mov dx, offset Parsing_cmd_lines    ;����� ������� ����� �� ����������� �������� ���������
    int 27h                             ;����������, �� �������� �����������

Exit_of_program:	                        
	mov ax, 4c00h
	int 21h

;/--------------------------------------------------------------------/
Print_str_macro macro out_str            ;������ ������ ������
    pusha
    mov ah,09h
    mov dx,offset out_str
    int 21h 
    popa
endm                                                                               

;/-----------------------------------------------------------------/
Getting_param_from_command_line proc     ;��������� ���������� �� ��������� ������
    cld                                  ;��������� ����� ��������
	mov bp, sp      	                 ;���������� ������� ������� ����� bp
	mov cl, Command_length                   
	cmp cl, 1                            ;���� �� �������� ���������
	jnle Pars  
	
	Print_str_macro Error_command_line_str  ;����������� ������
	jmp Exit_of_program

Pars:
	mov cx, -1
	mov di, offset Comand_line           ;�������� ��������� ������

Skip_spaces_:
	mov al, ' '                          
	repz scasb                           ;������������ ��������� ������, ���� � ��� �������
    cmp [si], 0Dh                        ;���� �� ����� ������
	je End_getting_param
    
Inc_count_param:	
	dec di                               ;������ ���������
	push di                             
	inc word ptr Count_args              ;����������������� ����� ����������
	cmp Count_args, 2                    ;�������� �� ����� ����������
	je Error_par
	mov si, di                           ;��������� ������ ������ � ������
	
Get_symbol_by_symbol:
	lodsb                                ;������ ��  DS:SI
	cmp al, 0Dh                          ;���� �� ����� ������
	je End_getting_param
	cmp al, ' '                          ;���� �� ������
	jne Get_symbol_by_symbol

If_end_param:                            ;���� ����� ���������	
	dec si                               
	mov byte ptr [si], 0                 ;��������� 0 � �����
	mov di, si
	inc di
	jmp Skip_spaces_
	
End_getting_param:                       ;���������� ��������� ����������
	dec si
	mov byte ptr [si], 0

Copy_filename:                           ;��������� ����� �����
	mov cx, 50
	pop si
	lea di, Filename
	repne movsb	   
	ret

Error_par:                              ;� ������ ������ ���������
    Print_str_macro Error_with_arguments_str
	jmp Exit_of_program
		
Getting_param_from_command_line endp

;/----------------------------------------------------------------------/ 
New_handler proc                ;����� ����������
	pushF                       ;���������� ������ � ����
	call cs:Old_interrupt_09h   ;����� ���������� ���. ����. 09h   
	cli                         ;������ ����������
	pusha

    mov ah, 01h                 ;�������� �� ������� �������� � ������
    int 16h
   
    mov bh, ah                  
    jz Return_handler
   
    mov ah, 02h                 ;������ ��������� shift-������
    int 16h
    and al, 4                   ;3 ��� ����� ��������(CTRL)
    cmp al, 0
    je Return_handler
   
    cmp bh, 19h
    jne Return_handler
    mov ah, 00h
    int 16h      	 
	 
	mov ax,0B800h               ;��������� ������ ������
	mov ds,ax                   ;��������� ������ ��� ��������� DS:SI   
	
	mov ax, cs
	mov es, ax

	mov di, offset Buffer_to_console   ;����������� �������
	xor si, si
	mov cx, 2000                ;������� ������ 80�25 
	rep movsw

Work_with_file:	 
    call Filter_buffer          ;�������������� ������ � ������
	call Open_file              ;�������� �����
	call Set_position_in_file	
	call Write_buff_into_file	
	call Close_file    
	
Return_handler: 
	popa
	sti
	iret          
	
New_handler endp 
;/------------------------------------------------------------------------/
Filter_buffer proc                  ;������ ������ �������
	mov ax, cs
	mov ds, ax
	mov cx, 2000
	mov di, offset Buffer_to_console
	xor si, si
	xor bl, bl  
	
Buffer_shaping:                     ;������������ ��������� ������
	mov ah, [di]
	mov Buffer_to_console[si], ah
	cmp bl, 79                      ;���� �� ����� ������       
	jne Next_line_buffer
	mov byte ptr Buffer_to_console[si+1], 0Dh ;��������� �������� �� ��������� ������
	inc si
	mov bl, -1
	
Next_line_buffer:                   ;������� �� ��������� ������ � ������
	inc bl
	inc si
	add di, 2  	
loop Buffer_shaping 

    ret
Filter_buffer endp    

;/------------------------------------------------------------------------/ 
Set_position_in_file proc           ;��������� ������� ������� � ����� 
    pusha
      
    mov bx, File_id                 ;�������� id �����
    mov al, 02h                     ;��������� �� ����� �����
    xor cx, cx                        
    xor dx, dx    
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

;/-----------------------------------------------------------------/
Close_file proc                     ;�������� �����
    pusha
    
    mov bx, File_id                 ;������������� �����
    xor ax, ax    
    mov ah, 3Eh    
    int 21h
    jc Close_file_fail              ;���� ������ �������� �����

    popa
    ret 
    
Close_file_fail:
   Print_str_macro File_close_error_str        
   Print_str_macro Unknown_file_id_error_str
   jmp Return_handler
   ret
close_file endp  

;/---------------------------------------------------------------------/
Check_file proc                     ;�������� �� ������� �����
    push cx
    push ax
     
    xor cx, cx 
    mov dx, offset Filename
    mov ah, 3Dh                     ;������� �������� �����
    mov al, 02h                     ;����� ������
    int 21h 
    jc File_not
    jmp Closing	

File_not:                           ;���� ���� �� ������ 
    Print_str_macro Create_file_str     
    xor cx, cx
	lea dx, Filename
	mov ah, 3Ch                     ;�������� �����
	mov al, 00h
	int 21h 
    jc Create_file_fail
        
Closing:
    mov File_id, ax 
    call Close_file                 ;�������� �����
    pop ax
    pop cx         
    ret

Create_file_fail:
    Print_str_macro File_create_error_str    
    cmp ax, 03h                     
    jne Create_04h
    Print_str_macro Path_not_found_error_str ;���� �� ������
    jmp Exit_of_program

Create_04h:
    cmp ax, 04h
    jne Create_05h   
    Print_str_macro Many_files_error_str ;����� �������� ������
    jmp Exit_of_program
                            
Create_05h:                             ;�������� �� �������� ������
    Print_str_macro Access_denied_error_str
    jmp Exit_of_program           
    
Check_file endp
;/------------------------------------------------------------------/ 
Open_file proc                      ;�������� ����� ��������� 
    push cx
    push ax
       
    xor cx, cx 
    mov dx, offset Filename
    mov ah, 3Dh                     ;������� �������� �����
    mov al, 02h                     ;����� ������
    int 21h 
    jc Open_file_fail               ;���� ������ �������� �����
    	
    mov File_id, ax  
    pop ax
    pop cx
    ret 
    
Open_file_fail:
    Print_str_macro File_open_error_str  ;����� ��������� � ������       
    cmp ax, 02h                     ;� �� ������������ ������ 
    jne AX_03h
    Print_str_macro File_not_found_str   ;���� �� ������
    jmp Return_handler  
    
AX_03h:                             ;�������� �� ������ ����
    cmp ax, 03h 
    jne AX_04h  
    Print_str_macro Path_not_found_error_str
    jmp Return_handler      
    
AX_04h:                             ;�������� �� ����� �������� ������
    cmp ax, 04h
    jne AX_05h   
    Print_str_macro Many_files_error_str
    jmp Return_handler
                            
AX_05h:                             ;�������� �� �������� ������
    cmp ax, 05h
    jne AX_0Ch 
    Print_str_macro Access_denied_error_str
    jmp Return_handler      
    
AX_0Ch:                             ;�������� �� ����� �������
    Print_str_macro Invalid_access_mode_error_str
    jmp Return_handler
    
    ret               
endp                                                                 

;/------------------------------------------------------------------/
Write_buff_into_file proc           ;������ ������ � ����     
	mov bx, File_id
	mov cx, 2025                    ;80�25 + 25 ��������� �� ����� ������
	lea dx, Buffer_to_console
	mov ah, 40h                     ;������ � ����
	int 21h                                                   
	
	jc Write_file_fail              ;���� ������ ������ � ����		    
    ret  
     
Write_file_fail:
    Print_str_macro File_write_error_str  ;����� ��������� � ������       
    cmp ax, 05h                           ;� �� ������������ ������ 
    jne AX_06h
    Print_str_macro Access_denied_error_str    ;������ ��������
    jmp Return_handler  
    
AX_06h:                             ;�������� �� ������ ����
    cmp ax, 06h 
    Print_str_macro Unknown_file_id_error_str ;�������� ������������� 
    jmp Return_handler
    ret     
Write_buff_into_file endp      

;/-----------------------------------------------------------------/  
My_segment ENDS                     ;����� ��������    
end start                           ;������ ����� ��������� start 