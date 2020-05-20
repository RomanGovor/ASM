name 'lab3'

.model small
.stack 100h  
.code    

jmp start

Output_string_proc proc                ;Процедура вывода строки
    mov ah, 09h
    int 21h
    ret
Output_string_proc endp
                        
                        
                        
Input_array_length_proc proc           ;Процедура ввода размерности массива
    mov cx, 1 
    
Input_array_length_loop:
    mov dx, offset Input_lenght_str                
    call Output_string_proc
                 
    push cx
    call Input_element_proc            ;Вызов процедуры ввода элемента
    pop cx
    
    cmp size_,0
    jle Length_error                   ;Если меньше 0  
    
    cmp size_,30 
    jg Length_error                    ;Если больше 30
    
    jmp End_input_length

loop Input_array_length_loop 
                                       ;Если не подходящее значение
Length_error:
    ;xor ax,ax
    inc cx

    jmp Input_array_length_loop 
    
End_input_length:

ret
endp
          
       
Bubble_proc proc near        ;Процедура сортировки
    New_array equ di           
    cmp cx, 1
    jle End_of_sort          ;Если в массиве 1 элемент
    mov dx, si               
    dec cx                   
    
First_cicle:
    push cx                  
    mov bx, size_
    add bx, dx               
    dec bx                   ;Смещение буфера + size_ - 1
    
    sub bx, si
    mov cx, bx
    mov di, dx               ;Получение индекса на первое число буфера
    
Second_cicle:
    mov ax, New_array[di+2] 
    cmp New_array[di], ax  
    jle Return_to_loop       ;Если второе значение массива больше первого, то переход
    
Swap:                        ;Замена
    mov bx, New_array[di]
    mov ax, New_array[di+2]
    mov New_array[di], ax
    mov New_array[di+2], bx 
   
Return_to_loop:    
    add di,2                 ;Шаг по 2 байта второго внутреннего цикла
loop Second_cicle 
    inc si
    pop cx
loop First_cicle   
    
End_of_sort:
    ret                      ;Возврат из процедуры
endp Bubble_proc

       
       
       
       
Output_array_proc proc near
    push bp                  ;Помещение вершины регистров стека
    mov bp, sp 
    
Print_array:
      mov ax, ds:[di]        ;Загрузка элемента в регистр
      mov bx, ds:[di]
      cmp bx, 0              ;Если нуль, то печать 
      jne Turn_over  
      
      mov dl, bl              
      mov ah, 2
      add dl, 30h            ;Прибавление 48 и запись в ax
      int 21h   
      
      mov dl, 020h           ;Добавление пробела
      add di,2
      int 21h 
       
      loop Print_array
      jmp end_print_array  
     
add_minus:
      push ax                 ;Занесение в стек значения по ax
       
      mov ah, 2
      mov dl, '-'             ;Занесение в ах минуса
      int 21h     
      
      pop ax                  ;Возврат ах из стека
      neg ax
      jmp end_add_minus  
      
Turn_over:
      neg ax                  ;Изменение знака числа на противоложный
      jns add_minus           ;Если отсутствует знак(положительное), то следует добавить минус
      
end_add_minus:       
      neg ax    
      
sign2:       
      neg bx                  ;Изменение знака bx на протиположный
      js sign2                ;Пока минус
      push cx                 ;Занесение в стек фактического размера массива
      mov si, 0               ;Счетчик разрядов цифр в числе
      xor dx, dx              ;Обнуление dx
      push bx                 
      mov bx, 10              ;Делитель разряда
      mov cx, 5               ;Максимальное количество разрядов
      
Size_of_number:               ;Получение размера байтов числа
      cmp ax, 10              ;Если значение меньше 10
      jl Increment_counter_of_actual_size
      div bx                  ;Деление значения аккумулятора на bx c записью в приемник
      xor dx, dx
      inc si                  ;Инкрементация si
loop Size_of_number           ;Пока cx
      
Increment_counter_of_actual_size: 
    pop bx                    ;Считывание значения регистра базы
    inc si   
       
