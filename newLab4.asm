name 'lab4'

.model small
.stack 100h
.data
    
Max_window_size_X               equ 40     
Field_length                    equ 21    
;Field_length_X                  equ 37
;Field_length_Y                  equ 21

Offset_by_X                     equ 2
Offset_by_Y                     equ 2 
Offset_position_on_field        equ 2 * 2 * (Offset_by_Y * Max_window_size_X + Offset_by_X)
    
wl equ 30B2h    
em equ 0021h
    
Empty_element dw 2 dup(em)

Screen_matrix   dw Field_length dup(wl)
                dw wl,em,em,em,em,em,em,em,em,em,wl,em,em,em,em,em,em,em,em,em,wl
                dw wl,em,wl,wl,wl,em,wl,wl,wl,em,wl,em,wl,wl,wl,em,wl,wl,wl,em,wl
                dw wl,em,wl,wl,wl,em,wl,wl,wl,em,wl,em,wl,wl,wl,em,wl,wl,wl,em,wl
                dw wl,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,wl
                dw wl,em,wl,wl,wl,em,wl,em,wl,wl,wl,wl,wl,em,wl,em,wl,wl,wl,em,wl
                dw wl,em,em,em,em,em,wl,em,em,em,wl,em,em,em,wl,em,em,em,em,em,wl
                dw wl,wl,wl,wl,wl,em,wl,wl,wl,em,wl,em,wl,wl,wl,em,wl,wl,wl,wl,wl
                dw wl,em,em,em,em,em,wl,em,em,em,em,em,em,em,wl,em,em,em,em,em,wl
                dw wl,em,wl,wl,wl,em,em,em,wl,wl,wl,wl,wl,em,em,em,wl,wl,wl,em,wl
                dw wl,em,em,em,em,em,wl,em,em,em,em,em,em,em,wl,em,em,em,em,em,wl
                dw wl,wl,wl,wl,wl,em,wl,em,wl,wl,wl,wl,wl,em,wl,em,wl,wl,wl,wl,wl
                dw wl,em,em,em,em,em,em,em,em,em,wl,em,em,em,em,em,em,em,em,em,wl
                dw wl,em,wl,wl,wl,em,wl,wl,wl,em,wl,em,wl,wl,wl,em,wl,wl,wl,em,wl
                dw wl,em,em,em,wl,em,em,em,wl,em,wl,em,wl,em,em,em,wl,em,em,em,wl
                dw wl,wl,wl,em,wl,em,wl,em,em,em,em,em,em,em,wl,em,wl,em,wl,wl,wl
                dw wl,em,em,em,em,em,wl,em,wl,wl,wl,wl,wl,em,wl,em,em,em,em,em,wl
                dw wl,em,wl,wl,wl,wl,wl,em,em,em,wl,em,em,em,wl,wl,wl,wl,wl,em,wl
                dw wl,em,wl,wl,wl,wl,wl,wl,wl,em,wl,em,wl,wl,wl,wl,wl,wl,wl,em,wl
                dw wl,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,em,wl
                dw Field_length dup (wl)       

;Screen_matrix    dw Field_length_X dup(wl)
;                 dw wl,em,em,em,em,em,em,em,em,wl,em,em,em,em,em,em,em,em,wl,em,em,em,em,em,em,em,em,wl,em,em,em,em,em,em,em,em,wl
;                 dw wl,em,wl,wl,em,wl,wl,wl,em,wl,em,wl,wl,wl,wl,wl,em,wl,wl,wl,em,wl,wl,wl,wl,wl,em,wl,em,wl,wl,wl,em,wl,wl,em,wl
;                 dw wl,em,wl,wl,em,wl,wl,wl,em,em,em,wl,em,em,em,wl,em,wl,em,wl,em,wl,em,em,em,wl,em,em,em,wl,wl,wl,em,wl,wl,em,wl
;                 dw wl,em,em,em,em,em,em,wl,em,wl,em,em,em,wl,em,em,em,em,em,em,em,em,em,wl,em,em,em,wl,em,wl,em,em,em,em,em,em,wl
;                 dw wl,em,wl,wl,em,wl,em,em,em,wl,em,wl,em,wl,em,wl,wl,wl,wl,wl,wl,wl,em,wl,em,wl,em,wl,em,em,em,wl,em,wl,wl,em,wl
;                 dw wl,em,em,em,em,wl,em,wl,em,em,em,wl,em,em,em,em,wl,em,em,em,wl,em,em,em,em,wl,em,em,em,wl,em,wl,em,em,em,em,wl
;                 dw wl,wl,wl,wl,em,wl,em,wl,wl,wl,em,wl,em,wl,wl,em,wl,em,wl,em,wl,em,wl,wl,em,wl,em,wl,wl,wl,em,wl,em,wl,wl,wl,wl
;                 dw wl,em,em,em,em,wl,em,em,em,em,em,wl,em,em,em,em,em,em,wl,em,em,em,em,em,em,wl,em,em,em,em,em,wl,em,em,em,em,wl
;                 dw wl,em,wl,em,wl,wl,wl,wl,em,wl,wl,wl,wl,wl,em,wl,em,wl,wl,wl,em,wl,em,wl,wl,wl,wl,wl,em,wl,wl,wl,wl,em,wl,em,wl
;                 dw wl,em,wl,em,em,wl,em,wl,em,wl,em,em,em,em,em,wl,em,em,em,em,em,wl,em,em,em,em,em,wl,em,wl,em,wl,em,em,wl,em,wl
;                 dw wl,em,wl,em,wl,wl,em,wl,em,em,em,wl,em,wl,em,wl,wl,wl,em,wl,wl,wl,em,wl,em,wl,em,em,em,wl,em,wl,wl,em,wl,em,wl
;                 dw wl,em,em,em,em,wl,em,em,em,wl,em,wl,em,wl,em,em,em,wl,em,wl,em,em,em,wl,em,wl,em,wl,em,em,em,wl,em,em,em,em,wl
;                 dw wl,wl,wl,em,wl,wl,em,wl,wl,wl,em,em,em,em,em,wl,em,em,em,em,em,wl,em,em,em,em,em,wl,wl,wl,em,wl,wl,em,wl,wl,wl
;                 dw wl,em,em,em,em,em,em,em,em,em,em,wl,wl,em,wl,em,em,wl,em,wl,em,em,wl,em,wl,wl,em,em,em,em,em,em,em,em,em,em,wl
;                 dw wl,em,wl,wl,wl,wl,em,wl,em,wl,wl,wl,wl,em,em,em,wl,wl,em,wl,wl,em,em,em,wl,wl,wl,wl,em,wl,em,wl,wl,wl,wl,em,wl
;                 dw wl,em,wl,em,wl,wl,em,wl,em,em,em,em,em,em,wl,em,em,em,em,em,em,em,wl,em,em,em,em,em,em,wl,em,wl,wl,em,wl,em,wl
;                 dw wl,em,wl,em,em,em,em,em,wl,wl,wl,em,wl,em,wl,wl,em,wl,em,wl,em,wl,wl,em,wl,em,wl,wl,wl,em,em,em,em,em,wl,em,wl
;                 dw wl,em,wl,wl,em,wl,wl,em,wl,em,em,em,wl,em,wl,wl,em,wl,wl,wl,em,wl,wl,em,wl,em,em,em,wl,em,wl,wl,em,wl,wl,em,wl
;                 dw wl,em,em,em,em,wl,wl,em,em,em,wl,em,wl,em,em,em,em,em,wl,em,em,em,em,em,wl,em,wl,em,em,em,wl,wl,em,em,em,em,wl
;                 dw Field_length_X dup(wl)
                  
    
Current_score_offset_X          equ 5
Current_score_offset_Y          equ 24
Total_current_score_offset      equ 2 * 2 * (Current_score_offset_Y * Max_window_size_X + Current_score_offset_X)
    
