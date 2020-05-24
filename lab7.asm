name 'lab7'    ; 5 вар

.model tiny 
org     100h  
.data 

eof                                 db 0
Parametrs_length                    equ 128
Counter                             db 0
Parametrs_of_file                   db Parametrs_length dup(0)
Close_file_str                      db 0Ah,"Close file with arguments",'$'   
;/-------------------------------ошибки----------------------------------------------/
File_open_error_str                 db 0Ah,"Error - opening file ",'$' 
File_read_error_str                 db 0Ah,"Error - reading file ",'$' 
New_program_error_str               db 0Ah,"Error - starting another programm ",'$'
Error_command_line_str              db 0Ah,"Error - could't get file name from cmd arguments",'$'    
File_not_found_str                  db "Error - file not found",'$'
Path_not_found_error_str            db "Error - path not found",'$'
Many_files_error_str                db "Error - Many files opened",'$'
Access_denied_error_str             db "Error - access denied",'$'
Invalid_access_mode_error_str       db "Error - invalid access mode",'$' 
Wrong_file_id_error_str             db "Error - wrong handle",'$'  
Memory_error_str                    db "Error - Not enough memory",'$'  
Surrounding_error_str               db "Error - wrong surrounding",'$' 
Wrong_format_error_str              db "Error - Wrong format",'$' 

Filename                            db 126 dup(0) 

Counting_reading_bytes              dw 1                   
File_id                             dw 0  
        
epb label byte                             
New                                 equ "laba5.com"
EnvSeg                              dw ?
For_cmd_param                       dd ?
FCB_1                               dd ?
FCB_2                               dd ?
New_program                         db New,0 

Data_size=$-eof                     ;Размер сегмента данных   

                                                          
.code
;/---------------------------------------------------------------------------/
start:       
     mov ah, 4Ah                        ;Перезапись размера блока выделяемой памяти под программу
     mov bx, ((Code_size/16)+1)+((Data_size/16)+1)+32
     int 21h    
      
     mov ax, @data 
     mov es, ax     
     
     call Getting_name_of_file          ;Парсинг командной строки
     mov ds, ax
      
     call Check_name_of_file            ;Проверка файлового названия   
    
     mov dx, offset Filename
     call Open_file                     ;Открытие файла
     mov File_id, ax                    ;Получение идентификатора файла
    
     call Getting_param_from_file       ;Получение параметров из файла
    
Work_with_epb:    
     push es
     push ds
     push ss
     push sp  
               
     mov ax, ds:[2Ch]                   ;Получение сегментного адреса копии окружения для процесса
     mov [EnvSeg], ax    
     mov ax, cs                         ;Получение сегмента psp в ах
     mov word ptr[FCB_1], 005Ch         ;Получение адреса первого FCB, заполняемый из первого аргумента командной строки
     mov word ptr[FCB_1+2],ax
     mov word ptr[FCB_2], 006Ch         ;Получение адреса второго FCB, заполняемый из второго аргумента командной строки
     mov word ptr[FCB_2+2],ax
     mov word ptr[For_cmd_param],offset Parametrs_of_file  ;Получение параментров для нового процесса
     mov word ptr[For_cmd_param+2],ax 
     
     call Execute_new_program           ;Выполнение новой программы
               
     pop sp
     pop ss
     pop ds
     pop es       
    
Close_file:                             ;Закрытие файла   
    Close_file_macro File_id                 

Exit_of_program:                        ;Завершение работы    
    mov ah, 4Ch
    int 21h        

;/-------------------------------------------------------------/
Execute_new_program proc                ;ЗАПУСК И ВЫПОЛНЕНИЕ НОВОЙ ПРОГРАММЫ      
     mov ax, 4B00h                      ;Загрузить и выполнить программу
     lea dx, [New_program]                ;Адресс с именем программы
     lea bx, [epb]                      ;Адресс блока параметров EPB
     int 21h
     jc Error_from_new_program          ;Ошибка выполнения  
     ret

Error_from_new_program:                 ;В случае ошибки выполнения              
    Write_str_macro New_program_error_str        
    cmp ax, 02h   
    jne 05h_err
    Write_str_macro File_not_found_str  ;Не найден файл
    jmp Close_file     
    
05h_err: 
    cmp ax, 05h 
    jne 08h_err 
    Write_str_macro Access_denied_error_str ;Доступ запрещен
    jmp Close_file      
    
08h_err:  
    cmp ax, 08h
    jne 0Ah_err   
    Write_str_macro Memory_error_str        ;Нехватка памяти
    jmp Close_file

0Ah_err:  
    cmp ax, 0Ah
    jne 0Bh_err   
    Write_str_macro Surrounding_error_str   ;Нехватка памяти
    jmp Close_file    
    
0Bh_err:                                      
    Write_str_macro Wrong_format_error_str  ;Неправильное окружение или формат
    jmp Exit_of_program
    ret               
Execute_new_program endp              

;/-----------------------------------------------------------/ 
Close_file_macro macro File_id      ;ЗАКРЫТИЕ ФАЙЛА
    Write_str_macro Close_file_str 
    mov bx, File_id 
    mov ah, 3Eh
    int 21h      
endm       

