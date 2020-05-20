name "lab5"
;Вариант 13
.model tiny

.data  
;/----------------------------------------данные-------------------------------------/  
Cmd_line_length         db ?                 ;Командная строка
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

;/------------------------------------макросы---------------------------------------/
Print_str_macro macro out_str       ;МАКРОС ПЕЧАТИ СТРОКИ
    pusha
    mov ah,09h
    mov dx,offset out_str
    int 21h 
    popa
endm  

Close_file_macro macro File_idi      ;ЗАКРЫТИЕ ФАЙЛА
    pusha
    mov bx, File_idi                 ;Передача дескриптора файла
    xor ax, ax                     
    mov ah, 3Eh                      ;Функция закрытия файла
    int 21h          
    popa
endm  

;/----------------------------------start------------------------------------------/
start:
    call Get_argument_from_cmd     ;Получение аргументов из командной строки
    call Open_file                 ;Открытие файла
    mov File_id, ax                ;Получение id файла из ax 
    call Get_size_of_file          ;Получение размера файла
    call Create_new_file           ;Создание нового файла
   
Main_cycle:   
    cmp File_size,0h               ;Если размер файла 0
    je Close_file_and_exit_program    
    call Read_information_from_file;Чтение информации с файла
    call Filter_file_buffer        ;Фильтр буффера
    Print_str_macro File_buffer    ;Печать буфера
    
    call Checking_buffer           ;Проверка и замена слов в буфере 
    Print_str_macro File_buffer
                                                  
    call Write_buf_into_file       ;Запись буфера в файл
    mov ax,Read_bytes
    sub File_size,ax
    
    cmp File_size,0h               ;Пока не начало файла
jne Main_cycle
    
Close_file_and_exit_program: 
    Close_file_macro File_id        ;Закрытие файла 
    Print_str_macro File_closed_str ;Вывод строки о закрытии файла
    Close_file_macro New_file_id       
    
    call Delete_file
     
    xor ax, ax
    mov ah, 56h                         ;Функция переименовывания файла
    lea dx, New_name_of_file
    lea di, Name_of_file
    int 21h       
  
Exit_of_program:                   ;Закрытие программы и проверка было ли найдено хотя бы одно 
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
Get_argument_from_cmd proc   ;ПОЛУЧЕНИЕ АРГУМЕНТОВ ИЗ КОМАНДНОЙ СТРОКИ
    pusha
    cld                      ;Для команд строковой обработки
    
    mov ax,@data             ;Получение сегмента данных
    mov es,ax
    
    xor cx,cx                ;Обнуление регистра
    mov cl,ds:[80h]          ;Смещение 80h от начала PSP
    mov Cmd_line_length,cl   ;Получение длины командной строки
    mov si,82h
    lea di,Cmd_line
    rep movsb                ;Получение командной строки(пересылка строки из DS:SI в ES:DI)

    xor cx,cx                ;Обнуление счетчика
    xor ax,ax
    mov cl,Cmd_line_length   ;Передача командной строки
    
    
    lea si,Cmd_line          ;Передача смещения командной строки
    lea di,Name_of_file      ;Передача смещения названия файла
    call Get_word_from_cmd   ;Получение имя файла из командной строки
    
    
    lea di,Old_word          ;Передача смещения слова, которое нужно заменить
    call Get_word_from_cmd   ;Получение проверяемого слова 
    
    cmp Old_word,'$'         ;Если проверяемого слова нету
    je Error_from_cmd
    push si
    lea si,Old_word          ;Передача смещения старого слова
    call Get_word_size       ;Получение размера заменяемого слова
    
    mov Size_old_word,ax     ;Занесение размера старого слова в переменную
    pop si 
    
    lea di,New_word          ;Передача смещения нового слова
    call Get_word_from_cmd   ;Получение нового слова
    
    cmp New_word,'$'         ;Если не найдено слово
    je Error_from_cmd 
   
    lea si,New_word 
    call Get_word_size       ;Получение размера нового слова
    mov Size_new_word,ax     ;Занесение размера нового слова в переменную
    
    Print_str_macro Cmd_line
    Print_str_macro space
    Print_str_macro Name_of_file
    Print_str_macro space
    Print_str_macro Old_word
    Print_str_macro space
    Print_str_macro New_word
    
    popa
    ret                       ;Выход из процедуры