Getting_number:     
      mov ax, bx 
      mov cx, si              ;Записывание в счетчик значения кол-ва разрядов числа
      dec cx 
      push bx
      mov bx, 10              ;Присваиваем дельтель разряда
      
Div_on_ten:                   ;Деление разряд на 10
     cmp cx, 0                ;Если значение счетчика разряда 0
     je End_of_div
     div bx                   ;Деление аккумулятора на bx с записью в приемник
     xor dx, dx               ;Обнуление остатка
     loop Div_on_ten  
     
End_of_div:                   ;Завершение деления разряда
     push ax                  ;Заносим в стек значение
     mov dl, al
     mov ah, 2
     add dl, 30h              ;Прибавляем к аскикоду 48
     int 21h  
     
     pop ax
     mov cx, si               ;Получаем разряд следующей цифры числа
     dec cx   
     
Inverse_multi:
    cmp cx, 0                 
    je Completed_inverse_multi
    mul bx
loop Inverse_multi 
     
Completed_inverse_multi: 

   pop bx
   sub bx, ax   
   dec si                      ;Уменьшение разряда числа на 1
   cmp si, 0                   ;Если разряды числа закончились
   jne Getting_number          ;Полчение следующего разряда числа
    
   pop cx                      ;Получение из стека размера массива
   add di,2                    ;Шаг массива 2 байта 
   mov ah, 2
   mov dl, 020h                ;Записывание пробела в аккумулятор
   int 21h  
      
loop Print_array  
   
end_print_array:
    mov sp, bp 
    pop bp
    ret  
Output_array_proc endp         ;Завершение вывода      



                               ;/*----------------------------INPUT LENGTH--------------------------------------------*/ 

Input_element_proc proc near
    push bp                    ;Помещение вершины регистров стека
    mov bp, sp 

Entering_number1: 
    xor bx, bx                  ;Обнуляем значение регистра базы 
    
    mov ah, 0Ah     
    mov offset buffer1, buf_size_length ;Выделяем под буфер максимальный размер
    mov dx, offset buffer1
    int 21h                     ;Вводим строку
    
    mov dx, 0   
    mov si, 2 
    cmp buffer1[si], 0Dh         ;Проверка на конец строки
    je Uncorrect_value1
     
    cmp buffer1[si], '-'         ;Если встретился минус
    je Uncorrect_value1
      
    cmp buffer1[si], '0'         ;Если нуль
    je only_zero_check1
     
    jmp Validating_value1  
    
only_zero_check1:                
    cmp buffer1[si+1],0          ;Если не конец строки
    je Uncorrect_value1
    
    cmp buffer1[si+1], 0Dh       ;Если не конец строки
    jne Next_byte1
    je Uncorrect_value1  
     
Validating_value1:               ;Проверка полученного числа
    cmp buffer1[si], 0Dh         ;Если конец числа
    je Number_processing1
    cmp buffer1[si], '9'         ;Если аскикод символа больше 9
    jg Uncorrect_value1
    cmp buffer1[si], '0'         ;Если аскикод символа меньше 0
    jl Uncorrect_value1
    inc dx                       ;Инкрементируем число байтов числа
       
Next_byte1:                      ;Следующий байт
    inc si
    jmp Validating_value1   
    
Number_processing1:              ;Обработка числа
     cmp dx, 2
     jl Small_number1            
     mov si, 2 
     
If_positivie_number1:            ;Если положительное число
     cmp buffer1[si], '3'        ;Посимвольное сравнение буфера
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
    jne Convertation_on_number1  ;Если не нулевое
    inc si 
                           ;/*----------------convertation---------------*/
Convertation_on_number1:         ;Конвертация
    cmp buffer1[si], 0Dh         ;Если достигнут конец буффера
    je Сonversion_completion1
    xor ax, ax                   ;Обнуление регистра
    mov al, buffer1[si]          ;Запись символа
    sub ax, 30h                  ;Отнимаем аски символ 0
   
    push cx
    mov cx, dx  
    push dx   
    push bx                     ;Заносим в стек фактическое значение числа
    mov bx, 10  
    
