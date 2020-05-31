My_segment SEGMENT  
    
ASSUME SS:My_segment,DS:My_segment,CS:My_segment,ES:My_segment
.386   

org 80h                                 ;Смещение 80h от начала PSP для получения парметров
Command_length                  db ?    ;Длина командной строки
Comand_line                     db ?    ;Сама командная строка
org 100h                                ;Начало программы от конца PSP
   
;/--------------------------start------------------------------------/   
start: 
	JMP Parsing_cmd_lines                 
     
Old_interrupt_09h               dd 0    ;Адрес старого 09h
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
    call Getting_param_from_command_line ;Получение нового обработчика
    call Check_file 

Install_handler:	
	cli                                 ;Запретить прерывания
	mov ah, 35h
	mov al, 09h                         ;Получить в ES:BX адрес старого обработчика 09h    
	int 21h                     
	
	mov word ptr cs:Old_interrupt_09h,bx   ;Смещение обработчика
	mov word ptr cs:Old_interrupt_09h+2,es ;Сегмент обработчика
	
	mov ah, 25h                         ;Установка нового обработчика
	mov al, 09h                         
	lea dx, New_handler                 ;Обработчика прерывания int 09h
	int 21h 
	sti                                 ;Разрешить прерывания
  	
	mov ah, 09h                         ;Резидент загружен
	lea dx, Resident_str                
	int 21h 
 
    mov dx, offset Parsing_cmd_lines    ;Адрес первого байта за резидентным участком программы
    int 27h                             ;Завершение, но остаться резидентным

Exit_of_program:	                        
	mov ax, 4c00h
	int 21h

;/--------------------------------------------------------------------/
Print_str_macro macro out_str            ;МАКРОС ПЕЧАТИ СТРОКИ
    pusha
    mov ah,09h
    mov dx,offset out_str
    int 21h 
    popa
endm                                                                               

;/-----------------------------------------------------------------/
Getting_param_from_command_line proc     ;ПОЛУЧЕНИЕ ПАРАМЕТРОВ ИЗ КОМАНДНОЙ СТРОКИ
    cld                                  ;Обнуление флага переноса
	mov bp, sp      	                 ;Сохранение текущей позиции стека bp
	mov cl, Command_length                   
	cmp cl, 1                            ;Если не переданы параметры
	jnle Pars  
	
	Print_str_macro Error_command_line_str  ;Отображение ошибки
	jmp Exit_of_program

Pars:
	mov cx, -1
	mov di, offset Comand_line           ;Передача командной строки

Skip_spaces_:
	mov al, ' '                          
	repz scasb                           ;Сканирование командной строки, пока в ней пробелы
    cmp [si], 0Dh                        ;Пока не конец строки
	je End_getting_param
    
Inc_count_param:	
	dec di                               ;Начало параметра
	push di                             
	inc word ptr Count_args              ;Инкрементирование числа параметров
	cmp Count_args, 2                    ;Проверка на число аргументов
	je Error_par
	mov si, di                           ;Получение начало строки с файлом
	
Get_symbol_by_symbol:
	lodsb                                ;Запись из  DS:SI
	cmp al, 0Dh                          ;Пока не конец строки
	je End_getting_param
	cmp al, ' '                          ;Пока не пробел
	jne Get_symbol_by_symbol

If_end_param:                            ;Если конец параметра	
	dec si                               
	mov byte ptr [si], 0                 ;Занесение 0 в конец
	mov di, si
	inc di
	jmp Skip_spaces_
	
End_getting_param:                       ;Завершение получение параметров
	dec si
	mov byte ptr [si], 0

Copy_filename:                           ;Получение имени файла
	mov cx, 50
	pop si
	lea di, Filename
	repne movsb	   
	ret

Error_par:                              ;В случае ошибки параметра
    Print_str_macro Error_with_arguments_str
	jmp Exit_of_program
		
Getting_param_from_command_line endp

;/----------------------------------------------------------------------/ 
New_handler proc                ;НОВЫЙ ОБРАБОТЧИК
	pushF                       ;Сохранение флагов в стек
	call cs:Old_interrupt_09h   ;Вызов системного обр. прер. 09h   
	cli                         ;Запрет прерываний
	pusha

    mov ah, 01h                 ;Проверка на наличие символов в буфере
    int 16h
   
    mov bh, ah                  
    jz Return_handler
   
    mov ah, 02h                 ;Чтение состояния shift-клавиш
    int 16h
    and al, 4                   ;3 бит маски векторов(CTRL)
    cmp al, 0
    je Return_handler
   
    cmp bh, 19h
    jne Return_handler
    mov ah, 00h
    int 16h      	 
	 
	mov ax,0B800h               ;Получение адреса экрана
	mov ds,ax                   ;Получение адреса для пересылки DS:SI   
	
	mov ax, cs
	mov es, ax

	mov di, offset Buffer_to_console   ;Копирование консоли
	xor si, si
	mov cx, 2000                ;Размера экрана 80х25 
	rep movsw

Work_with_file:	 
    call Filter_buffer          ;Форматирование данных в буфере
	call Open_file              ;Открытие файла
	call Set_position_in_file	
	call Write_buff_into_file	
	call Close_file    
	
Return_handler: 
	popa
	sti
	iret          
	
New_handler endp 
;/------------------------------------------------------------------------/
Filter_buffer proc                  ;ФИЛЬТР БУФЕРА КОНСОЛИ
	mov ax, cs
	mov ds, ax
	mov cx, 2000
	mov di, offset Buffer_to_console
	xor si, si
	xor bl, bl  
	