Error_from_cmd:               ;Если ошибка работы с командной строкой
    Print_str_macro Cmd_error_str
    jmp Exit_of_program     
            
Get_argument_from_cmd endp 

;/-----------------------------------------------------------------------------------------------------/
Get_word_from_cmd proc        ;ПОЛУЧЕНИЕ СЛОВА ИЗ КОМАНДНОЙ СТРОКИ
    push ax
    push cx
    push di 
    xor ax,ax  
    
Skip_spaces:                   ;Пропуск пробелов в командной строке
    mov al,[si]           
    cmp al,' '               
    jne Loop_getting          
    inc si                   
    jmp Skip_spaces              
    
Loop_getting:
    mov al,[si]                  ;Передача символа по смещению командной строки
    
    cmp al,' '                   ;Если пробел
    je End_getting    
    cmp al,09h                   ;Если TAB
    je End_getting    
    cmp al,0Ah                   ;Если новая строка
    je End_getting    
    cmp al,0Dh                   ;Если смещение коретки в начало
    je End_getting    
    cmp al,00h                   ;Если NULL
    je End_getting               ;Завершение чтения строки
    
    mov [di],al                  ;Запись символа в передаваемую строку
    inc si                       ;Инкрементирование регистров
    inc di
loop Loop_getting  

End_getting:
    mov [di],0                   ;Занесение нуля в конец
    inc si
            
    pop di
    pop cx
    pop ax
    ret
Get_word_from_cmd endp

;/---------------------------------------------------------------------------------------/
Get_word_size proc              ;ПОЛУЧЕНИЕ РАЗМЕРА СЛОВА                 
	push bx                     
	push si                   
	                            
	xor ax, ax                  
                                
Counting:                  
	mov bl, [si]           
	cmp bl, 0                    ;Цикл пока не нуль
	je End_counting             
                               
	inc si                  
	inc ax                       ;Инкрементирование длины слова                                              
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
Open_file proc                    ;ПРОЦЕДУРА ОТКРЫТИЯ ФАЙЛА
    push dx
    mov dx,offset Name_of_file    ;Передача названия файла, который следует открыть
    mov ax, 3D02h                 ;3D - функция открытия существующего файла, 02 - режим чтения и записи
    int 21h       
    jc Error_opening_file         ;Если установлен флаг переноса(CF)
    jmp Success_opened 
    
Error_opening_file:          
    Print_str_macro Error_opening_file_str
    pop dx
    jmp Exit_of_program           ;Выход из программы 
    
Success_opened:                   ;Открыт успешно
    Print_str_macro File_opened_str  
    pop dx
    ret
Open_file endp   

;/--------------------------------------------------------------------------------------/
Read_information_from_file proc   ;ЧТЕНИЕ ИНФОРМАЦИИ ИЗ ФАЙЛА
    push bx
    push cx
    push dx
    
    call Set_position_in_file      ;Установка позиции
    
    mov bx, File_id                ;Передача файлового id
    mov ah, 3Fh                                             
    mov cx,Count_reading_byte      ;Кол-во байт для чтения 
    mov dx, offset File_buffer     ;Файловый буфер для данны
    int 21h   
    
    mov Read_bytes, ax             ;Количество фактически прочитанных байтов
    dec ax
    mov Size_of_file_buffer,ax     ;Передача фактического размера буфера
    mov New_buffer_size,ax
    mov Substring_buffer_size,ax 

    mov ax,Count_reading_byte  
    clc                            ;Сброс флага переноса
    add Current_byte_pos_low,ax    ;Получение обрабатываемых байтов
    jc All_low_bytes               ;Если возникло переполнение в 2 байта
    jmp End_reading_file 
    
All_low_bytes:                     ;Инкремент младшего байта
    inc Current_byte_pos_high

End_reading_file:                  ;Завершение чтения файла
    pop dx
    pop cx
    pop bx
    ret
Read_information_from_file endp

;/--------------------------------------------------------------------------------/
Set_position_in_file proc           ;УСТАНОВКА ТЕКУЩЕЙ ПОЗИЦИИ В ФАЙЛЕ 
    pusha
      
    mov bx, File_id                 ;Передача id файла
    mov al, 00h                     ;Указатель на начало файла
    xor cx, cx                        
    mov dx, Current_byte_pos_low    ;Положение смещения по файлу CX:DX  
    mov cx, Current_byte_pos_high        
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