Mul_on_ten1:                     ;Получение количества разрядов числа
    cmp cx, 0
    je End_of_mul1
    mul bx                      ;Умножение AX на BX с записью в приемник
    dec cx                      ;Уменьшение количества разрядов
    jmp Mul_on_ten1 
     
End_of_mul1:                     ;Завершение получения кол-ва разрядов
    pop bx                      ;Получение значения
    pop dx                      ;
    dec dx                      ;Уменьшение счетчика
    pop cx
    inc si                      ;Инкрементируем счетчик
    add bx, ax                  ;Прибавляем полученные аккумулятор к разрядному bx
    jmp Convertation_on_number1 
                                 ;/*---------------------------------------*/
Сonversion_completion1: 
    mov si, 2
    
Positive_value1:                 ;Если положительное значение
    pop cx                       ;Считываем размерность массива
    mov size_,bx
    
    jmp End_input_element
    
Uncorrect_value1:   
    mov dx, offset Error_lenght_str               
    call Output_string_proc
        
    mov ax, '$' 
    mov dx, offset buffer1       ;Занесение конца строки
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
    
    mov cx, size_                ;Передаем в регист счетчика размер массива
    mov di, 0  
    
Entering_number: 
    xor bx, bx                  ;Обнуляем значение регистра базы 
    
    mov ah, 0Ah     
    mov offset buffer, buf_size ;Выделяем под буфер максимальный размер
    mov dx, offset buffer
    int 21h                     ;Вводим строку
    
    push cx                     ;Заносим в стек размер массива
    mov dx, 0   
    mov si, 2 
    cmp buffer[si], 0Dh          ;Проверка на конец строки
    je Uncorrect_value 
    cmp buffer[si], '-'         ;Если встретился минус
    je If_minus  
    cmp buffer[si], '0'         ;Если пустая или конец
    je only_zero_check 
    jmp Validating_value  
    
If_minus:                       ;Если встретился минус
    inc si
    cmp buffer[si], 0Dh
    je Uncorrect_value
    cmp buffer[si], '0'         
    je Next_byte 
    jmp Validating_value  
    
only_zero_check:                ;Если встретился нуль или конец
    cmp buffer[si+1], 0Dh        ;Если не конец строки
    jne Next_byte 
    xor bx, bx                  ;Обнуление регистра
    mov bl, buffer[si] 
    sub bl, 30h 
    mov array[di], bx   
    
    mov ah, 2
    mov dl, bl                  ;Запись символа в dl
    int 21h
    
    add di, 2                   ;Шаг в 2 байта
    loop Entering_number  
     
Validating_value:               ;Проверка полученного числа
    cmp buffer[si], 0dh
    je Number_processing
    cmp buffer[si], '9'         ;Если аскикод символа больше 9
    jg Uncorrect_value
    cmp buffer[si], '0'         ;Если аскикод символа меньше 0
    jl Uncorrect_value
    inc dx                      ;Инкрементируем число байтов числа
       
Next_byte:                      ;Следующий байт
    inc si
    jmp Validating_value   
    
Number_processing:              ;Обработка числа
     cmp dx, 5
     jl Small_number            ;Если меньше 5 символов
     mov si, 2 
     cmp buffer[si], '-'        ;Если перед числом не минус
     jne If_positivie_number    
     inc si                     ;Если отрицательное число 
     
If_positivie_number:            ;Если положительное число
     cmp buffer[si], '3'        ;Посимвольное сравнение буфера
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
    mov cx, dx                  ;Передвем кол-во байт числа
    dec dx
    mov si, 2 
    
    cmp buffer[si], '-'         ;Сравниваем с минусом
    jne Check_on_zero           ;Если не минус
    inc si
   
    cmp buffer[si], '0'                    
    jne Convertation_on_number  ;Если не нуль
    inc si
   
    jmp Convertation_on_number   
    