;/-----------------------------------------------------------/
Write_str_macro macro String        ;МАКРОС ВЫВОДА СТРОКИ
    push ax
    mov dx, offset String
    mov ah, 09h
    int 21h      
    pop ax
endm 
 
;/---------------------------------------------------------/
Skip_spaces macro Str               ;ПРОПУСК ПРОБЕЛОВ
    LOCAL Skip_space
    sub Str, 1

Skip_space:             
    inc Str                         ;Пропуск пробела
    cmp [Str], ' ' 
    je Skip_space
endm

;/----------------------------------------------------------/
Getting_word_cmd macro String       ;ПОЛУЧЕНИЕ СЛОВА ИЗ КОМАНДНОЙ СТРОКИ
    LOCAL Getting_word_loop
    mov di, offset String 

Getting_word_loop:                  ;Получение
    movsb
    cmp [si], 0Dh                   ;Если конец строки      
    je Command_line_end
    
    cmp [si], ' '                   ;Если пробел
    jne Getting_word_loop
       
endm
;/----------------------------------------------------------------/
Getting_name_of_file proc           ;ПОЛУЧЕНИЕ ФАЙЛА ИЗ КОМАНДНОЙ СТРОКИ
    pusha
	mov si, 82h                     ;Установка указателя на начало командной строки
	cmp [si],0
	jne Continue_getting_file_name
        
    Write_str_macro Error_command_line_str  ;Отображение ошибки
    jmp Exit_of_program 
    
Continue_getting_file_name:		
	mov si, 82h             	
    Skip_spaces si          
	Getting_word_cmd Filename       ;Получение файла с аргументами    
	
Command_line_end:	    
    popa
    ret
endp

;/------------------------------------------------------------------/ 
Open_file proc                      ;ОТКРЫТИЕ ФАЙЛА АРГУМЕТОВ
    xor cx, cx 
    xor al, al
    mov ah, 3Dh                     ;Функция открытия файла
    mov al, 00h                     ;Режим чтения
    int 21h 
    jc Open_file_fail               ;Если ошибка открытия файла
    ret 
    
Open_file_fail:
    Write_str_macro File_open_error_str  ;Вывод сообщения о ошибке       
    cmp ax, 02h                     ;В ах возвращается ошибка 
    jne AX_03h
    Write_str_macro File_not_found_str   ;Файл не найден
    jmp Close_file  
    
AX_03h:                             ;Проверка на ошибку пути
    cmp ax, 03h 
    jne AX_04h  
    Write_str_macro Path_not_found_error_str
    jmp Close_file      
    
AX_04h:                             ;Проверка на много открытых файлов
    cmp ax, 04h
    jne AX_05h   
    Write_str_macro Many_files_error_str
    jmp Close_file
                            
AX_05h:                             ;Проверка на закрытый доступ
    cmp ax, 05h
    jne AX_0Ch 
    Write_str_macro Access_denied_error_str
    jmp Close_file      
    
AX_0Ch:                             ;Проверка на режим доступа
    Write_str_macro Invalid_access_mode_error_str
    
    ret               
endp  

;/----------------------------------------------------------------/
Check_name_of_file proc             ;ПРОВЕРКА НАЗВАНИЯ ФАЙЛА   
    cmp [Filename],0Dh
    je Exit_of_program
    ret
endp

;/-----------------------------------------------------------/
Reading_file macro File_id          ;ЧТЕНИЕ ФАЙЛА
    mov bx, File_id 
    mov cx, Counting_reading_bytes
    mov dx, di                      ;Адрес буфера приёма данных
    mov ah, 3Fh                     ;Чтение
    int 21h    
endm

;/-----------------------------------------------------------------/
Getting_param_from_file proc        ;ПОЛУЧЕНИЕ ПАРАМЕТРОВ ИЗ ФАЙЛА
    pusha
    
    mov di, offset Parametrs_of_file
    inc di 

Reading:
    cmp Counter, 127
    je Getting_param_complete
    
    inc di 
    Reading_file File_id
    jc Failed_reading               ;В случае ошибки
    cmp ax, 0                       ;Если параметры закончились
    je Getting_param_complete 
    inc Counter
    
    cmp [di], 0Dh                   ;Если завершилась строка
    je End_of_line
    cmp [di], 0Ah                   ;Если завершилась строка
    je End_of_line    
jmp Reading
    
End_of_line:                        ;Если конец строки
    mov [di], ' '   
    mov dx, 1                       ;Указатель на сколько нужно переместить указатель
    xor cx, cx 
    mov bx, File_id
    mov al, 01h                     ;Перемещение указателя относительно текущей позиции на один байт
    mov ah, 42h
    int 21h
    jmp Reading    

Failed_reading:                     ;Ошибка чтения
    Write_str_macro File_read_error_str
    cmp ax, 05h                     ;Проверка на закрытый доступ
    jne Wrong_handler 
    
    Write_str_macro Access_denied_error_str
    jmp Close_file                  ;Закрытие файла
     
Wrong_handler:                      ;Неверный дескриптор
    Write_str_macro Wrong_file_id_error_str
    jmp Close_file
    
Getting_param_complete:             ;Завершение параметров          
    mov [di], 0Dh
    mov dl, Counter
    mov Parametrs_of_file[0], dl
    inc eof
    popa
    ret
endp 

Code_size = $ - start               ;Размер сегмента кода
end     main 