Score_str                       db 'Score:  '
Score_str_length                equ 8
Score_str_offset_X              equ 1
Score_str_offset_Y              equ 24
Total_score_str_offset          equ 2 * 2 * (Score_str_offset_Y * Max_window_size_X + Score_str_offset_X)
    
You_lose_str                    db  'GAME OVER!'  
Lose_length                     equ 10
Lose_str_offset_X               equ 27
Lose_str_offset_Y               equ 6
Total_lose_str_offset           equ 2 * 2 * (Lose_str_offset_Y * Max_window_size_X + Lose_str_offset_X)  

You_win_str                     db  'YOU ARE WIN!!!'  
Win_length                      equ 14
Win_str_offset_X                equ 27
Win_str_offset_Y                equ 6
Total_win_str_offset            equ 2 * 2 * (Win_str_offset_Y * Max_window_size_X + Win_str_offset_X) 

Pause_str                       db  'PAUSE PAUSE PAUSE'
Pause_length                    equ 17
Pause_str_offset_X              equ 27
Pause_str_offset_Y              equ 6
Total_pause_str_offset          equ 2 * 2 * (Pause_str_offset_Y * Max_window_size_X + Pause_str_offset_X)

Enter_str                       db  'Enter - to continue'
Enter_length                    equ 19
Enter_str_offset_X              equ 26
Enter_str_offset_Y              equ 8
Total_enter_str_offset          equ 2 * 2 * (Enter_str_offset_Y * Max_window_size_X + Enter_str_offset_X)   

Quit_str                        db  'Tab - to end the game'
Quit_length                     equ 21
Quit_str_offset_X               equ 26
Quit_str_offset_Y               equ 10
Total_quit_str_offset           equ 2 * 2 * (Quit_str_offset_Y * Max_window_size_X + Quit_str_offset_X)  

Reset_str                       db  'R - reset the game'
Reset_length                    equ 18
Reset_str_offset_X              equ 26
Reset_str_offset_Y              equ 12
Total_reset_str_offset          equ 2 * 2 * (Reset_str_offset_Y * Max_window_size_X + Reset_str_offset_X)
   
Random                          db  97h
Random_low                      db  ?
Random_high                     db  ?   

;/-----------------------игровые сообщения------------------------------------/              
Hello_str                       db   "HELLO! PLEASE, CHOOSE...",                                           0Ah,0Dh,    "$"                        
Easy_str                        db   "1. Easy: play up to 10 points with 4 ghosts!",                       0Ah,0Dh,    "$"
Medium_str                      db   "2. Medium: play up to 15 poits with 5 ghosts!",                      0Ah,0Dh,    "$"   
Hard_str                        db   "3. Hard: play up to 20 points with 6 ghosts!",                       0Ah,0Dh,    "$"
Unreal_str                      db   "4. ", 02h," UNREAL ", 02h ,": play up to 30 points with 7 ghosts!",  0Ah,0Dh,    "$"

;/-----------------------параметры сложностей--------------------------------/ 
Easy_apples                     equ 10
Easy_chosts                     equ 4
Easy_pause                      equ 65000

Medium_apples                   equ 15
Medium_chosts                   equ 5
Medium_pause                    equ 50000 
 
Hard_apples                     equ 20   
Hard_chosts                     equ 6 
Hard_pause                      equ 30000
Hard_delay_ghosts               equ 2
     
Unreal_apples                   equ 30
Unreal_chosts                   equ 7
Unreal_pause                    equ 20000
Unreal_delay_ghosts             equ 2

Game_loop_pause                 dw  65000   

;/-----------------------работа с призраками----------------------------------/    
Max_count_of_ghosts             dw  4 
Ghosts_max_delay_moving         db  3
Ghosts_delay_counter            db  ?
Ghosts_position_X               db  Max_count_of_ghosts dup(?) 
Ghosts_position_Y               db  Max_count_of_ghosts dup(?)
Ghosts_current_direction        db  Max_count_of_ghosts dup(?)
Ghosts_colors                   db  Max_count_of_ghosts dup(?)      

Ghost_blue                      dw  0911h, 0912h ;0000100111011110b, 0000100111011101b
Ghost_green                     dw  0A11h, 0A12h ;0000101011011110b, 0000101011011101b
Ghost_purple                    dw  0D11h, 0D12h ;0000110111011110b, 0000110111011101b
Ghost_gray                      dw  0F11h, 0F12h ;0000111111011110b, 0000011111011101b             
    
;/-----------------------работа с пакманом----------------------------------/    
Pacman_position_X               db  ?
Pacman_position_Y               db  ?
Pacman_current_direction        db  ?
Pacman_next_direction           db  ? 
Flag_moving_pacman              db  0   
                             ;желтый;|элемент; 0Е - Желтый на черном
Pacman_UP                       dw  0E5Ch, 0E2Fh  ;0000111001011100b, 0000111000101111b ; "\/"  
Pacman_DOWN                     dw  0E2Fh, 0E5Ch  ;0000111000101111b, 0000111001011100b ; "/\"
Pacman_LEFT                     dw  0E3Eh, 0E4Fh  ;0000111000111110b, 0000111000101101b ; ">0" 
Pacman_RIGHT                    dw  0E4Fh, 0E3Ch  ;0000111000101101b, 0000111000111100b ; "0<"   

;/-----------------------работа с яблоком----------------------------------/
Max_count_of_apples             db  ?     
Count_of_apple                  db  0
Apple_position_X                db  ?
Apple_position_Y                db  ?
Apple                           dw  0C3Ch, 0C3Eh ;0000110000101000b, 0000110000101001b ; red "<>"  on black 
Apple_counting_str              dw  4 dup(?)   