Check_on_zero:    
    cmp buffer[si], '0'
    jne Convertation_on_number  ;Если не нулевое
    inc si 
                           ;/*----------------convertation---------------*/
Convertation_on_number:         ;Конвертация
    cmp buffer[si], 0Dh         ;Если достигнут конец буффера
    je Сonversion_completion
    xor ax, ax                  ;Обнуление регистра
    mov al, buffer[si]          ;Запись символа
    sub ax, 30h                 ;Отнимаем аски символ 0
   
    push cx
    mov cx, dx  
    push dx   
    push bx                     ;Заносим в стек фактическое значение числа
    mov bx, 10  
    
Mul_on_ten:                     ;Получение количества разрядов числа
    cmp cx, 0
    je End_of_mul
    mul bx                      ;Умножение AX на BX с записью в приемник
    dec cx                      ;Уменьшение количества разрядов
    jmp Mul_on_ten 
     
End_of_mul:                     ;Завершение получения кол-ва разрядов
    pop bx                      ;Получение значения
    pop dx                      
    dec dx                      ;Уменьшение счетчика
    pop cx
    inc si                      ;Инкрементируем счетчик
    add bx, ax                  ;Прибавляем полученные аккумулятор к разрядному bx
    jmp Convertation_on_number 
                                 ;/*---------------------------------------*/
Сonversion_completion: 
    mov si, 2
    cmp buffer[si], '-'         ;Если положительное число
    jne Positive_value 
    neg bx                      ;Меняет знак на противоложный
    
Positive_value:                 ;Если положительное значение
    pop cx                      ;Считываем размерность массива
    mov array[di], bx           ;Записываем в масиив полученное число
    add di,2                    ;Шаг 2 байта
    mov ah, 2
    mov dl, 020h                ;Пробел
    int 21h
    
    loop Entering_number        ;Ввод пока не нуль в регистре cx
    jmp end_insert
    
Uncorrect_value:   
    mov dx, offset Incorrect_value_str               
    call Output_string_proc
        
    mov ax, '$' 
    mov dx, offset buffer       ;Занесение конца строки
    mov cx, 9 
    
    pop cx
    jmp Entering_number 
                                ;/*---------------------------------------*/
end_insert:
    lea si, array               ;Загружвем смещение массива
    lea di, array
    mov cx, size_  
    call Bubble_proc 

    mov dx, offset Sorted_array_str                
    call Output_string_proc  

    lea di, array               ;Записанный отсортированный массив
    mov cx, size_                ;Загружаем размер массива

    call Output_array_proc

Serching_median:
    mov dx, offset Median_str                
    call Output_string_proc
    
    mov ax, size_               ;Передача размера массива
    xor dx, dx                  ;Очистка регистра записи остатка
    mov bx, 2                   ;Делитель
    div bx                      ;Делим на ах с записью в приёмник
                                ;Остаток записывается в dx
    cmp dx, 1
                   
    je Odd_value                ;Если есть остаток
      
    mul bx                      ;Получение индекса средних элементов
    mov di, ax     
    mov ax, array[di]           ;Запись в регисты значения с массива,в ах записывается старшее число
    mov bx, array[di-2]
    cmp ax, bx 
    
    je Even_value               ;Если значения равны
    xor dx, dx
   
    cmp ax, 0                   ;Сравнение правого числа с нуленом
    jl Check_left               ;Если правое меньше нуля
    cmp bx, 0               
    jle Add_numbers             ;Если левое число меньше или равно нуля
    jmp Sub_positive_numbers    ;Если оба больше нуля
                 
Check_left:                     ;
    cmp bx, 0                   ;Если больше или равно
    jge Add_numbers                    
    jmp Sub_positive_numbers                
                                    
Add_numbers:                    ;Прибавление                                       
     neg bx                     ;тк bx отрицательное   
     cmp ax, bx                     
     jl print_minus             ;Если полученное значение bx больше ax
                      
back:                           ;Если ax больше   
     neg bx                     ;Перевод в доп код
     add ax, bx                 
         
