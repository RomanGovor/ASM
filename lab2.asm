.model small             ;5 вар
.stack 100h	
.code  
        
       
print_str_macro macro str                  ;макрос вывода строки
    lea dx, str  
    mov ah, 09h
    int 21h    
endm 

enter_str_macro macro string               ;макрос ввода строки
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
    
    mov al,string[1]                 ;проверка на пустую строку
    cmp al,0
    je Empty_line 
    
    add bl, string[1]
    add bx, 2
    mov [bx], '$'
    
    lea bx, string
    add bx, 2
    
    mov si, bx                        
    mov di, bx
    
    mov al, [di]                      ;сравнение с пробелом
    cmp al, ' '
    je If_spaces                      ;если пробел найден

Beginning:                            ;Возврат в начало
    mov al, [si]
    cmp al, ' '
    je Word_was_found
    mov bx, di
    jmp Word_searching
    
Buble:                               ;как только достигнут конец строки, возврат счетчика si в начало(к di)
    mov si, di    
    jmp Word_searching


Word_searching:                      ;поиск следующего слова
    inc si                           ;осуществляется до пробела или до конца строки
    mov al, [si]
    cmp al, ' '
    je Word_was_found
    cmp al, '$'
    je End_of_string
    jmp Word_searching

Word_was_found:                      ;было найдено слово
    inc si                           ;переход на начало второго слова
    mov al, [si]
    cmp al, ' ' 
    je Word_was_found
    cmp al, '$'
    je End_of_string
    jmp cmpWords        

End_of_string:                       ;если был достигнут конец строки, перестановка счетчика di к следующему слову для сравнения
    inc di
    mov al, [di]
    cmp al, ' '
    je If_spaces                     
    cmp al, '$'
    je End_of_sort                   ;если достигнут конец строки счетчиком di, то завершение сортировки
    jmp End_of_string

If_spaces:                           ;Пропуск пробелов
    inc di
    mov al, [di]
    cmp al, ' '
    je If_spaces
    jmp Buble
    
cmpWords:                            ;начало сранения строк, где di указывает на начало первого слова, а si на начало второго
    mov bx, di                                                                                                
    mov dx, si
    
Compare:                                                                                                  
    mov al, [bx]
    mov ah, [si]
    cmp al, ah
    ja Search_end_of_second_word            ;переход к поиску конца второго слова для последующего реверса
    cmp al, ah
    je Next_byte                     ;если первые символы обоих слов одинаковы
    cmp al, ah
    jb Word_searching                ;если перестановка слов не требуется

Swap:
    dec si
    mov bx, di
    push si                          ;в стек заносится конец второго слова
    push di                          ;начало первого
    
Reverse_1:                           ;реверс всего промежутка между первым и вторым словом
    cmp di, si
    jae End_reverse_1
    
    mov al, [di]
    mov ah, [si]
    
    mov [si], al
    mov [di], ah
    
    inc di
    dec si                             
    jmp Reverse_1    
    
End_reverse_1:                       ;завершение первого реверса
    pop di                           ;считывается со стека начало первого слова
    pop si                           ;конец второго
    push si                          ;помещение в стек конец второго слова
    push di                          ;начало первого
    mov di, si

Find_start_of_second_word:           ;Поиск начала второго слова
    dec di
    mov al, [di]
    cmp al, ' '
    jne Find_start_of_second_word
    
    inc di
    push di                          ;занесение в стек начала второго слова
    
Reverse_2:                           ;реверс второго слова
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
    pop si                            ;считывание в si начало второго слова
    dec si
    pop di                            ;в di начало первого
    push di                           ;занесение di в стек
    
Find_start_of_part_between_words:     ;поиск начала части строки между первым и вторым словом
    inc di
    mov al, [di]
    cmp al, ' '
    jne Find_start_of_part_between_words
    
    push di        
    
Reverse_3:                            ;реверс части строки между двумя словами
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
    pop si                           ;считывание в si конца первого слова
    dec si
    pop di                           ;в di начало первого
    push di                          ;занесение в стек di
    
Reverse_4:                           ;реверс первого слова
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
    pop di                           ;считывание начала первого слова
    pop si                           ;считывание конца второго слова
    jmp Word_searching    
    
Search_end_of_second_word:                  ;поиск конца второго слова
    inc si
    mov al, [si]
    cmp al, ' '                      ;если конец найден, то свап
    je Swap
    cmp al, '$'
    je Swap
    jmp Search_end_of_second_word 
 
Next_byte:                           ;если символы обеих слов одинаковы
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
             
End_of_sort:                         ;завершение сортировки
      
    print_str_macro sortedStr        
    print_str_macro string+2 
    
    jmp End_of_work 
    
Empty_line:
    print_str_macro Error_line
    
End_of_work:    	                 ;завершение работы 

	mov ax, 4c00h
    int 21h
    
.data 
    EnterLine db "Enter string:", 0Dh, 0Ah, '$'
    sortedStr db 0Dh, 0Ah, "Sorted string:", 0Dh, 0Ah, '$'
	Error_line db 0Dh, 0Ah, "Empty line!", '$'
	string db size,?,size dup ('$')  
	
	size equ 200    
    
end main  