;/-------------------------------------------------------------------------------/
Filter_file_buffer proc            ;ОБРАБОТКА ФАЙЛОВОГО БУФФЕРА
    pusha
    lea si,File_buffer             ;Получение смещения буффера файла
    add si,Count_reading_byte      ;Прибавление смещени
    dec si 
    
Cycle_of_filter:
    cmp [si],'$'                  ;Пока конец строки
    je Filter_is_done
   
    cmp [si],00h                  ;Если начало строки
    je Filter_is_done
   
    cmp [si],' '                  ;Если пробел
    je Filter_is_done
   
    mov [si],'$'                  ;Занесение доллара в конец обрабатываемой строки
    dec si
    dec Current_byte_pos_low      ;Декрементирование текущей позиции в файле
    dec Read_bytes                ;Декрементирование читаемых байтов
    jmp Cycle_of_filter 
                                  ;Завершение фильтрации
Filter_is_done:    
    popa
    ret
Filter_file_buffer endp    
 
;/---------------------------------------------------------------------------/
Get_size_of_file proc             ;ПОЛУЧЕНИЕ РАЗМЕРА ФАЙЛА
    pusha    
    xor cx,cx                     ;Установка регистров в нуль
    xor dx,dx
    mov ah,42h                    ;Перемещениу указателя чтения/записи
    mov al,02h                    ;Перемещение указателя относительно конца файла
    mov bx,File_id                ;Передача id файла
    int 21h 
    mov File_size,ax              ;Получение позиции файла в байтах от начала файла
    popa 
    ret
Get_size_of_file endp  

;/-----------------------------------------------------------------------------/ 
Checking_buffer proc              ;ПОИСК ИСКОМОГО СЛОВА В БУФЕРЕ
    pusha
    lea si,File_buffer            ;Передача смещения файлового буфера

Loop_serching_word:
    mov Starting_position_buf,si  ;Загрузка начальной позиции буфера(будет перезаписываться по циклу)    
    lea di,Old_word               ;Передача смещения старого слова
    mov cx,Size_old_word          ;Передача размера  старого слова
    REPE cmpsb                    ;Повторять пока элеметы равны. Строковое сравнение(DS:SI и ES:DI)
        
    cmp cx,0h                     ;Если CX обнулился, то означает, что слово найдено
    ;je Word_found
    je Check_on_substring
    
Skip_symbol:               ;;;;;;;;;;;;;;;;;;;;
    sub cx,Size_old_word
    not cx                        ;Перевод в обратный код
    inc cx                        ;Получение размера слова
    sub New_buffer_size,cx 
    sub Substring_buffer_size,cx  ;Пересчет длины буфера относительно проверенного участка
    
    cmp File_size,0h              ;Если достигнуто начало файла
    je If_end_buffer    
    lea di,Punctuation_marks      ;Загрузка смещения знаков препинания
    
Loop_skip_punctuation:            ;Цикл пропуска всех знаков препинаний
    cmpsb                         ;Если встретился знак препинания 
    je Loop_serching_word
                                  
    dec si                        ;Уменьшение буфера
    cmp [si],'$'                  ;Если достигнут конец строки
    je If_end_buffer
    
    cmp [si],0                    ;Если достигнут конец буфера(конечный символ 0)    
    je If_end_buffer
    
    cmp [di],0Ah                  
    je Loop_serching_word
jne Loop_skip_punctuation 

Check_on_substring:               ;Проверка что после нахождения слова следующий символ не является буквой 
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
    
    jmp Skip_symbol               ;Если всё же буква(найденое слово является подстрокой)

This_is_word:                     ;Слово найдено
	pop si
    jmp Word_found
    
Check_on_symbol_before_word:      ;Проверка нет ли букв до найденного слова
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
   
Word_found:                       ;Когда нужное слово найдено
    Print_str_macro Word_was_found_str   
    call Edit_buf_length          ;Получение новой длины буфера
    mov Check_byte, 1             ;Флаг того, что слово найдено
    
    call Change_old_word_to_new             
    cmp File_size,0h              ;Если не начало, то переход в цикл 
    je If_end_buffer
    jne Loop_serching_word  
    
If_end_buffer:
    dec si                        ;Уменьшение значения положения файового буфера
    cmp [si],00h                  ;Если достигнуто начало буфера - выход
    je End_check 
    jne Clear_buffer  

