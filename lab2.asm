.model small
.stack 100h	
.code  
        
       
print_str_macro macro str                  ;������ ������ ������
    lea dx, str  
    mov ah, 09h
    int 21h    
endm 

enter_str_macro macro string               ;������ ����� ������
    lea bx, string
    mov dx, bx    
    mov ah, 0Ah
    int 21h
endm

main:
	mov ax, @data
    mov ds, ax 
    
    print_str_macro EnterLine
    
    enter_str_macro string
    
    mov al,string[1]                 ;�������� �� ������ ������
    cmp al,0
    je Empty_line 
    
    add bl, string[1]
    add bx, 2
    mov [bx], '$'
    
    lea bx, string
    add bx, 2
    
    mov si, bx                        
    mov di, bx
    
    mov al, [di]                      ;��������� � ��������
    cmp al, ' '
    je If_spaces                      ;���� ������ ������

Beginning:                            ;������� � ������
    mov al, [si]
    cmp al, ' '
    je Word_was_found
    mov bx, di
    jmp Word_searching
    
Buble:                               ;��� ������ ��������� ����� ������, ������� �������� si � ������(� di)
    mov si, di    
    jmp Word_searching


Word_searching:                      ;����� ���������� �����
    inc si                           ;�������������� �� ������� ��� �� ����� ������
    mov al, [si]
    cmp al, ' '
    je Word_was_found
    cmp al, '$'
    je End_of_string
    jmp Word_searching

Word_was_found:                      ;���� ������� �����
    inc si                           ;������� �� ������ ������� �����
    mov al, [si]
    cmp al, ' ' 
    je Word_was_found
    cmp al, '$'
    je End_of_string
    jmp cmpWords        

End_of_string:                       ;���� ��� ��������� ����� ������, ������������ �������� di � ���������� ����� ��� ���������
    inc di
    mov al, [di]
    cmp al, ' '
    je If_spaces                     
    cmp al, '$'
    je End_of_sort                   ;���� ��������� ����� ������ ��������� di, �� ���������� ����������
    jmp End_of_string

If_spaces:                           ;������� ��������
    inc di
    mov al, [di]
    cmp al, ' '
    je If_spaces
    jmp Buble
    
cmpWords:                            ;������ �������� �����, ��� di ��������� �� ������ ������� �����, � si �� ������ �������
    mov bx, di                                                                                                
    mov dx, si
    
Compare:                                                                                                  
    mov al, [bx]
    mov ah, [si]
    cmp al, ah
    ja Search_end_of_second_word            ;������� � ������ ����� ������� ����� ��� ������������ �������
    cmp al, ah
    je Next_byte                     ;���� ������ ������� ����� ���� ���������
    cmp al, ah
    jb Word_searching                ;���� ������������ ���� �� ���������

Swap:
    dec si
    mov bx, di
    push si                          ;� ���� ��������� ����� ������� �����
    push di                          ;������ �������
    
Reverse_1:                           ;������ ����� ���������� ����� ������ � ������ ������
    cmp di, si
    jae End_reverse_1
    
    mov al, [di]
    mov ah, [si]
    
    mov [si], al
    mov [di], ah
    
    inc di
    dec si                             
    jmp Reverse_1    
    
End_reverse_1:                       ;���������� ������� �������
    pop di                           ;����������� �� ����� ������ ������� �����
    pop si                           ;����� �������
    push si                          ;��������� � ���� ����� ������� �����
    push di                          ;������ �������
    mov di, si

Find_start_of_second_word:           ;����� ������ ������� �����
    dec di
    mov al, [di]
    cmp al, ' '
    jne Find_start_of_second_word
    
    inc di
    push di                          ;��������� � ���� ������ ������� �����
    
Reverse_2:                           ;������ ������� �����
    cmp di, si
    jae End_reverse_2
    
    mov al, [di]
    mov ah, [si]
    
    mov [si], al
    mov [di], ah
    
    inc di
    dec si
    jmp Reverse_2     

End_reverse_2:
    pop si                            ;���������� � si ������ ������� �����
    dec si
    pop di                            ;� di ������ �������
    push di                           ;��������� di � ����
    
Find_start_of_part_between_words:     ;����� ������ ����� ������ ����� ������ � ������ ������
    inc di
    mov al, [di]
    cmp al, ' '
    jne Find_start_of_part_between_words
    
    push di        
    
Reverse_3:                            ;������ ����� ������ ����� ����� �������
    cmp di, si
    jae End_reverse_3
    
    mov al, [di]
    mov ah, [si]
    
    mov [si], al
    mov [di], ah
    
    inc di
    dec si
    jmp Reverse_3    
    
End_reverse_3:                       
    pop si                           ;���������� � si ����� ������� �����
    dec si
    pop di                           ;� di ������ �������
    push di                          ;��������� � ���� di
    
Reverse_4:                           ;������ ������� �����
    cmp di, si
    jae End_reverse_4
    
    mov al, [di]
    mov ah, [si]
    
    mov [si], al
    mov [di], ah
    
    inc di
    dec si
    jmp Reverse_4            
                                      
End_reverse_4:                       
    pop di                           ;���������� ������ ������� �����
    pop si                           ;���������� ����� ������� �����
    jmp Word_searching    
    
Search_end_of_second_word:                  ;����� ����� ������� �����
    inc si
    mov al, [si]
    cmp al, ' '                      ;���� ����� ������, �� ����
    je Swap
    cmp al, '$'
    je Swap
    jmp Search_end_of_second_word 
 
Next_byte:                           ;���� ������� ����� ���� ���������
    inc bx
    mov al, [bx]
    cmp al, ' '
    je Beginning
    inc si
    mov al, [si]
    cmp al, ' '
    je Swap
    cmp al, '$'
    je Swap
    jmp Compare
             
End_of_sort:                         ;���������� ����������
      
    print_str_macro sortedStr        
    print_str_macro string+2 
    
    jmp End_of_work 
    
Empty_line:
    print_str_macro Error_line
    
End_of_work:    	                 ;���������� ������ 

	mov ax, 4c00h
    int 21h
    
.data 
    EnterLine db "Enter string:", 0Dh, 0Ah, '$'
    sortedStr db 0Dh, 0Ah, "Sorted string:", 0Dh, 0Ah, '$'
	Error_line db 0Dh, 0Ah, "Empty line!", '$'
	string db size,?,size dup ('$')  
	
	size equ 200    
    
end main  