;/------------------------работа с очками и жизнями------------------------/
Count_of_health                 db  3
Health_position_X               equ 35
Health_position_Y               equ 22
Health_tree                     dw  0C03h, 0C33h
Health_two                      dw  0C03h, 0C32h
Health_one                      dw  0C03h, 0C31h
Health_zero                     dw  0C03h, 0C30h

Green_colour                    equ 10
White_colour                    equ 15
Red_colour                      equ 4  
Purple_colour                   equ 13 
Brown_colour                    equ 14
Black_colour                    equ 0
     
;/------------------------------------------------------------------------------/
;/------------------------------------------------------------------------------/     
.code                                                                            
;/------------------main--------------------------/
start:
    mov ax, @data
    mov ds, ax
    mov Count_of_health, 3        
    call Select_difficulty 
        
    mov ax, 0B800h                       ;Область видеопамяти
    mov es, ax                           ;Передача в es адреса видеопамяти

Return_to_start:                             
    mov Count_of_apple, 0                ;Обнуление очков 
    Set_screen   
    call Field_display                   ;Отрисовка игрового поля
    call Draw_score_string               ;Отрисовка сообщения счета    
    call Draw_count_of_heart             ;Появление числа жизней
    call Pacman_appearance               ;Появление пакмана
    call Ghosts_appearance               ;Появление призраков
    call Apple_appearance                ;Появление яблока
    
Main_cycle:
    Waiting
    call Moving_pacman                   ;Движение пакмана
    call Moving_chosts                   ;Движение призрака
jmp Main_cycle       

End_of_game: 
    Set_screen
    mov ax, 4c00h
    int 21h                                                                          
    
    
;/------------------------------------------------------------------------------/                
Field_display  proc                  ;ОТРИСОВКА ПОЛЯ              
    push si
    push di
    push ax
    push cx
    
    mov si, offset Screen_matrix     ;Передача поля
    mov di, Offset_position_on_field ;Передача смещения одной полосы              
    ;mov cx, Field_length_Y          ;Передача размера длины поля
    mov cx, Field_length             ;Передача размера длины поля
     
Loop_render_by_string:              
    push cx
    ;mov cx, Field_length_X          ;Цикл отрисовки по строкам
    mov cx, Field_length             ;Цикл отрисовки по строкам
    
Loop_render_by_columns:
    push cx            
    mov ax, ds:[si]                  ;Передача пикселя
    mov cx, 2    
        
Loop_render_one_element:             ;Отрисовка элемента
    mov word ptr es:[di], ax         ;Указание что следует использовать как слово
    add di, 2
loop Loop_render_one_element       

    add si, 2            
    pop cx
loop Loop_render_by_columns   
    
    add di, 2 * 2 * (Max_window_size_X - Field_length) ;Переход на новую строку
    ;add di, 2 * 2 * (Max_window_size_X - Field_length_X) ;Переход на новую строку
    pop cx
loop Loop_render_by_string
   
    pop cx
    pop ax
    pop di
    pop si
    ret
Field_display  endp
                             
;/-------------------------------------------------------------------/
Draw_score_string proc             ;ПЕЧАТЬ СТРОКИ СЧЕТА
    mov si, offset Score_str       ;Передача строки
    mov di, Total_score_str_offset ;Передача смещения 
    mov cx, Score_str_length       ;Получение длины строки

Draw_score_loop:
    mov ah, Green_colour           ;00001010b(зеленый цвет)
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_score_loop       
    ret
Draw_score_string endp

;/-------------------------------------------------------------------/
Draw_lose_string proc              ;ПЕЧАТЬ СТРОКИ ПРОИГРЫША
    mov si, offset You_lose_str    ;Передача строки
    mov di, Total_lose_str_offset  ;Передача смещения
    mov cx, Lose_length            ;Получение длины строки

Draw_lose_loop:
    mov ah, Red_colour             ;000000100b(красный цвет)
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_lose_loop    
    ret
Draw_lose_string endp  

;/-------------------------------------------------------------------/
Draw_pause_string proc              ;ПЕЧАТЬ СТРОКИ ПАУЗЫ
   
Draw_pause:   
    mov si, offset Pause_str        ;Передача строки
    mov di, Total_pause_str_offset  ;Передача смещения
    mov cx, Pause_length            ;Получение длины строки

Draw_pause_loop:
    mov ah, Brown_colour              
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_pause_loop
        
        
Draw_key_enter:
    mov si, offset Enter_str        ;Передача строки
    mov di, Total_enter_str_offset  ;Передача смещения
    mov cx, Enter_length            ;Получение длины строки

Draw_enter_loop:
    mov ah, White_colour              
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_enter_loop
                   
    ret
Draw_pause_string endp 

;/-------------------------------------------------------------------/
Draw_reset_quit_str proc           ;ОТРИСОВКА КНОПОК ОЖИДАНИЯ  И ВЫХОДА НАЖАТИЕ 
    
Draw_key_quit:
    mov si, offset Quit_str        ;Передача строки
    mov di, Total_quit_str_offset  ;Передача смещения
    mov cx, Quit_length            ;Получение длины строки

Draw_quit_loop:
    mov ah, White_colour              
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_quit_loop  
       
       
Draw_key_reset:
    mov si, offset Reset_str        ;Передача строки
    mov di, Total_reset_str_offset  ;Передача смещения
    mov cx, Reset_length            ;Получение длины строки

Draw_reset_loop:
    mov ah, White_colour              
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_reset_loop
    
    ret
Draw_reset_quit_str endp    

;/-------------------------------------------------------------------/
Draw_clean_pause_string proc        ;ОЧИСТКА СТРОКИ ПАУЗЫ

Clean_pause:    
    mov di, Total_pause_str_offset  ;Передача смещения
    mov cx, Pause_length            ;Получение длины строки

Clean_pause_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_pause_loop 
        
        
Clean_enter:    
    mov di, Total_enter_str_offset  ;Передача смещения
    mov cx, Enter_length            ;Получение длины строки

Clean_enter_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_enter_loop 
     
     
Clean_quit:    
    mov di, Total_quit_str_offset  ;Передача смещения
    mov cx, Quit_length            ;Получение длины строки

Clean_quit_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_quit_loop   
        
        
Clean_reset:    
    mov di, Total_reset_str_offset  ;Передача смещения
    mov cx, Reset_length            ;Получение длины строки

Clean_reset_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_reset_loop 
       
    ret
Draw_clean_pause_string endp 

;/-------------------------------------------------------------------/
Draw_win_string proc               ;ПЕЧАТЬ СТРОКИ ВЫИГРЫША
    mov si, offset You_win_str     ;Передача строки
    mov di, Total_win_str_offset   ;Передача смещения
    mov cx, Win_length             ;Получение длины строки