End_check:                        ;Завершение проверки
    mov File_size,0h
    mov cx,Size_old_word          ;Передача размера старого слова
    sub cx,Size_new_word           
    sub si,cx
    dec si       
    
Clear_buffer:                     ;Очистка буфера
    mov [si],0h
    inc si
loop Clear_buffer       
    popa
    ret
Checking_buffer endp    

;/-----------------------------------------------------------------------------/
Update_info_buf_size proc           ;ОБНОВЛЕНИЕ ИНФОРМАЦИИ О РАЗМЕРЕ ФАЙЛОВОГО БУФЕРА
    pusha
    lea si,File_buffer              ;Получение смещения файлового буфера
    mov Size_of_file_buffer,000h    ;Обнуление размера файлового буфера
    
Loop_update_size:
    inc si
    inc Size_of_file_buffer         ;Подсчет размерности
    cmp [si],00h                    ;Если не конец буфера
     
    jne Check_on_end_buf            ;Если не конец файла
    jmp End_update_size     
    
Check_on_end_buf:    
    cmp [si],'$'
    jne Loop_update_size
    mov [si],00h                    ;Занесение нуля в конец буфера
    jmp End_update_size 
    
End_update_size:                    ;Завершение подсчета
    popa
    ret
Update_info_buf_size endp     

;/----------------------------------------------------------------------------------/       
Change_old_word_to_new proc             ;ЗАМЕНА СТАРОГО СЛОВА НА НОВОЕ
    mov si,Starting_position_buf        ;Передача позиции с которой следует производить замену
    mov di,si
    mov cx,Size_new_word                ;Передача размера нового слова
    
Check_start_pos:
    cmp [si],' '                        ;Если позициия равна пробелу
    je Word_is_changed                  ;Завершение замены
    cmp [si],'!'
    je Word_is_changed
    cmp [si],09H                        ;Если позиция равна ТАВ
    je Word_is_changed  
    
Get_pos_end_word:                       ;Получение позиции конца слова
    cmp [si],0Dh                        ;Если встретился переход на новую строку    
    je If_met_enter
    inc si                              ;Инкремент позиции в буфере
    dec Substring_buffer_size           ;
    cmp [si],00h
    je End_of_word_was_found            ;Если не восклицательный знак
    cmp [si],'!'
    je End_of_word_was_found            ;Если не ТАВ
    cmp [si],09H 
    je End_of_word_was_found            ;Если не запятая
    cmp [si],','                        
    je End_of_word_was_found            ;Если не пробел
    cmp [si],' '
    jne Get_pos_end_word 
    
End_of_word_was_found:      
    mov ax, Size_old_word                       
    cmp Size_new_word,ax
    ja Add_to_right                     ;Если новое слово по размеру больше
    cld                                 ;Сброс флага направления
    jmp Add_to_left                     ;Если меньше
    
Add_to_right:                           ;Добавление слова вправо(если новое слово больше)
    mov Substring_buffer_size,0h
    
Loop_find_end_buf_right:                ;Цикл поиска конца буфера и подсчета длины подстроки для переноса
    inc si
    inc Substring_buffer_size                             
    cmp [si],00                         ;Поиск конца строки
    jne Loop_find_end_buf_right
    mov cx,Substring_buffer_size        ;Получение размера буфера подстроки(той части буфера, которая будет переносится)
    inc cx
    mov di,si                           ;Передача позиции окончания строки
    add di,Size_new_word
    sub di,Size_old_word                ;Прибавление разности размеров слов для смещения
    
    std                                 ;Установка флага направления(направление в обратную сторону)
    jmp Substring_wrapping   
    
Add_to_left:                            ;Добавление слова влево(если новое слово меньше)
    cmp [si],00h                        ;Если конец строки
    je Substring_wrapping 
    push si
    mov Substring_buffer_size,0h 
    
Loop_find_end_buf_left:                 ;Цикл поиска конца буфера и подсчета длины подстроки для переноса 
    inc si
    inc Substring_buffer_size
    cmp [si],00
    jne Loop_find_end_buf_left
    mov cx,Substring_buffer_size
    pop si
    add di,Size_new_word                ;Добавление смещения нового Слова
    