Buffer_shaping:                     ;Формирование выходного буфера
	mov ah, [di]
	mov Buffer_to_console[si], ah
	cmp bl, 79                      ;Пока не конец строки       
	jne Next_line_buffer
	mov byte ptr Buffer_to_console[si+1], 0Dh ;Занесение перехода на следующую строку
	inc si
	mov bl, -1
	
Next_line_buffer:                   ;Переход на следующую строку в буфере
	inc bl
	inc si
	add di, 2  	
loop Buffer_shaping 

    ret
Filter_buffer endp    

;/------------------------------------------------------------------------/ 
Set_position_in_file proc           ;УСТАНОВКА ТЕКУЩЕЙ ПОЗИЦИИ В ФАЙЛЕ 
    pusha
      
    mov bx, File_id                 ;Передача id файла
    mov al, 02h                     ;Указатель на конец файла
    xor cx, cx                        
    xor dx, dx    
    mov ah, 42h  
    int 21h
    
    jc Error_set                    ;Флаг CF сигнализирует об ошибке
    jmp Success_set                 ;При успешной установки позиции
    
Error_set:
    Print_str_macro Error_moving_str 
    jmp Exit_of_program

Success_set:        
    popa    
    ret
Set_position_in_file endp

;/-----------------------------------------------------------------/
Close_file proc                     ;ЗАКРЫТИЕ ФАЙЛА
    pusha
    
    mov bx, File_id                 ;Идентификатор файла
    xor ax, ax    
    mov ah, 3Eh    
    int 21h
    jc Close_file_fail              ;Если ошибка открытия файла

    popa
    ret 
    
Close_file_fail:
   Print_str_macro File_close_error_str        
   Print_str_macro Unknown_file_id_error_str
   jmp Return_handler
   ret
close_file endp  

;/---------------------------------------------------------------------/
Check_file proc                     ;ПРОВЕРКА НА НАЛИЧИЕ ФАЙЛА
    push cx
    push ax
     
    xor cx, cx 
    mov dx, offset Filename
    mov ah, 3Dh                     ;Функция открытия файла
    mov al, 02h                     ;Режим записи
    int 21h 
    jc File_not
    jmp Closing	

File_not:                           ;Если файл не найден 
    Print_str_macro Create_file_str     
    xor cx, cx
	lea dx, Filename
	mov ah, 3Ch                     ;Создание файла
	mov al, 00h
	int 21h 
    jc Create_file_fail
        
Closing:
    mov File_id, ax 
    call Close_file                 ;Закрытие файла
    pop ax
    pop cx         
    ret

Create_file_fail:
    Print_str_macro File_create_error_str    
    cmp ax, 03h                     
    jne Create_04h
    Print_str_macro Path_not_found_error_str ;Путь не найден
    jmp Exit_of_program

Create_04h:
    cmp ax, 04h
    jne Create_05h   
    Print_str_macro Many_files_error_str ;Много открытых файлов
    jmp Exit_of_program
                            
Create_05h:                             ;Проверка на закрытый доступ
    Print_str_macro Access_denied_error_str
    jmp Exit_of_program           
    
Check_file endp
;/------------------------------------------------------------------/ 
Open_file proc                      ;ОТКРЫТИЕ ФАЙЛА АРГУМЕТОВ 
    push cx
    push ax
       
    xor cx, cx 
    mov dx, offset Filename
    mov ah, 3Dh                     ;Функция открытия файла
    mov al, 02h                     ;Режим записи
    int 21h 
    jc Open_file_fail               ;Если ошибка открытия файла
    	
    mov File_id, ax  
    pop ax
    pop cx
    ret 
    
Open_file_fail:
    Print_str_macro File_open_error_str  ;Вывод сообщения о ошибке       
    cmp ax, 02h                     ;В ах возвращается ошибка 
    jne AX_03h
    Print_str_macro File_not_found_str   ;Файл не найден
    jmp Return_handler  
    
AX_03h:                             ;Проверка на ошибку пути
    cmp ax, 03h 
    jne AX_04h  
    Print_str_macro Path_not_found_error_str
    jmp Return_handler      
    
AX_04h:                             ;Проверка на много открытых файлов
    cmp ax, 04h
    jne AX_05h   
    Print_str_macro Many_files_error_str
    jmp Return_handler
                            
AX_05h:                             ;Проверка на закрытый доступ
    cmp ax, 05h
    jne AX_0Ch 
    Print_str_macro Access_denied_error_str
    jmp Return_handler      
    
AX_0Ch:                             ;Проверка на режим доступа
    Print_str_macro Invalid_access_mode_error_str
    jmp Return_handler
    
    ret               
endp                                                                 

;/------------------------------------------------------------------/
Write_buff_into_file proc           ;ЗАПИСЬ БУФЕРА В ФАЙЛ     
	mov bx, File_id
	mov cx, 2025                    ;80х25 + 25 переходов на новую строку
	lea dx, Buffer_to_console
	mov ah, 40h                     ;Запись в файл
	int 21h                                                   
	
	jc Write_file_fail              ;Если ошибка записи в файл		    
    ret  
     
Write_file_fail:
    Print_str_macro File_write_error_str  ;Вывод сообщения о ошибке       
    cmp ax, 05h                           ;В ах возвращается ошибка 
    jne AX_06h
    Print_str_macro Access_denied_error_str    ;Доступ запрещен
    jmp Return_handler  
    
AX_06h:                             ;Проверка на ошибку пути
    cmp ax, 06h 
    Print_str_macro Unknown_file_id_error_str ;Неверный идентификатор 
    jmp Return_handler
    ret     
Write_buff_into_file endp      

;/-----------------------------------------------------------------/  
My_segment ENDS                     ;Конец сегмента    
end start                           ;Полный конец программы start 