Draw_win_loop:
    mov ah, Purple_colour          
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_win_loop    
    ret
Draw_win_string endp 

;/------------------------------------------------------------------/                     
Set_screen macro                ;УСТАНОВКА ОКНА И ВИДЕОРЕЖИМА
    push ax
    mov ax, 0003h               ;Установка видеорежима 80/25
    int 10h
    pop ax
endm   

;/-------------------------------------------------------------------/
Waiting macro                   ;ОЖИДАНИЕ ДЛЯ СИНХРОНИЗАЦИИ
    push ax 
    push cx
    push dx 
      
    mov ah, 86h                 ;Установка  ожидания CX:DX 
    mov cx, 1 
    mov dx, Game_loop_pause
    int 15h
    
    pop dx
    pop cx
    pop ax
endm 

;/--------------------------------------------------------------------/
Check_key_pressed macro          ;ПРОВЕРКА НАЖАТИЯ КЛАВИШИ
    push ax                      
    mov ah, 01h                  ;Проверят буфер клавиатуры 
    int 16h       
    pop ax
endm       

;/---------------------------------------------------------------------/      
Press_key macro                  ;НАЖАТИЕ КЛАВИШИ
    mov ah, 00h
    int 16h                      ; al - ACSCII код и ah - сканкод клавиши
endm                                                                      

;/---------------------------------------------------------------------/
Clear_keyboard_buf macro         ;Очистка буфера клавиатуры
    push ax
    mov ax,0c00h                 ;Вызываем соответствующую функцию
    int 21h       
    pop ax
endm 
          
;/-----------------------------------------------------------------/
Rewriting_param macro       ;ПЕРЕЗАПИСЬ ПАРАМЕТРОВ РАНДОМА
    push dx
    push cx
    
    mov ah, 2ch             ;Получение текущего системного времени
    int 21h
    mov Random_low, dh      ;Запись секунд
    mov Random_high, dl     ;запись одной сотой секунды
    
    pop cx
    pop dx
endm

;/--------------------------------------------------------------/
Calculate_random_parameters macro number shift1 multiplier summand shift2
    push ax             ;ПЕРЕСЧЕТ ПАРАМЕТРОВ ДЛЯ РАНДОМА
    
    mov al, number      ;Передача значения для его обновления
    ror al, shift1      ;shift1(number) Вращение битов(сдвиш вправо)
    mov ah, multiplier  ;Множитель
    mul ah              ;Перемножение младшей и старшей части
    add al, summand     ;shift1(number) * multiplier + summand
    ror al, shift2      ;Cдвиг новой полученной части
    mov number, al      ;считывание младшей части
    
    pop ax      
endm

;/-----------------------------------------------------------------/
Update_data_for_random macro    ;ОБНОВЛЕНИЕ ПАРАМЕТРОВ
    Calculate_random_parameters Random        2   23  11  5
    Calculate_random_parameters Random_low    1   7   4   3 
    Calculate_random_parameters Random_high   7   5   8   4    
    Calculate_random_parameters Random        6   Random_low  Random_high  1
endm 

;/--------------------------------------------------------------------/
Get_random_number_macro macro Max_var   ; ПОЛУЧЕНИЕ РАНДОМНОГО ЗНАЧЕНИЯ ОТНОСИТЕЛЬНО ЗАДАННОЙ ПЕРЕМЕННОЙ
    push bx
    push dx
    
    Update_data_for_random
    xor ax, ax   
    xor bx, bx
    mov al, Random       ;Получение значения для рандома
    mov bl, Max_var      ;Получение максимально допустимой границы
    cwd                  ;Преобразование слова в двойное слово
    div bx               ;Деление а максимальное допустимое значение
    mov ax, dx           ;Записываем получившийся остаток в ax
    
    pop dx 
    pop bx  
endm                                                                    

;/----------------------------------------------------------------------/
Write_macro macro str           ;МАКРОС ВЫВОДА СТРОКИ
       lea dx, str
       mov ah,09h
       int 21h
endm
;/----------------------------------------------------------------------/
Calculate_element_offset macro Size_X ;РАСЧИТАТЬ СМЕЩЕНИЕ ОБЪЕКТА ОТНОСИТЕЛЬНО ПОЛЯ
    xor bx, bx
    mov bl, ah                        ;Передача позиции по Х
    mov ah, 0h
    mov dx, Size_X
    mul dx                            ;Перемножение регистов положения элемента по оси Х на al(положение по Y)
    add ax, bx                        ;Сложение смещения в матрице поля с положение на Х
    mov dx, 2 * 2        
    mul dx                            ;Перемножение положения в матрице(текущее смещение запишется в ax)
endm 

;/----------------------------------------------------------------------/
Draw_element macro Element       ;ОТРИСОВКА ЭЛЕМЕНТА
    push si                      ;Положение элемента: в ah - положение по Х, в al - положение по Y 
    push di
    push cx
    push bx
    push dx
    
    Calculate_element_offset Max_window_size_X
    mov si, offset Element       ;Получение обрабатываемого элемента
    mov di, Offset_position_on_field   
    add di, ax                   ;Получение позиции для перерисовки
    mov cx, 2                
    rep movsw                    ;Передача слов(2 байта) из DS:SI в ES:DI 
    
    pop dx
    pop bx
    pop cx
    pop di
    pop si
endm                                                                        

;/-------------------------------------------------------------------------/
Get_element macro                ;ПОЛУЧЕНИЕ ЕЛЕМЕНТА
    push si
    push bx
    push dx
    
    ;Calculate_element_offset Field_length_X              ;;;;;;;;;;;;;;;;;;;;
    Calculate_element_offset Field_length
    mov bx, 2
    div bx     
    mov si, offset Screen_matrix;Передача поля
    add si, ax                  ;Переход к адресу оъекта
    mov ax, [si]                ;Получение элемента по смещению
    
    pop dx
    pop bx
    pop si
endm

;/--------------------------------------------------------------------------/
Check_direction_object proc      ;ПРОВЕРКА ОБЪЕКТА ПО ХОДУ ДВИЖЕНИЯ ПЕРСОНАЖА
    cmp bl, 0                    ;Получение следующего направления 
    je Check_object_in_up
    cmp bl, 1
    je Check_object_in_down
    cmp bl, 2
    je Check_object_in_left
    cmp bl, 3
    je Check_object_in_right             
    
Check_object_in_up:              ;Декрементирование позиции по Y(вверх)
        dec al
        jmp Check_got_object
        
Check_object_in_down:            ;Инкрементирование позиции по Y(вниз)      
        inc al
        jmp Check_got_object
        
Check_object_in_left:            ;Декрементирование позиции по Х(влево)       
        dec ah
        jmp Check_got_object