Signed_:                                  
     neg ax                          
     js Signed_                 ;Проверка на знак     
     mov bx, 2                      
     idiv bx                    ;Деление со знаком    
     push dx                        
     jmp Even_value                
                                    
Sub_positive_numbers:           ;Вычитание     
    cmp ax, bx                      
                                    
ax_bx:                              
    sub ax, bx                  ;Вычитание из большего числа меньшее    
    push bx                         
    mov bx, 2                       
    idiv bx                     ;Деление со знаком     
    pop bx                          
    add ax, bx                  ;Сложение младшей полученной части с bx    
    cmp dx, 1                       
    jne not_add_1               ;Если четное    

add_1:                           
    cmp ax, 0                       
    jg not_add_1                ;Если большн нуля, то не прибавляется единица    
    inc ax                          

not_add_1:                         
    push dx                         
    jmp Even_value               

print_minus:                        
    push ax                         
    push dx                         
    mov ah, 2                   ;Добавление минуса    
    mov dl, '-'                     
    int 21h                         
    pop dx                          
    pop ax                          
jmp back                            
;jmp Even_value                  
    
Odd_value:                      ;Если размер массива нечетное число
    mov dx, 0  
    push dx
    mov med_num, ax             
    mul  bx                     ;Получение индекса среднего элемента
    mov di, ax     
    mov ax, array[di]           ;Запись среднего элемента в регистр
     
Even_value:                     ;Если размер массива четное число
     mov bx, ax                 ;Получение значения медианы
     cmp bx, 0                  ;Если  не нуль
     jne Check_on_positive 

Zero_result:   
     mov dl, bl
     mov ah, 2
     add dl, 30h                ;Запись нуля из dl
     int 21h 
    
     jmp Print_remainder        
      
add_minus1:                     ;Если медиана отрицательное число
      push ax   
      mov ah, 2
      mov dl, '-'               ;Добавление минуса
      int 21h 
      
      pop ax 
      jmp sign21  
      
Check_on_positive:  
      neg ax                     ;Получение флага SF
      jns add_minus1             ;Если нету минуса
      neg ax
       
                                  ;/*---------------------------------------*/
sign21:       
      neg bx
      js sign21
      mov si, 0       
      xor dx, dx                 ;Обнуление остатка
      push bx 
      mov bx, 10                 ;Делитель
      mov cx, 5                  ;Получние максимального кол-ва разрядов числа
      
size1:                           ;Получение кол-ва разрядов числа
      cmp ax, 10
      jl Increment_counter_of_actual_size1
      div bx                     ;Деление
      xor dx, dx                 
      inc si                     ;Счетчик разрядов
loop size1     
      
Increment_counter_of_actual_size1: 
    pop bx      
    inc si      
    
Getting_number1:                 ;Получение числа
      mov ax, bx 
      mov cx, si                 ;Передача фактического разряда числа
      dec cx 
      push bx
      mov bx, 10                 ;Делитель
      
Div_on_ten1:                     ;Деление разрядов числа на 10
     cmp cx, 0
     je End_of_div1
     div bx
     xor dx, dx 
     loop Div_on_ten1   
     
End_of_div1:                     ;Завершение деления
     push ax                     ;Сохраняем значение
     mov dl, al
     mov ah, 2
     add dl, 30h                 ;Добаляем байт
     int 21h                     ;Выводит полученнное значение
     pop ax
     mov cx, si                  ;Передаем разрядный размер
     dec cx   
     
Inverse_multi1:                  ;Обратное умножение 
    cmp cx, 0                    
    je Completed_inverse_multi1
    mul bx
    loop Inverse_multi1
      
Completed_inverse_multi1: 
   pop bx
   sub bx, ax                    ;Вычитание старшего разряда
   dec si
   cmp si, 0
   jne Getting_number1           ;Пока не встретился младший разряд
   
Print_remainder: 
    pop dx                         ;
    cmp dx, 0
    je Close_program 
      
    mov dx, offset remainder               
    call Output_string_proc
   
Close_program:                    ;Завершение работы
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