Substring_wrapping:    
    repe movsb                          ;Смещение буфера для вставки нового слова
    mov ax,Size_of_file_buffer
    add ax,Size_new_word
    sub ax,Size_old_word
    mov Size_of_file_buffer,ax          ;Перезапись фактического размера файлового буфера
    cld                                 ;Сброс флага переноса

Insert_new_word:    
    lea si,New_word                     ;Получение смещения нового слова
    mov di,Starting_position_buf        ;Передача начальной позиции буфера
    mov cx,Size_new_word
    repe movsb                          ;Копирование новой строки на место старой
    
    xchg si,di                          ;Команда обмена (возврат текущей позиции в файле в si)    
    jmp Word_is_changed
        
If_met_enter:                           ;Если встретился ENTER
    inc si
    dec Substring_buffer_size
    jmp Get_pos_end_word
          
Word_is_changed:                        ;Завершение
    ret
Change_old_word_to_new endp  

;/--------------------------------------------------------------------/
Create_new_file proc                    ;СОЗДАНИЕ РЕЗУЛЬТИРУЮЩЕГО ФАЙЛА
    pusha
    mov ah, 5Ah                         ;Функция создания файла
    mov cx, 0h                          ;Только для чтения
    lea dx, New_name_of_file
    int 21h
    mov New_file_id, ax                 ;Получение id нового файла
              
    popa
    ret
Create_new_file endp

;/--------------------------------------------------------------------/
Rename_file proc                        ;ПЕРЕИМЕНОВЫВАНИЕ ФАЙЛА
    pusha
    xor ax, ax
    mov ah, 56h                         ;Функция переименовывания файла
    lea dx, New_name_of_file
    lea di, Name_of_file
    int 21h             
    popa
    ret
Rename_file endp  

;/--------------------------------------------------------------------/
Delete_file proc                        ;УДАЛЕНИЕ ФАЙЛА
    pusha
    mov ah, 41h                         ;Функция удаления файла
    lea dx, Name_of_file
    int 21h             
    popa
    ret
Delete_file endp 

;/--------------------------------------------------------------------------------/
Edit_buf_length proc                 ;ПОЛУЧЕНИЕ ЗНАЧЕНИЯ ОБ ИЗМЕНЕНИИ ДЛИНЫ БУФЕРА
    pusha
    mov ax,New_buffer_size           ;Получение нового размера буфера
    sub ax,Size_old_word
    add ax,Size_new_word
    mov New_buffer_size,ax           ;Получение нового размера буфера
    popa
    ret
Edit_buf_length endp 

;/------------------------------------------------------------------------------/
Write_buf_into_file proc             ;ЗАПИСЬ ПОЛУЧЕННОГО БУФЕРА В НОВЫЙ ФАЙЛ
    pusha 
    
    mov bx, File_id
    mov al, 00h                      ;Начальная позиция файла
    xor cx, cx                       ;Обнуление счетчика
    
    mov dx, New_byte_pos_low         
    mov cx, New_byte_pos_high         
    mov ah, 42h                       ;Установка позиции по новому файлу адрессу CX:DX   
    int 21h
    
    mov ah,40h                        ;Функция записи в файл
    mov bx,New_file_id                ;Получение идентификатора файла
    call Update_info_buf_size         ;Получение обновленной информации о размере буфера
    mov cx,Size_of_file_buffer        ;Число байтов для записи

    lea dx,File_buffer                ;Адресс буфера данных
    int 21h
    
    call Buffer_clearing              ;Очистка буфера
         
    clc                               ;Обнуление флага переноса
    add New_byte_pos_low,cx 
    jc Add_new_low_byte               ;Если возникло переполнения в 2 байта, то добавление младшего разряда
    jmp End_writing
    
Add_new_low_byte:
    inc New_byte_pos_high
    mov New_byte_pos_low,0h     
    
End_writing:                          ;Завершение записи
    popa
    ret
Write_buf_into_file endp                                         

;/----------------------------------------------------------------------------------/  
Buffer_clearing proc                   ;ОЧИСТКА БУФЕРА 
    pusha
    lea si,File_buffer                 
    mov cx,200 
    
Loop_clear:                            ;Очистка побайтово буфера
    mov [si],'$'
    inc si
loop Loop_clear
    
    mov Size_of_file_buffer,0h         ;Обнуление размерности буфера
    popa
    ret
Buffer_clearing endp    


end start 