Check_object_in_right:           ;Инкрементирование позиции по Х(вправо)       
        inc ah
        jmp Check_got_object
        
Check_got_object: 
        Get_element              ;Получение объекта по полученной позиции
        ret
Check_direction_object endp                                               

;/-----------------------------------------------------------------------/
Meeting_pacman_with_ghosts_checking proc ;ПРОВЕРКА ВСТРЕЧИ ПАКМАНА С ПРИЗРАКОМ
    push si
    push cx
    push ax
    mov cx, Max_count_of_ghosts
    mov si, 0
    
Meeting_pacman_with_ghosts_checking_loop: ;Получение позиций призраков
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
        
    cmp ah, Pacman_position_X             ;Проверка координат по Х
    je Check_meeting_pac_gh_on_Y
    jmp Check_next_meeting_pacman_with_ghost 
    
Check_meeting_pac_gh_on_Y:                ;Проверка координат по Y
    cmp al, Pacman_position_Y
    je Decrement_health
    jmp Check_next_meeting_pacman_with_ghost
            
Check_next_meeting_pacman_with_ghost:     ;Переход к следующему призраку
    inc si
loop Meeting_pacman_with_ghosts_checking_loop               
    pop ax
    pop cx
    pop si
    ret 

Decrement_health:                         ;Уменьшение жизни
    dec Count_of_health
    cmp Count_of_health,0      
    jne Return_to_start
      
    call Draw_count_of_heart
    jmp call Good_game_well_played
       
    pop ax
    pop cx
    pop si
    ret
Meeting_pacman_with_ghosts_checking endp  

;/----------------------------------------------------------------------/
Real_good_game proc                     ;ОКОНЧАНИЕ ИГРЫ ВЫИГРЫШЕМ
    call Draw_win_string                ;Отрисовка сообщения счета
    call Draw_reset_quit_str
Waiting_pressed_F_:    
    Press_key                           ;Нажатие клавиши  
    Clear_keyboard_buf                  ;Очистка буфера клавиатуры  
    
    cmp al, 'r'                         ;Перезапуск игры
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    cmp ah, 0Fh                         ;Выход из игры
    je End_of_game
    
    jmp Waiting_pressed_F_  
    ret 
Real_good_game endp

;/----------------------------------------------------------------------/
Good_game_well_played proc              ;ОКОНЧАНИЕ ИГРЫ ПРОИГРЫШЕМ
    call Draw_clean_pause_string        ;Стирание сообщений меню
    call Draw_lose_string               ;Отрисовка сообщения счета
    call Draw_reset_quit_str
Waiting_pressed_F:    
    Press_key                           ;Нажатие клавиши  
    Clear_keyboard_buf                  ;Очистка буфера клавиатуры  
    
    cmp al, 'r'                         ;Перезапуск игры
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    cmp ah, 0Fh                         ;Выход из игры
    je End_of_game
    
    jmp Waiting_pressed_F  
    ret  
Good_game_well_played endp

;/---------------------------------------------------------------------/
Meeting_pacman_with_apple_checking proc  ;ПРОВЕРКА ВСТРЕЧИ ПАКМАНА С ЯБЛОКОМ
    push ax                     
    
Meeting_pacman_with_apple_on_X:          ;Проверка встречи по оси Х
    mov ah, Apple_position_X
    mov al, Pacman_position_X
    cmp ah, al                           
    je Meeting_pacman_with_apple_on_Y    ;Если координаты по Х совпадают
    jmp End_meeting_pacman_with_apple  
    
Meeting_pacman_with_apple_on_Y:          ;Проверка встречи по оси Y     
    mov ah, Apple_position_Y
    mov al, Pacman_position_Y
    cmp ah, al
    je Rewriting_score                   ;Если координаты совпадают, то перезапись счета
    jmp End_meeting_pacman_with_apple
        
Rewriting_score:                         ;Инкрементирование счета
    inc Count_of_apple  
    call Apple_appearance 
    
    push ax                              ;Проверка на победу
    mov al, Count_of_apple 
    mov ah, Max_count_of_apples 
    cmp al, ah 
    je call Real_good_game               ;В случае победы 
    pop ax   
                
    jmp End_meeting_pacman_with_apple    
        
End_meeting_pacman_with_apple:
    pop ax    
    ret
Meeting_pacman_with_apple_checking endp
 
;/------------------------------------------------------------------/ 
Meeting_ghosts_with_apple_checking proc  ;ПРОВЕРКА ВСТРЕЧИ ПРИЗРАКА С ЯБЛОКОМ
    push ax                     
    
Meeting_ghost_with_apple_on_X:           ;Сравнение позиций элементов по оси Х
    mov ah, Apple_position_X
    mov al, Ghosts_position_X[si]
    cmp ah, al
    je Meeting_ghost_with_apple_on_Y     ;Если совпала, то проверка другой оси
    jmp End_meeting_ghosts_with_apple  
        
Meeting_ghost_with_apple_on_Y:           ;Проверка оси Y
    mov ah, Apple_position_Y
    mov al, Ghosts_position_Y[si]
    cmp ah, al
    je Rebraw_apple                      ;Если совпала, то перерисовывание яблока
    jmp End_meeting_ghosts_with_apple
        
Rebraw_apple:                            ;Перерисовывание яблока
    call Drawing_apple
        
End_meeting_ghosts_with_apple:
    pop ax    
    ret
Meeting_ghosts_with_apple_checking endp  

;/----------------------------------------------------------------------------/
Pacman_appearance proc                  ;ПОЯВЛЕНИЕ ПАКМАНА
    mov Pacman_position_X, 1            ;Установка позиции пакмана
    mov Pacman_position_Y, 1
    mov Pacman_current_direction, 2     ;Установка текущего направления пакмана(налево)
    mov Pacman_next_direction, 2
    call Drawing_pacman                 ;Отрисовка пакмана
    ret
Pacman_appearance endp

;/-----------------------------------------------------------------------------/
Keypress_check proc                     ;ПРОВЕРКА НАЖАТИЯ КЛАВИШИ
    Check_key_pressed
    jnz If_pressed                      ;Если нажатие клавиши доступно
    
    mov Flag_moving_pacman, 0
    ret
        
If_pressed:                             ;Если нажата     
    mov Flag_moving_pacman, 1
    Press_key                           ;Нажатие клавиши 
    Clear_keyboard_buf                  ;Очистка буфера клавиатуры
    
    cmp al, 'w'                         ;Если нажата вверх
    je Pacman_direction_up 
    cmp al, 'W'
    je Pacman_direction_up
    cmp ah, 48h
    je Pacman_direction_up
    
    cmp al, 's'                         ;Если нажата вниз
    je Pacman_direction_down  
    cmp al, 'S'
    je Pacman_direction_down
    cmp ah, 50h
    je Pacman_direction_down    
    
    cmp al, 'a'                         ;Если нажата влево
    je Pacman_direction_left 
    cmp al, 'A'
    je Pacman_direction_left
    cmp ah, 4bh
    je Pacman_direction_left
        
    cmp al, 'd'                         ;Если нажата вправо
    je Pacman_direction_right 
    cmp al, 'D'
    je Pacman_direction_right    
    cmp ah, 4dh
    je Pacman_direction_right

    cmp ah, 01h
    je call Stop_game
    
    mov Pacman_next_direction, 5             ;;;;;;;;;
    ret
        
Pacman_direction_up:                    ;Установка направления движения вверх 
    mov Pacman_next_direction, 0
    ret   
    
Pacman_direction_down:
    mov Pacman_next_direction, 1        ;Установка движения вниз
    ret    
    
Pacman_direction_left:                  ;Установка движения влево
    mov Pacman_next_direction, 2
    ret  
    
Pacman_direction_right:                 ;Установка движения вправо
    mov Pacman_next_direction, 3
    ret 
    
Keypress_check endp                                                    

;/----------------------------------------------------------------/
Stop_game proc                          ;ПАУЗА ИГРЫ   
    push ax      
    call Draw_pause_string              ;Появление сообщений о меню   
    call Draw_reset_quit_str
If_pause_pressed:    
    Press_key                           ;Нажатие клавиши  
    Clear_keyboard_buf                  ;Очистка буфера клавиатуры  
    cmp ah, 1Ch                         ;Продолжить игру
    je End_pause 
    
    cmp ah, 0Fh                         ;Конец игры
    je End_of_game 
    
    cmp al, 'r'                         ;Перезапуск игры
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    jmp If_pause_pressed 
    
End_pause:
    call Draw_clean_pause_string        ;Стирание сообщений меню
    pop ax
    ret    
Stop_game endp   

;/----------------------------------------------------------------/
Reset_game proc                         ;ПЕРЕЗАПУСТИТЬ ИГРУ                 
    Set_screen 
    jmp start
    ret
Reset_game endp  

;/----------------------------------------------------------------/    
Delete_pacman proc                      ;УДАЛЕНИЕ ПАКМАНА
    mov ah, Pacman_position_X 
    mov al, Pacman_position_Y
    Draw_element Empty_element          ;Рисовка на место пакмана пустого блока
    ret
Delete_pacman endp

;/----------------------------------------------------------------/ 
Rewriting_pacman_positions proc         ;ПЕРЕЗАПИСЬ ТЕКУЩЕЙ ПОЗИЦИИ ПАКМАНА
    cmp Pacman_current_direction, 0     ;Получение текущего напрвления пакмана 
    je Rewritting_pacman_on_up
    cmp Pacman_current_direction, 1
    je Rewritting_pacman_on_down
    cmp Pacman_current_direction, 2
    je Rewritting_pacman_on_left
    cmp Pacman_current_direction, 3
    je Rewritting_pacman_on_right             
    
Rewritting_pacman_on_up:                ;Перезапись направления на вверх        
        dec Pacman_position_Y
        ret
  
Rewritting_pacman_on_down:              ;Перезапись направления на вниз
        inc Pacman_position_Y
        ret
   
Rewritting_pacman_on_left:              ;Перезапись направления на влево
        dec Pacman_position_X
        ret
  
Rewritting_pacman_on_right:             ;Перезапись направления на вправо 
        inc Pacman_position_X
        ret
Rewriting_pacman_positions endp                                       

;/----------------------------------------------------------------/
Drawing_pacman proc                     ;ОТРИСОВКА ПАКМАНА
    mov ah, Pacman_position_X           ;Получение текущей позиции пакмана на поле
    mov al, Pacman_position_Y
    
    cmp Pacman_current_direction, 0     ;Получение направления движения пакмана 
    je Drawing_pacman_up   
    
    cmp Pacman_current_direction, 1
    je Drawing_pacman_down
    
    cmp Pacman_current_direction, 2
    je Drawing_pacman_left
    
    cmp Pacman_current_direction, 3
    je Drawing_pacman_right    
    
Drawing_pacman_up:                      ;Если движение вверх                
        Draw_element Pacman_UP
        jmp Drawing_pacman_complete

Drawing_pacman_down:                    ;Если движение вниз
        Draw_element Pacman_DOWN
        jmp Drawing_pacman_complete
    
Drawing_pacman_left:                    ;Если движение влево
        Draw_element Pacman_LEFT
        jmp Drawing_pacman_complete
    
Drawing_pacman_right:                   ;Если движение вниз
        Draw_element Pacman_RIGHT
        jmp Drawing_pacman_complete
    
Drawing_pacman_complete:
        ret
Drawing_pacman endp     

;/------------------------------------------------------------------/ 
Moving_pacman proc                        ;ДВИЖЕНИЕ ОСНОВНОГО ПЕРСОНАЖА
    push ax
    push bx
    call Keypress_check                   ;Проверка нажатия клавиши движения пакмана
    
    cmp Pacman_next_direction, 5          ;Если не нажата клавиша направления
    je Moving_pacman_complete              ;;;;;;;;;;
    cmp Flag_moving_pacman, 0             ;Если не установлен флаг движения
    je Moving_pacman_complete              ;;;;;;;;;;    
                
Check_pacman_next_direction:
    mov ah, Pacman_position_X              ;Получение текущей позиции клавиши
    mov al, Pacman_position_Y
    mov bl, Pacman_next_direction          ;Получение следующего направления
    call Check_direction_object            ;Процедура проверки объекта по направлению движения
    cmp ax, em
    je Change_to_new_direction_pacman      ;Если свободная позиция 
       
Check_current_position_pacman:             ;Получение текущей позиции пакмана
    mov ah, Pacman_position_X 
    mov al, Pacman_position_Y
    mov bl, Pacman_current_direction        
    call Check_direction_object            ;Получение объекта по текущей позиции
    cmp ax, em                             ;Если свободная ячейка
    je Redraw_pacman                       ;Перерисовывание пакмана на текущую же позицию
    cmp ax, wl
    je Moving_pacman_complete    
    
Change_to_new_direction_pacman:            ;Перезапись направления движения пакмана 
    mov ah, Pacman_next_direction     
    mov Pacman_current_direction, ah
                
Redraw_pacman:    
    call Delete_pacman                       ;Удаление пакмана
    call Rewriting_pacman_positions          ;Перезапись координат пакмана
    call Meeting_pacman_with_ghosts_checking ;Проверка встречи пакмана и призрака
    call Meeting_pacman_with_apple_checking  ;Проверка встречи пакмана с яблоком
    call Drawing_pacman                      ;Отрисовка пакмана
        
Moving_pacman_complete:     
    pop bx 
    pop ax  
    ret
Moving_pacman endp
 
;/--------------------------------------------------------------------/           
Ghosts_appearance proc              ;ПОЯВЛЕНИЕ ПРИЗРАКОВ
    Rewriting_param                 ;Обновление параметров рандома
    
    mov cx, Max_count_of_ghosts     ;Передача числа параметров
    mov si, 0
    
Appearance_ghost_loop:        
Create_ghost:
    ;Get_random_number_macro Field_length_X   ;Получение позиции где появится призрак
    Get_random_number_macro Field_length   ;Получение позиции где появится призрак
    mov Ghosts_position_X[si], al  
    Get_random_number_macro Field_length   ;Получение позиции где появится призрак    
    ;Get_random_number_macro Field_length_Y
    mov Ghosts_position_Y[si], al   
    
    Get_random_number_macro 4              ;Получение направления для движения пакмана 
    mov Ghosts_current_direction[si], al
    Get_random_number_macro 4              ;Получение цвета призрака
    mov Ghosts_colors[si], al              
    
    mov ah, Ghosts_position_X[si]
    mov al, Ghosts_position_Y[si]
    Get_element                      ;Получение элемента, находящего по данной позиции(где должен появится призрак)
    cmp ax, em                       ;Если пустое пространство (можно ставить призрака)
    je Create_next_chost
    jmp Create_ghost
                 
Create_next_chost:                   ;Создание следующего призрака
    call Drawing_chost
    inc si
loop Appearance_ghost_loop    
    
    mov Ghosts_delay_counter, 0      ;Установка начально задержки 
    ret
Ghosts_appearance endp                                              

;/-----------------------------------------------------------------/
Delete_chost proc                    ;УДАЛЕНИЕ ПРИЗРАКА
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
    Draw_element Empty_element       ;Установка на место призрака пустого блока
    ret
Delete_chost endp

;/-----------------------------------------------------------------/ 
Rewriting_ghost_position proc        ;ПЕРЕЗАПИСЬ ТЕКУЩЕЙ ПОЗИЦИИ ПРИЗРАКА
    cmp bl, 0                        ;Получение данных о направлении движения призрака
    je Moving_chost_in_up
    cmp bl, 1
    je Moving_chost_in_down
    cmp bl, 2
    je Moving_chost_in_left
    cmp bl, 3
    je Moving_chost_in_right             
    
Moving_chost_in_up:                  ;Декрементирование позиции по Y
    dec Ghosts_position_Y[si]
    ret

Moving_chost_in_down:                ;Икрементирование позиции по Y
    inc Ghosts_position_Y[si]
    ret
  
Moving_chost_in_left:                ;Декрементирование позиции по Х 
    dec Ghosts_position_X[si]
    ret
   
Moving_chost_in_right:               ;Икрементирование позиции по Х   
    inc Ghosts_position_X[si]
    ret
Rewriting_ghost_position endp

;/----------------------------------------------------------/    
Drawing_chost proc                   ;Отрисовка призрака
    mov ah, Ghosts_position_X[si]    ;Получение позиции призрака
    mov al, Ghosts_position_Y[si]
    
    mov bl, Ghosts_colors[si]        ;Получение цвета
    cmp bl, 0                        ;Если синий
    je Drawing_chost_on_blue
    cmp bl, 1                        ;Если зеленый
    je Drawing_chost_on_green
    cmp bl, 2                        ;Если фиолетовый
    je Drawing_chost_on_purple
    cmp bl, 3                        ;Если серый
    je Drawing_chost_on_gray 
    
Drawing_chost_on_blue:               ;Отрисовка синего призрака
    Draw_element Ghost_blue
    jmp Drawing_chost_complete
    
Drawing_chost_on_green:              ;Отрисовка зеленого призрака
    Draw_element Ghost_green
    jmp Drawing_chost_complete
  
Drawing_chost_on_purple:             ;Отрисовка фиолетового призрака
    Draw_element Ghost_purple
    jmp Drawing_chost_complete
    
Drawing_chost_on_gray:               ;Отрисовка серого призрака
    Draw_element Ghost_gray
    jmp Drawing_chost_complete
    
Drawing_chost_complete:
        ret
Drawing_chost endp         

;/---------------------------------------------------------------------/
Getting_prev_direction proc          ;ПОЛУЧЕНИЕ ПРЫДЫДУШЕГО НАПРАВЛЕНИЯ
    cmp bl, 2
    jge If_current_left_right        ;Если текущее направление указывает налево или направо
    jmp If_current_up_down           ;Если указывает на низ или верх
    
If_current_left_right:               ;Если право-лево
    cmp bl, 2
    je Left_to_right
    jmp Right_to_left 
    
If_current_up_down:                  ;Если верх-низ
    cmp bl, 1
    je Down_to_up
    jmp Up_to_down
    
Up_to_down:                          ;Если верх, то меняем на низ
    mov bl, 1
    ret
         
Down_to_up:                          ;Если низ, то меняем на верх
    mov bl, 0
    ret
        
Left_to_right:                       ;Если лево, то меняем на право
    mov bl, 3
    ret 
        
Right_to_left:                       ;Если право, то меняем 
    mov bl, 2        
    ret
Getting_prev_direction endp

;/-----------------------------------------------------------------------/
Moving_chosts proc                   ;ПЕРЕДВИЖЕНИЕ ПРИЗРАКОВ
    push ax
    push bx
    push cx
                  
    inc Ghosts_delay_counter        ;Получение числа задержки призраков 
    push ax
    mov ah, Ghosts_max_delay_moving 
    cmp Ghosts_delay_counter, ah
    pop ax
    jne Moving_chosts_complete
        
    mov Ghosts_delay_counter, 0
    Rewriting_param                 ;Пересчет парметров для рандома
            
    mov cx, Max_count_of_ghosts
    mov si, 0
    
Moving_chosts_loop: 
Check_random_chosts_direction:
    Get_random_number_macro 4       ;Получение рандомного направления
    mov bl, al
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
    call Check_direction_object     ;Проверка на объект находящийся по данному направлению
    
    cmp ax, em                      ;Если по ходу движения пустое пространство
    je Check_prev_direction
    cmp ax, wl                      ;Если стена, то пересчет рандомного направления
    je Check_random_chosts_direction
        
Check_prev_direction:               ;Проверка предыдущего направления
    call Getting_prev_direction
    mov bh, Ghosts_current_direction[si]
    cmp bh, bl
    je Check_random_chosts_direction ;Если предыдущее и текущее направления совпадают
            
Set_ghosts_direction_on_next_:
    call Getting_prev_direction     ;Обратное получение направления
    mov Ghosts_current_direction[si], bl
            
Rebraw_chost:    
    call Delete_chost                        ;Удаление призрака               
    call Meeting_ghosts_with_apple_checking  ;Проверка встречи призрака с яблоком
    call Rewriting_ghost_position            ;Перезапись позиции призрака
    call Meeting_pacman_with_ghosts_checking ;Проверка встречи пакмана и призрака             
    call Drawing_chost                       ;Перерисовывание призрака
            
    inc si
loop Moving_chosts_loop
    
Moving_chosts_complete:     
    pop cx 
    pop bx
    pop ax  
    ret
Moving_chosts endp               
                   
;/---------------------------------------------------------/           
Convert_num_to_str proc      ;ПЕРЕВОД ИЗ ЧИСЛА В СТРОКУ
    push bp                  ;Сохранение bp
    mov bp, sp               ;Bp - вершина стека     
    mov ax, [bp + 6]
    mov si, [bp + 4]         ;Считывание 4го параметра
    
    xor cx, cx               
    mov bx, 10                
        
Getting_number_digits:
    xor dx, dx
    div bx                    
    push dx                  ;Занесение остатка  
    inc cx                   ;Получение числа разрядов
    cmp ax, 0                ;Пока не закончилась старшая часть
jne Getting_number_digits
        
Draw_digit_loop:
    pop dx
    add dx, 30h              ;Перевод в сивольное значение числа
    mov dh, Green_colour     
    mov word ptr [si], dx    ;Запись счета в переменную
    add si, 2
loop Draw_digit_loop

    pop bp
    ret 4
Convert_num_to_str endp

;/----------------------------------------------------------/
Drawing_count_of_apple proc     ;ОТРИСОВКА ЧИСЛА ЯБЛОК
    xor cx, cx
    mov cl, Count_of_apple
    push cx
    push offset Apple_counting_str   
    call Convert_num_to_str     ;Перевод числа в строку и отрисовка 

    mov si, offset Apple_counting_str
    mov di, Total_current_score_offset
    mov cx, 4                
    rep movsw                   ;Перенос строки из DS:SI в ES:DI
    ret
Drawing_count_of_apple endp

;/----------------------------------------------------------/
Drawing_apple proc              ;ОТРИСОВКА ЯБЛОКА
    mov ah, Apple_position_X 
    mov al, Apple_position_Y
    Draw_element Apple          ;Получение яблока 
    ret
Drawing_apple endp

;/----------------------------------------------------------/
Apple_appearance proc           ;ПОЯВЛЕНИЕ ЯБЛОКА
    Rewriting_param
         
Setting_apple_position:
    ;Get_random_number_macro Field_length_X ;Получение координат яблока
    Get_random_number_macro Field_length   ;Получение позиции где появится призрак
    mov Apple_position_X, al 
    Get_random_number_macro Field_length   ;Получение позиции где появится призрак
    ;Get_random_number_macro Field_length_Y
    mov Apple_position_Y, al  
    
    mov ah, Apple_position_X 
    mov al, Apple_position_Y
    Get_element                 ;Получение элемента по позиции установкаи яблока
    cmp ax, em
    je Create_apple
    jmp Setting_apple_position
    
Create_apple:
    call Drawing_apple          ;Отрисовка яблока
    call Drawing_count_of_apple ;Отрисовка счета
    ret
Apple_appearance endp   

;/----------------------------------------------------------/
Draw_count_of_heart proc           ;ОТРИСОВКА ЖИЗНЕЙ
    push ax
    push bx 
    
    mov ah, Health_position_X      ;Получение координат 
    mov al, Health_position_Y 
    
    mov bl, Count_of_health        ;Получение числа жизней
    cmp bl, 3
    je Draw_tree_health
    cmp bl, 2
    je Draw_two_health
    cmp bl, 1
    je Draw_one_health
    cmp bl, 0 
    je Draw_zero_health
    
Draw_tree_health:                  ;Отрисовка 3 жизней
    Draw_element Health_tree     
    pop bx
    pop ax
    ret    

Draw_two_health:                   ;Отрисовка 2 жизней
    Draw_element Health_two     
    pop bx
    pop ax
    ret    

Draw_one_health:                   ;Отрисовка 1 жизни
    Draw_element Health_one     
    pop bx
    pop ax
    ret     
    
Draw_zero_health:                  ;Отрисовка 0 жизни
    Draw_element Health_zero     
    pop bx
    pop ax
    ret    
Draw_count_of_heart endp

;/------------------------------------------------------/ 
Select_difficulty proc             ;ВЫБОР СЛОЖНОСТИ
    Write_macro Hello_str
    Write_macro Easy_str
    Write_macro Medium_str
    Write_macro Hard_str    
    Write_macro Unreal_str
    
Enter_difficulty_selection:     ;Ввод выбора игроком режима
    mov ah,01h                  ;Считывание символа из стандартного в/вв
    int 21h
    Clear_keyboard_buf          ;Очистка буфера клавиатуры
                                
    cmp al, '1'                 ;Выбор сложности
    je Easy_dif
    cmp al, '2'
    je Medium_dif
    cmp al, '3'
    je Hard_dif
    cmp al, '4'
    je Unreal_dif   
    jmp Enter_difficulty_selection
    
Easy_dif:                       ;Легкая сложность
    mov ah, Easy_apples  
    mov Max_count_of_apples, ah
    mov ax, Easy_chosts  
    mov Max_count_of_ghosts, ax
    mov ax, Easy_pause
    mov Game_loop_pause, ax        
    xor ax,ax
    ret
    
Medium_dif:                     ;Средняя сложность
    mov ah, Medium_apples  
    mov Max_count_of_apples, ah 
    mov ax, Medium_chosts  
    mov Max_count_of_ghosts, ax
    mov ax, Medium_pause
    mov Game_loop_pause, ax
    xor ax,ax
    ret    
    
Hard_dif:                       ;Тяжелая сложность
    mov ah, Hard_apples  
    mov Max_count_of_apples, ah
    mov ax, Hard_chosts  
    mov Max_count_of_ghosts, ax
    mov ax, Hard_pause
    mov Game_loop_pause, ax 
    mov ah, Hard_delay_ghosts
    mov Ghosts_max_delay_moving, ah
    xor ax,ax
    ret
    
Unreal_dif:                     ;Нереальная сложность
    mov ah, Unreal_apples  
    mov Max_count_of_apples, ah
    mov ax, Unreal_chosts  
    mov Max_count_of_ghosts, ax
    mov ax, Unreal_pause
    mov Game_loop_pause, ax 
    mov ah, Unreal_delay_ghosts
    mov Ghosts_max_delay_moving, ah
    xor ax,ax
    ret 
Select_difficulty endp 
;/----------------------------------------------------------/                       
           
end start
