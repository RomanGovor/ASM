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

;/-----------------------èãðîâûå ñîîáùåíèÿ------------------------------------/              
Hello_str                       db   "HELLO! PLEASE, CHOOSE...",                                           0Ah,0Dh,    "$"                        
Easy_str                        db   "1. Easy: play up to 10 points with 4 ghosts!",                       0Ah,0Dh,    "$"
Medium_str                      db   "2. Medium: play up to 15 poits with 5 ghosts!",                      0Ah,0Dh,    "$"   
Hard_str                        db   "3. Hard: play up to 20 points with 6 ghosts!",                       0Ah,0Dh,    "$"
Unreal_str                      db   "4. ", 02h," UNREAL ", 02h ,": play up to 30 points with 7 ghosts!",  0Ah,0Dh,    "$"

;/-----------------------ïàðàìåòðû ñëîæíîñòåé--------------------------------/ 
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

;/-----------------------ðàáîòà ñ ïðèçðàêàìè----------------------------------/    
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
    
;/-----------------------ðàáîòà ñ ïàêìàíîì----------------------------------/    
Pacman_position_X               db  ?
Pacman_position_Y               db  ?
Pacman_current_direction        db  ?
Pacman_next_direction           db  ? 
Flag_moving_pacman              db  0   
                             ;æåëòûé;|ýëåìåíò; 0Å - Æåëòûé íà ÷åðíîì
Pacman_UP                       dw  0E5Ch, 0E2Fh  ;0000111001011100b, 0000111000101111b ; "\/"  
Pacman_DOWN                     dw  0E2Fh, 0E5Ch  ;0000111000101111b, 0000111001011100b ; "/\"
Pacman_LEFT                     dw  0E3Eh, 0E4Fh  ;0000111000111110b, 0000111000101101b ; ">0" 
Pacman_RIGHT                    dw  0E4Fh, 0E3Ch  ;0000111000101101b, 0000111000111100b ; "0<"   

;/-----------------------ðàáîòà ñ ÿáëîêîì----------------------------------/
Max_count_of_apples             db  ?     
Count_of_apple                  db  0
Apple_position_X                db  ?
Apple_position_Y                db  ?
Apple                           dw  0C3Ch, 0C3Eh ;0000110000101000b, 0000110000101001b ; red "<>"  on black 
Apple_counting_str              dw  4 dup(?)   

;/------------------------ðàáîòà ñ î÷êàìè è æèçíÿìè------------------------/
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
        
    mov ax, 0B800h                       ;Îáëàñòü âèäåîïàìÿòè
    mov es, ax                           ;Ïåðåäà÷à â es àäðåñà âèäåîïàìÿòè

Return_to_start:                             
    mov Count_of_apple, 0                ;Îáíóëåíèå î÷êîâ 
    Set_screen   
    call Field_display                   ;Îòðèñîâêà èãðîâîãî ïîëÿ
    call Draw_score_string               ;Îòðèñîâêà ñîîáùåíèÿ ñ÷åòà    
    call Draw_count_of_heart             ;Ïîÿâëåíèå ÷èñëà æèçíåé
    call Pacman_appearance               ;Ïîÿâëåíèå ïàêìàíà
    call Ghosts_appearance               ;Ïîÿâëåíèå ïðèçðàêîâ
    call Apple_appearance                ;Ïîÿâëåíèå ÿáëîêà
    
Main_cycle:
    Waiting
    call Moving_pacman                   ;Äâèæåíèå ïàêìàíà
    call Moving_chosts                   ;Äâèæåíèå ïðèçðàêà
jmp Main_cycle       

End_of_game: 
    Set_screen
    mov ax, 4c00h
    int 21h                                                                          
    
    
;/------------------------------------------------------------------------------/                
Field_display  proc                  ;ÎÒÐÈÑÎÂÊÀ ÏÎËß              
    push si
    push di
    push ax
    push cx
    
    mov si, offset Screen_matrix     ;Ïåðåäà÷à ïîëÿ
    mov di, Offset_position_on_field ;Ïåðåäà÷à ñìåùåíèÿ îäíîé ïîëîñû              
    ;mov cx, Field_length_Y          ;Ïåðåäà÷à ðàçìåðà äëèíû ïîëÿ
    mov cx, Field_length             ;Ïåðåäà÷à ðàçìåðà äëèíû ïîëÿ
     
Loop_render_by_string:              
    push cx
    ;mov cx, Field_length_X          ;Öèêë îòðèñîâêè ïî ñòðîêàì
    mov cx, Field_length             ;Öèêë îòðèñîâêè ïî ñòðîêàì
    
Loop_render_by_columns:
    push cx            
    mov ax, ds:[si]                  ;Ïåðåäà÷à ïèêñåëÿ
    mov cx, 2    
        
Loop_render_one_element:             ;Îòðèñîâêà ýëåìåíòà
    mov word ptr es:[di], ax         ;Óêàçàíèå ÷òî ñëåäóåò èñïîëüçîâàòü êàê ñëîâî
    add di, 2
loop Loop_render_one_element       

    add si, 2            
    pop cx
loop Loop_render_by_columns   
    
    add di, 2 * 2 * (Max_window_size_X - Field_length) ;Ïåðåõîä íà íîâóþ ñòðîêó
    ;add di, 2 * 2 * (Max_window_size_X - Field_length_X) ;Ïåðåõîä íà íîâóþ ñòðîêó
    pop cx
loop Loop_render_by_string
   
    pop cx
    pop ax
    pop di
    pop si
    ret
Field_display  endp
                             
;/-------------------------------------------------------------------/
Draw_score_string proc             ;ÏÅ×ÀÒÜ ÑÒÐÎÊÈ Ñ×ÅÒÀ
    mov si, offset Score_str       ;Ïåðåäà÷à ñòðîêè
    mov di, Total_score_str_offset ;Ïåðåäà÷à ñìåùåíèÿ 
    mov cx, Score_str_length       ;Ïîëó÷åíèå äëèíû ñòðîêè

Draw_score_loop:
    mov ah, Green_colour           ;00001010b(çåëåíûé öâåò)
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_score_loop       
    ret
Draw_score_string endp

;/-------------------------------------------------------------------/
Draw_lose_string proc              ;ÏÅ×ÀÒÜ ÑÒÐÎÊÈ ÏÐÎÈÃÐÛØÀ
    mov si, offset You_lose_str    ;Ïåðåäà÷à ñòðîêè
    mov di, Total_lose_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Lose_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

Draw_lose_loop:
    mov ah, Red_colour             ;000000100b(êðàñíûé öâåò)
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_lose_loop    
    ret
Draw_lose_string endp  

;/-------------------------------------------------------------------/
Draw_pause_string proc              ;ÏÅ×ÀÒÜ ÑÒÐÎÊÈ ÏÀÓÇÛ
   
Draw_pause:   
    mov si, offset Pause_str        ;Ïåðåäà÷à ñòðîêè
    mov di, Total_pause_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Pause_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

Draw_pause_loop:
    mov ah, Brown_colour              
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_pause_loop
        
        
Draw_key_enter:
    mov si, offset Enter_str        ;Ïåðåäà÷à ñòðîêè
    mov di, Total_enter_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Enter_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

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
Draw_reset_quit_str proc           ;ÎÒÐÈÑÎÂÊÀ ÊÍÎÏÎÊ ÎÆÈÄÀÍÈß  È ÂÛÕÎÄÀ ÍÀÆÀÒÈÅ 
    
Draw_key_quit:
    mov si, offset Quit_str        ;Ïåðåäà÷à ñòðîêè
    mov di, Total_quit_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Quit_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

Draw_quit_loop:
    mov ah, White_colour              
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_quit_loop  
       
       
Draw_key_reset:
    mov si, offset Reset_str        ;Ïåðåäà÷à ñòðîêè
    mov di, Total_reset_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Reset_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

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
Draw_clean_pause_string proc        ;Î×ÈÑÒÊÀ ÑÒÐÎÊÈ ÏÀÓÇÛ

Clean_pause:    
    mov di, Total_pause_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Pause_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

Clean_pause_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_pause_loop 
        
        
Clean_enter:    
    mov di, Total_enter_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Enter_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

Clean_enter_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_enter_loop 
     
     
Clean_quit:    
    mov di, Total_quit_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Quit_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

Clean_quit_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_quit_loop   
        
        
Clean_reset:    
    mov di, Total_reset_str_offset  ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Reset_length            ;Ïîëó÷åíèå äëèíû ñòðîêè

Clean_reset_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_reset_loop 
       
    ret
Draw_clean_pause_string endp 

;/-------------------------------------------------------------------/
Draw_win_string proc               ;ÏÅ×ÀÒÜ ÑÒÐÎÊÈ ÂÛÈÃÐÛØÀ
    mov si, offset You_win_str     ;Ïåðåäà÷à ñòðîêè
    mov di, Total_win_str_offset   ;Ïåðåäà÷à ñìåùåíèÿ
    mov cx, Win_length             ;Ïîëó÷åíèå äëèíû ñòðîêè

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
Set_screen macro                ;ÓÑÒÀÍÎÂÊÀ ÎÊÍÀ È ÂÈÄÅÎÐÅÆÈÌÀ
    push ax
    mov ax, 0003h               ;Óñòàíîâêà âèäåîðåæèìà 80/25
    int 10h
    pop ax
endm   

;/-------------------------------------------------------------------/
Waiting macro                   ;ÎÆÈÄÀÍÈÅ ÄËß ÑÈÍÕÐÎÍÈÇÀÖÈÈ
    push ax 
    push cx
    push dx 
      
    mov ah, 86h                 ;Óñòàíîâêà  îæèäàíèÿ CX:DX 
    mov cx, 1 
    mov dx, Game_loop_pause
    int 15h
    
    pop dx
    pop cx
    pop ax
endm 

;/--------------------------------------------------------------------/
Check_key_pressed macro          ;ÏÐÎÂÅÐÊÀ ÍÀÆÀÒÈß ÊËÀÂÈØÈ
    push ax                      
    mov ah, 01h                  ;Ïðîâåðÿò áóôåð êëàâèàòóðû 
    int 16h       
    pop ax
endm       

;/---------------------------------------------------------------------/      
Press_key macro                  ;ÍÀÆÀÒÈÅ ÊËÀÂÈØÈ
    mov ah, 00h
    int 16h                      ; al - ACSCII êîä è ah - ñêàíêîä êëàâèøè
endm                                                                      

;/---------------------------------------------------------------------/
Clear_keyboard_buf macro         ;Î÷èñòêà áóôåðà êëàâèàòóðû
    push ax
    mov ax,0c00h                 ;Âûçûâàåì ñîîòâåòñòâóþùóþ ôóíêöèþ
    int 21h       
    pop ax
endm 
          
;/-----------------------------------------------------------------/
Rewriting_param macro       ;ÏÅÐÅÇÀÏÈÑÜ ÏÀÐÀÌÅÒÐÎÂ ÐÀÍÄÎÌÀ
    push dx
    push cx
    
    mov ah, 2ch             ;Ïîëó÷åíèå òåêóùåãî ñèñòåìíîãî âðåìåíè
    int 21h
    mov Random_low, dh      ;Çàïèñü ñåêóíä
    mov Random_high, dl     ;çàïèñü îäíîé ñîòîé ñåêóíäû
    
    pop cx
    pop dx
endm

;/--------------------------------------------------------------/
Calculate_random_parameters macro number shift1 multiplier summand shift2
    push ax             ;ÏÅÐÅÑ×ÅÒ ÏÀÐÀÌÅÒÐÎÂ ÄËß ÐÀÍÄÎÌÀ
    
    mov al, number      ;Ïåðåäà÷à çíà÷åíèÿ äëÿ åãî îáíîâëåíèÿ
    ror al, shift1      ;shift1(number) Âðàùåíèå áèòîâ(ñäâèø âïðàâî)
    mov ah, multiplier  ;Ìíîæèòåëü
    mul ah              ;Ïåðåìíîæåíèå ìëàäøåé è ñòàðøåé ÷àñòè
    add al, summand     ;shift1(number) * multiplier + summand
    ror al, shift2      ;Cäâèã íîâîé ïîëó÷åííîé ÷àñòè
    mov number, al      ;ñ÷èòûâàíèå ìëàäøåé ÷àñòè
    
    pop ax      
endm

;/-----------------------------------------------------------------/
Update_data_for_random macro    ;ÎÁÍÎÂËÅÍÈÅ ÏÀÐÀÌÅÒÐÎÂ
    Calculate_random_parameters Random        2   23  11  5
    Calculate_random_parameters Random_low    1   7   4   3 
    Calculate_random_parameters Random_high   7   5   8   4    
    Calculate_random_parameters Random        6   Random_low  Random_high  1
endm 

;/--------------------------------------------------------------------/
Get_random_number_macro macro Max_var   ; ÏÎËÓ×ÅÍÈÅ ÐÀÍÄÎÌÍÎÃÎ ÇÍÀ×ÅÍÈß ÎÒÍÎÑÈÒÅËÜÍÎ ÇÀÄÀÍÍÎÉ ÏÅÐÅÌÅÍÍÎÉ
    push bx
    push dx
    
    Update_data_for_random
    xor ax, ax   
    xor bx, bx
    mov al, Random       ;Ïîëó÷åíèå çíà÷åíèÿ äëÿ ðàíäîìà
    mov bl, Max_var      ;Ïîëó÷åíèå ìàêñèìàëüíî äîïóñòèìîé ãðàíèöû
    cwd                  ;Ïðåîáðàçîâàíèå ñëîâà â äâîéíîå ñëîâî
    div bx               ;Äåëåíèå à ìàêñèìàëüíîå äîïóñòèìîå çíà÷åíèå
    mov ax, dx           ;Çàïèñûâàåì ïîëó÷èâøèéñÿ îñòàòîê â ax
    
    pop dx 
    pop bx  
endm                                                                    

;/----------------------------------------------------------------------/
Write_macro macro str           ;ÌÀÊÐÎÑ ÂÛÂÎÄÀ ÑÒÐÎÊÈ
       lea dx, str
       mov ah,09h
       int 21h
endm
;/----------------------------------------------------------------------/
Calculate_element_offset macro Size_X ;ÐÀÑ×ÈÒÀÒÜ ÑÌÅÙÅÍÈÅ ÎÁÚÅÊÒÀ ÎÒÍÎÑÈÒÅËÜÍÎ ÏÎËß
    xor bx, bx
    mov bl, ah                        ;Ïåðåäà÷à ïîçèöèè ïî Õ
    mov ah, 0h
    mov dx, Size_X
    mul dx                            ;Ïåðåìíîæåíèå ðåãèñòîâ ïîëîæåíèÿ ýëåìåíòà ïî îñè Õ íà al(ïîëîæåíèå ïî Y)
    add ax, bx                        ;Ñëîæåíèå ñìåùåíèÿ â ìàòðèöå ïîëÿ ñ ïîëîæåíèå íà Õ
    mov dx, 2 * 2        
    mul dx                            ;Ïåðåìíîæåíèå ïîëîæåíèÿ â ìàòðèöå(òåêóùåå ñìåùåíèå çàïèøåòñÿ â ax)
endm 

;/----------------------------------------------------------------------/
Draw_element macro Element       ;ÎÒÐÈÑÎÂÊÀ ÝËÅÌÅÍÒÀ
    push si                      ;Ïîëîæåíèå ýëåìåíòà: â ah - ïîëîæåíèå ïî Õ, â al - ïîëîæåíèå ïî Y 
    push di
    push cx
    push bx
    push dx
    
    Calculate_element_offset Max_window_size_X
    mov si, offset Element       ;Ïîëó÷åíèå îáðàáàòûâàåìîãî ýëåìåíòà
    mov di, Offset_position_on_field   
    add di, ax                   ;Ïîëó÷åíèå ïîçèöèè äëÿ ïåðåðèñîâêè
    mov cx, 2                
    rep movsw                    ;Ïåðåäà÷à ñëîâ(2 áàéòà) èç DS:SI â ES:DI 
    
    pop dx
    pop bx
    pop cx
    pop di
    pop si
endm                                                                        

;/-------------------------------------------------------------------------/
Get_element macro                ;ÏÎËÓ×ÅÍÈÅ ÅËÅÌÅÍÒÀ
    push si
    push bx
    push dx
    
    ;Calculate_element_offset Field_length_X              ;;;;;;;;;;;;;;;;;;;;
    Calculate_element_offset Field_length
    mov bx, 2
    div bx     
    mov si, offset Screen_matrix;Ïåðåäà÷à ïîëÿ
    add si, ax                  ;Ïåðåõîä ê àäðåñó îúåêòà
    mov ax, [si]                ;Ïîëó÷åíèå ýëåìåíòà ïî ñìåùåíèþ
    
    pop dx
    pop bx
    pop si
endm

;/--------------------------------------------------------------------------/
Check_direction_object proc      ;ÏÐÎÂÅÐÊÀ ÎÁÚÅÊÒÀ ÏÎ ÕÎÄÓ ÄÂÈÆÅÍÈß ÏÅÐÑÎÍÀÆÀ
    cmp bl, 0                    ;Ïîëó÷åíèå ñëåäóþùåãî íàïðàâëåíèÿ 
    je Check_object_in_up
    cmp bl, 1
    je Check_object_in_down
    cmp bl, 2
    je Check_object_in_left
    cmp bl, 3
    je Check_object_in_right             
    
Check_object_in_up:              ;Äåêðåìåíòèðîâàíèå ïîçèöèè ïî Y(ââåðõ)
        dec al
        jmp Check_got_object
        
Check_object_in_down:            ;Èíêðåìåíòèðîâàíèå ïîçèöèè ïî Y(âíèç)      
        inc al
        jmp Check_got_object
        
Check_object_in_left:            ;Äåêðåìåíòèðîâàíèå ïîçèöèè ïî Õ(âëåâî)       
        dec ah
        jmp Check_got_object

Check_object_in_right:           ;Èíêðåìåíòèðîâàíèå ïîçèöèè ïî Õ(âïðàâî)       
        inc ah
        jmp Check_got_object
        
Check_got_object: 
        Get_element              ;Ïîëó÷åíèå îáúåêòà ïî ïîëó÷åííîé ïîçèöèè
        ret
Check_direction_object endp                                               

;/-----------------------------------------------------------------------/
Meeting_pacman_with_ghosts_checking proc ;ÏÐÎÂÅÐÊÀ ÂÑÒÐÅ×È ÏÀÊÌÀÍÀ Ñ ÏÐÈÇÐÀÊÎÌ
    push si
    push cx
    push ax
    mov cx, Max_count_of_ghosts
    mov si, 0
    
Meeting_pacman_with_ghosts_checking_loop: ;Ïîëó÷åíèå ïîçèöèé ïðèçðàêîâ
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
        
    cmp ah, Pacman_position_X             ;Ïðîâåðêà êîîðäèíàò ïî Õ
    je Check_meeting_pac_gh_on_Y
    jmp Check_next_meeting_pacman_with_ghost 
    
Check_meeting_pac_gh_on_Y:                ;Ïðîâåðêà êîîðäèíàò ïî Y
    cmp al, Pacman_position_Y
    je Decrement_health
    jmp Check_next_meeting_pacman_with_ghost
            
Check_next_meeting_pacman_with_ghost:     ;Ïåðåõîä ê ñëåäóþùåìó ïðèçðàêó
    inc si
loop Meeting_pacman_with_ghosts_checking_loop               
    pop ax
    pop cx
    pop si
    ret 

Decrement_health:                         ;Óìåíüøåíèå æèçíè
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
Real_good_game proc                     ;ÎÊÎÍ×ÀÍÈÅ ÈÃÐÛ ÂÛÈÃÐÛØÅÌ
    call Draw_win_string                ;Îòðèñîâêà ñîîáùåíèÿ ñ÷åòà
    call Draw_reset_quit_str
Waiting_pressed_F_:    
    Press_key                           ;Íàæàòèå êëàâèøè  
    Clear_keyboard_buf                  ;Î÷èñòêà áóôåðà êëàâèàòóðû  
    
    cmp al, 'r'                         ;Ïåðåçàïóñê èãðû
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    cmp ah, 0Fh                         ;Âûõîä èç èãðû
    je End_of_game
    
    jmp Waiting_pressed_F_  
    ret 
Real_good_game endp

;/----------------------------------------------------------------------/
Good_game_well_played proc              ;ÎÊÎÍ×ÀÍÈÅ ÈÃÐÛ ÏÐÎÈÃÐÛØÅÌ
    call Draw_clean_pause_string        ;Ñòèðàíèå ñîîáùåíèé ìåíþ
    call Draw_lose_string               ;Îòðèñîâêà ñîîáùåíèÿ ñ÷åòà
    call Draw_reset_quit_str
Waiting_pressed_F:    
    Press_key                           ;Íàæàòèå êëàâèøè  
    Clear_keyboard_buf                  ;Î÷èñòêà áóôåðà êëàâèàòóðû  
    
    cmp al, 'r'                         ;Ïåðåçàïóñê èãðû
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    cmp ah, 0Fh                         ;Âûõîä èç èãðû
    je End_of_game
    
    jmp Waiting_pressed_F  
    ret  
Good_game_well_played endp

;/---------------------------------------------------------------------/
Meeting_pacman_with_apple_checking proc  ;ÏÐÎÂÅÐÊÀ ÂÑÒÐÅ×È ÏÀÊÌÀÍÀ Ñ ßÁËÎÊÎÌ
    push ax                     
    
Meeting_pacman_with_apple_on_X:          ;Ïðîâåðêà âñòðå÷è ïî îñè Õ
    mov ah, Apple_position_X
    mov al, Pacman_position_X
    cmp ah, al                           
    je Meeting_pacman_with_apple_on_Y    ;Åñëè êîîðäèíàòû ïî Õ ñîâïàäàþò
    jmp End_meeting_pacman_with_apple  
    
Meeting_pacman_with_apple_on_Y:          ;Ïðîâåðêà âñòðå÷è ïî îñè Y     
    mov ah, Apple_position_Y
    mov al, Pacman_position_Y
    cmp ah, al
    je Rewriting_score                   ;Åñëè êîîðäèíàòû ñîâïàäàþò, òî ïåðåçàïèñü ñ÷åòà
    jmp End_meeting_pacman_with_apple
        
Rewriting_score:                         ;Èíêðåìåíòèðîâàíèå ñ÷åòà
    inc Count_of_apple  
    call Apple_appearance 
    
    push ax                              ;Ïðîâåðêà íà ïîáåäó
    mov al, Count_of_apple 
    mov ah, Max_count_of_apples 
    cmp al, ah 
    je call Real_good_game               ;Â ñëó÷àå ïîáåäû 
    pop ax   
                
    jmp End_meeting_pacman_with_apple    
        
End_meeting_pacman_with_apple:
    pop ax    
    ret
Meeting_pacman_with_apple_checking endp
 
;/------------------------------------------------------------------/ 
Meeting_ghosts_with_apple_checking proc  ;ÏÐÎÂÅÐÊÀ ÂÑÒÐÅ×È ÏÐÈÇÐÀÊÀ Ñ ßÁËÎÊÎÌ
    push ax                     
    
Meeting_ghost_with_apple_on_X:           ;Ñðàâíåíèå ïîçèöèé ýëåìåíòîâ ïî îñè Õ
    mov ah, Apple_position_X
    mov al, Ghosts_position_X[si]
    cmp ah, al
    je Meeting_ghost_with_apple_on_Y     ;Åñëè ñîâïàëà, òî ïðîâåðêà äðóãîé îñè
    jmp End_meeting_ghosts_with_apple  
        
Meeting_ghost_with_apple_on_Y:           ;Ïðîâåðêà îñè Y
    mov ah, Apple_position_Y
    mov al, Ghosts_position_Y[si]
    cmp ah, al
    je Rebraw_apple                      ;Åñëè ñîâïàëà, òî ïåðåðèñîâûâàíèå ÿáëîêà
    jmp End_meeting_ghosts_with_apple
        
Rebraw_apple:                            ;Ïåðåðèñîâûâàíèå ÿáëîêà
    call Drawing_apple
        
End_meeting_ghosts_with_apple:
    pop ax    
    ret
Meeting_ghosts_with_apple_checking endp  

;/----------------------------------------------------------------------------/
Pacman_appearance proc                  ;ÏÎßÂËÅÍÈÅ ÏÀÊÌÀÍÀ
    mov Pacman_position_X, 1            ;Óñòàíîâêà ïîçèöèè ïàêìàíà
    mov Pacman_position_Y, 1
    mov Pacman_current_direction, 2     ;Óñòàíîâêà òåêóùåãî íàïðàâëåíèÿ ïàêìàíà(íàëåâî)
    mov Pacman_next_direction, 2
    call Drawing_pacman                 ;Îòðèñîâêà ïàêìàíà
    ret
Pacman_appearance endp

;/-----------------------------------------------------------------------------/
Keypress_check proc                     ;ÏÐÎÂÅÐÊÀ ÍÀÆÀÒÈß ÊËÀÂÈØÈ
    Check_key_pressed
    jnz If_pressed                      ;Åñëè íàæàòèå êëàâèøè äîñòóïíî
    
    mov Flag_moving_pacman, 0
    ret
        
If_pressed:                             ;Åñëè íàæàòà     
    mov Flag_moving_pacman, 1
    Press_key                           ;Íàæàòèå êëàâèøè 
    Clear_keyboard_buf                  ;Î÷èñòêà áóôåðà êëàâèàòóðû
    
    cmp al, 'w'                         ;Åñëè íàæàòà ââåðõ
    je Pacman_direction_up 
    cmp al, 'W'
    je Pacman_direction_up
    cmp ah, 48h
    je Pacman_direction_up
    
    cmp al, 's'                         ;Åñëè íàæàòà âíèç
    je Pacman_direction_down  
    cmp al, 'S'
    je Pacman_direction_down
    cmp ah, 50h
    je Pacman_direction_down    
    
    cmp al, 'a'                         ;Åñëè íàæàòà âëåâî
    je Pacman_direction_left 
    cmp al, 'A'
    je Pacman_direction_left
    cmp ah, 4bh
    je Pacman_direction_left
        
    cmp al, 'd'                         ;Åñëè íàæàòà âïðàâî
    je Pacman_direction_right 
    cmp al, 'D'
    je Pacman_direction_right    
    cmp ah, 4dh
    je Pacman_direction_right

    cmp ah, 01h
    je call Stop_game
    
    mov Pacman_next_direction, 5             ;;;;;;;;;
    ret
        
Pacman_direction_up:                    ;Óñòàíîâêà íàïðàâëåíèÿ äâèæåíèÿ ââåðõ 
    mov Pacman_next_direction, 0
    ret   
    
Pacman_direction_down:
    mov Pacman_next_direction, 1        ;Óñòàíîâêà äâèæåíèÿ âíèç
    ret    
    
Pacman_direction_left:                  ;Óñòàíîâêà äâèæåíèÿ âëåâî
    mov Pacman_next_direction, 2
    ret  
    
Pacman_direction_right:                 ;Óñòàíîâêà äâèæåíèÿ âïðàâî
    mov Pacman_next_direction, 3
    ret 
    
Keypress_check endp                                                    

;/----------------------------------------------------------------/
Stop_game proc                          ;ÏÀÓÇÀ ÈÃÐÛ   
    push ax      
    call Draw_pause_string              ;Ïîÿâëåíèå ñîîáùåíèé î ìåíþ   
    call Draw_reset_quit_str
If_pause_pressed:    
    Press_key                           ;Íàæàòèå êëàâèøè  
    Clear_keyboard_buf                  ;Î÷èñòêà áóôåðà êëàâèàòóðû  
    cmp ah, 1Ch                         ;Ïðîäîëæèòü èãðó
    je End_pause 
    
    cmp ah, 0Fh                         ;Êîíåö èãðû
    je End_of_game 
    
    cmp al, 'r'                         ;Ïåðåçàïóñê èãðû
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    jmp If_pause_pressed 
    
End_pause:
    call Draw_clean_pause_string        ;Ñòèðàíèå ñîîáùåíèé ìåíþ
    pop ax
    ret    
Stop_game endp   

;/----------------------------------------------------------------/
Reset_game proc                         ;ÏÅÐÅÇÀÏÓÑÒÈÒÜ ÈÃÐÓ                 
    Set_screen 
    jmp start
    ret
Reset_game endp  

;/----------------------------------------------------------------/    
Delete_pacman proc                      ;ÓÄÀËÅÍÈÅ ÏÀÊÌÀÍÀ
    mov ah, Pacman_position_X 
    mov al, Pacman_position_Y
    Draw_element Empty_element          ;Ðèñîâêà íà ìåñòî ïàêìàíà ïóñòîãî áëîêà
    ret
Delete_pacman endp

;/----------------------------------------------------------------/ 
Rewriting_pacman_positions proc         ;ÏÅÐÅÇÀÏÈÑÜ ÒÅÊÓÙÅÉ ÏÎÇÈÖÈÈ ÏÀÊÌÀÍÀ
    cmp Pacman_current_direction, 0     ;Ïîëó÷åíèå òåêóùåãî íàïðâëåíèÿ ïàêìàíà 
    je Rewritting_pacman_on_up
    cmp Pacman_current_direction, 1
    je Rewritting_pacman_on_down
    cmp Pacman_current_direction, 2
    je Rewritting_pacman_on_left
    cmp Pacman_current_direction, 3
    je Rewritting_pacman_on_right             
    
Rewritting_pacman_on_up:                ;Ïåðåçàïèñü íàïðàâëåíèÿ íà ââåðõ        
        dec Pacman_position_Y
        ret
  
Rewritting_pacman_on_down:              ;Ïåðåçàïèñü íàïðàâëåíèÿ íà âíèç
        inc Pacman_position_Y
        ret
   
Rewritting_pacman_on_left:              ;Ïåðåçàïèñü íàïðàâëåíèÿ íà âëåâî
        dec Pacman_position_X
        ret
  
Rewritting_pacman_on_right:             ;Ïåðåçàïèñü íàïðàâëåíèÿ íà âïðàâî 
        inc Pacman_position_X
        ret
Rewriting_pacman_positions endp                                       

;/----------------------------------------------------------------/
Drawing_pacman proc                     ;ÎÒÐÈÑÎÂÊÀ ÏÀÊÌÀÍÀ
    mov ah, Pacman_position_X           ;Ïîëó÷åíèå òåêóùåé ïîçèöèè ïàêìàíà íà ïîëå
    mov al, Pacman_position_Y
    
    cmp Pacman_current_direction, 0     ;Ïîëó÷åíèå íàïðàâëåíèÿ äâèæåíèÿ ïàêìàíà 
    je Drawing_pacman_up   
    
    cmp Pacman_current_direction, 1
    je Drawing_pacman_down
    
    cmp Pacman_current_direction, 2
    je Drawing_pacman_left
    
    cmp Pacman_current_direction, 3
    je Drawing_pacman_right    
    
Drawing_pacman_up:                      ;Åñëè äâèæåíèå ââåðõ                
        Draw_element Pacman_UP
        jmp Drawing_pacman_complete

Drawing_pacman_down:                    ;Åñëè äâèæåíèå âíèç
        Draw_element Pacman_DOWN
        jmp Drawing_pacman_complete
    
Drawing_pacman_left:                    ;Åñëè äâèæåíèå âëåâî
        Draw_element Pacman_LEFT
        jmp Drawing_pacman_complete
    
Drawing_pacman_right:                   ;Åñëè äâèæåíèå âíèç
        Draw_element Pacman_RIGHT
        jmp Drawing_pacman_complete
    
Drawing_pacman_complete:
        ret
Drawing_pacman endp     

;/------------------------------------------------------------------/ 
Moving_pacman proc                        ;ÄÂÈÆÅÍÈÅ ÎÑÍÎÂÍÎÃÎ ÏÅÐÑÎÍÀÆÀ
    push ax
    push bx
    call Keypress_check                   ;Ïðîâåðêà íàæàòèÿ êëàâèøè äâèæåíèÿ ïàêìàíà
    
    cmp Pacman_next_direction, 5          ;Åñëè íå íàæàòà êëàâèøà íàïðàâëåíèÿ
    je Moving_pacman_complete              ;;;;;;;;;;
    cmp Flag_moving_pacman, 0             ;Åñëè íå óñòàíîâëåí ôëàã äâèæåíèÿ
    je Moving_pacman_complete              ;;;;;;;;;;    
                
Check_pacman_next_direction:
    mov ah, Pacman_position_X              ;Ïîëó÷åíèå òåêóùåé ïîçèöèè êëàâèøè
    mov al, Pacman_position_Y
    mov bl, Pacman_next_direction          ;Ïîëó÷åíèå ñëåäóþùåãî íàïðàâëåíèÿ
    call Check_direction_object            ;Ïðîöåäóðà ïðîâåðêè îáúåêòà ïî íàïðàâëåíèþ äâèæåíèÿ
    cmp ax, em
    je Change_to_new_direction_pacman      ;Åñëè ñâîáîäíàÿ ïîçèöèÿ 
       
Check_current_position_pacman:             ;Ïîëó÷åíèå òåêóùåé ïîçèöèè ïàêìàíà
    mov ah, Pacman_position_X 
    mov al, Pacman_position_Y
    mov bl, Pacman_current_direction        
    call Check_direction_object            ;Ïîëó÷åíèå îáúåêòà ïî òåêóùåé ïîçèöèè
    cmp ax, em                             ;Åñëè ñâîáîäíàÿ ÿ÷åéêà
    je Redraw_pacman                       ;Ïåðåðèñîâûâàíèå ïàêìàíà íà òåêóùóþ æå ïîçèöèþ
    cmp ax, wl
    je Moving_pacman_complete    
    
Change_to_new_direction_pacman:            ;Ïåðåçàïèñü íàïðàâëåíèÿ äâèæåíèÿ ïàêìàíà 
    mov ah, Pacman_next_direction     
    mov Pacman_current_direction, ah
                
Redraw_pacman:    
    call Delete_pacman                       ;Óäàëåíèå ïàêìàíà
    call Rewriting_pacman_positions          ;Ïåðåçàïèñü êîîðäèíàò ïàêìàíà
    call Meeting_pacman_with_ghosts_checking ;Ïðîâåðêà âñòðå÷è ïàêìàíà è ïðèçðàêà
    call Meeting_pacman_with_apple_checking  ;Ïðîâåðêà âñòðå÷è ïàêìàíà ñ ÿáëîêîì
    call Drawing_pacman                      ;Îòðèñîâêà ïàêìàíà
        
Moving_pacman_complete:     
    pop bx 
    pop ax  
    ret
Moving_pacman endp
 
;/--------------------------------------------------------------------/           
Ghosts_appearance proc              ;ÏÎßÂËÅÍÈÅ ÏÐÈÇÐÀÊÎÂ
    Rewriting_param                 ;Îáíîâëåíèå ïàðàìåòðîâ ðàíäîìà
    
    mov cx, Max_count_of_ghosts     ;Ïåðåäà÷à ÷èñëà ïàðàìåòðîâ
    mov si, 0
    
Appearance_ghost_loop:        
Create_ghost:
    ;Get_random_number_macro Field_length_X   ;Ïîëó÷åíèå ïîçèöèè ãäå ïîÿâèòñÿ ïðèçðàê
    Get_random_number_macro Field_length   ;Ïîëó÷åíèå ïîçèöèè ãäå ïîÿâèòñÿ ïðèçðàê
    mov Ghosts_position_X[si], al  
    Get_random_number_macro Field_length   ;Ïîëó÷åíèå ïîçèöèè ãäå ïîÿâèòñÿ ïðèçðàê    
    ;Get_random_number_macro Field_length_Y
    mov Ghosts_position_Y[si], al   
    
    Get_random_number_macro 4              ;Ïîëó÷åíèå íàïðàâëåíèÿ äëÿ äâèæåíèÿ ïàêìàíà 
    mov Ghosts_current_direction[si], al
    Get_random_number_macro 4              ;Ïîëó÷åíèå öâåòà ïðèçðàêà
    mov Ghosts_colors[si], al              
    
    mov ah, Ghosts_position_X[si]
    mov al, Ghosts_position_Y[si]
    Get_element                      ;Ïîëó÷åíèå ýëåìåíòà, íàõîäÿùåãî ïî äàííîé ïîçèöèè(ãäå äîëæåí ïîÿâèòñÿ ïðèçðàê)
    cmp ax, em                       ;Åñëè ïóñòîå ïðîñòðàíñòâî (ìîæíî ñòàâèòü ïðèçðàêà)
    je Create_next_chost
    jmp Create_ghost
                 
Create_next_chost:                   ;Ñîçäàíèå ñëåäóþùåãî ïðèçðàêà
    call Drawing_chost
    inc si
loop Appearance_ghost_loop    
    
    mov Ghosts_delay_counter, 0      ;Óñòàíîâêà íà÷àëüíî çàäåðæêè 
    ret
Ghosts_appearance endp                                              

;/-----------------------------------------------------------------/
Delete_chost proc                    ;ÓÄÀËÅÍÈÅ ÏÐÈÇÐÀÊÀ
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
    Draw_element Empty_element       ;Óñòàíîâêà íà ìåñòî ïðèçðàêà ïóñòîãî áëîêà
    ret
Delete_chost endp

;/-----------------------------------------------------------------/ 
Rewriting_ghost_position proc        ;ÏÅÐÅÇÀÏÈÑÜ ÒÅÊÓÙÅÉ ÏÎÇÈÖÈÈ ÏÐÈÇÐÀÊÀ
    cmp bl, 0                        ;Ïîëó÷åíèå äàííûõ î íàïðàâëåíèè äâèæåíèÿ ïðèçðàêà
    je Moving_chost_in_up
    cmp bl, 1
    je Moving_chost_in_down
    cmp bl, 2
    je Moving_chost_in_left
    cmp bl, 3
    je Moving_chost_in_right             
    
Moving_chost_in_up:                  ;Äåêðåìåíòèðîâàíèå ïîçèöèè ïî Y
    dec Ghosts_position_Y[si]
    ret

Moving_chost_in_down:                ;Èêðåìåíòèðîâàíèå ïîçèöèè ïî Y
    inc Ghosts_position_Y[si]
    ret
  
Moving_chost_in_left:                ;Äåêðåìåíòèðîâàíèå ïîçèöèè ïî Õ 
    dec Ghosts_position_X[si]
    ret
   
Moving_chost_in_right:               ;Èêðåìåíòèðîâàíèå ïîçèöèè ïî Õ   
    inc Ghosts_position_X[si]
    ret
Rewriting_ghost_position endp

;/----------------------------------------------------------/    
Drawing_chost proc                   ;Îòðèñîâêà ïðèçðàêà
    mov ah, Ghosts_position_X[si]    ;Ïîëó÷åíèå ïîçèöèè ïðèçðàêà
    mov al, Ghosts_position_Y[si]
    
    mov bl, Ghosts_colors[si]        ;Ïîëó÷åíèå öâåòà
    cmp bl, 0                        ;Åñëè ñèíèé
    je Drawing_chost_on_blue
    cmp bl, 1                        ;Åñëè çåëåíûé
    je Drawing_chost_on_green
    cmp bl, 2                        ;Åñëè ôèîëåòîâûé
    je Drawing_chost_on_purple
    cmp bl, 3                        ;Åñëè ñåðûé
    je Drawing_chost_on_gray 
    
Drawing_chost_on_blue:               ;Îòðèñîâêà ñèíåãî ïðèçðàêà
    Draw_element Ghost_blue
    jmp Drawing_chost_complete
    
Drawing_chost_on_green:              ;Îòðèñîâêà çåëåíîãî ïðèçðàêà
    Draw_element Ghost_green
    jmp Drawing_chost_complete
  
Drawing_chost_on_purple:             ;Îòðèñîâêà ôèîëåòîâîãî ïðèçðàêà
    Draw_element Ghost_purple
    jmp Drawing_chost_complete
    
Drawing_chost_on_gray:               ;Îòðèñîâêà ñåðîãî ïðèçðàêà
    Draw_element Ghost_gray
    jmp Drawing_chost_complete
    
Drawing_chost_complete:
        ret
Drawing_chost endp         

;/---------------------------------------------------------------------/
Getting_prev_direction proc          ;ÏÎËÓ×ÅÍÈÅ ÏÐÛÄÛÄÓØÅÃÎ ÍÀÏÐÀÂËÅÍÈß
    cmp bl, 2
    jge If_current_left_right        ;Åñëè òåêóùåå íàïðàâëåíèå óêàçûâàåò íàëåâî èëè íàïðàâî
    jmp If_current_up_down           ;Åñëè óêàçûâàåò íà íèç èëè âåðõ
    
If_current_left_right:               ;Åñëè ïðàâî-ëåâî
    cmp bl, 2
    je Left_to_right
    jmp Right_to_left 
    
If_current_up_down:                  ;Åñëè âåðõ-íèç
    cmp bl, 1
    je Down_to_up
    jmp Up_to_down
    
Up_to_down:                          ;Åñëè âåðõ, òî ìåíÿåì íà íèç
    mov bl, 1
    ret
         
Down_to_up:                          ;Åñëè íèç, òî ìåíÿåì íà âåðõ
    mov bl, 0
    ret
        
Left_to_right:                       ;Åñëè ëåâî, òî ìåíÿåì íà ïðàâî
    mov bl, 3
    ret 
        
Right_to_left:                       ;Åñëè ïðàâî, òî ìåíÿåì 
    mov bl, 2        
    ret
Getting_prev_direction endp

;/-----------------------------------------------------------------------/
Moving_chosts proc                   ;ÏÅÐÅÄÂÈÆÅÍÈÅ ÏÐÈÇÐÀÊÎÂ
    push ax
    push bx
    push cx
                  
    inc Ghosts_delay_counter        ;Ïîëó÷åíèå ÷èñëà çàäåðæêè ïðèçðàêîâ 
    push ax
    mov ah, Ghosts_max_delay_moving 
    cmp Ghosts_delay_counter, ah
    pop ax
    jne Moving_chosts_complete
        
    mov Ghosts_delay_counter, 0
    Rewriting_param                 ;Ïåðåñ÷åò ïàðìåòðîâ äëÿ ðàíäîìà
            
    mov cx, Max_count_of_ghosts
    mov si, 0
    
Moving_chosts_loop: 
Check_random_chosts_direction:
    Get_random_number_macro 4       ;Ïîëó÷åíèå ðàíäîìíîãî íàïðàâëåíèÿ
    mov bl, al
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
    call Check_direction_object     ;Ïðîâåðêà íà îáúåêò íàõîäÿùèéñÿ ïî äàííîìó íàïðàâëåíèþ
    
    cmp ax, em                      ;Åñëè ïî õîäó äâèæåíèÿ ïóñòîå ïðîñòðàíñòâî
    je Check_prev_direction
    cmp ax, wl                      ;Åñëè ñòåíà, òî ïåðåñ÷åò ðàíäîìíîãî íàïðàâëåíèÿ
    je Check_random_chosts_direction
        
Check_prev_direction:               ;Ïðîâåðêà ïðåäûäóùåãî íàïðàâëåíèÿ
    call Getting_prev_direction
    mov bh, Ghosts_current_direction[si]
    cmp bh, bl
    je Check_random_chosts_direction ;Åñëè ïðåäûäóùåå è òåêóùåå íàïðàâëåíèÿ ñîâïàäàþò
            
Set_ghosts_direction_on_next_:
    call Getting_prev_direction     ;Îáðàòíîå ïîëó÷åíèå íàïðàâëåíèÿ
    mov Ghosts_current_direction[si], bl
            
Rebraw_chost:    
    call Delete_chost                        ;Óäàëåíèå ïðèçðàêà               
    call Meeting_ghosts_with_apple_checking  ;Ïðîâåðêà âñòðå÷è ïðèçðàêà ñ ÿáëîêîì
    call Rewriting_ghost_position            ;Ïåðåçàïèñü ïîçèöèè ïðèçðàêà
    call Meeting_pacman_with_ghosts_checking ;Ïðîâåðêà âñòðå÷è ïàêìàíà è ïðèçðàêà             
    call Drawing_chost                       ;Ïåðåðèñîâûâàíèå ïðèçðàêà
            
    inc si
loop Moving_chosts_loop
    
Moving_chosts_complete:     
    pop cx 
    pop bx
    pop ax  
    ret
Moving_chosts endp               
                   
;/---------------------------------------------------------/           
Convert_num_to_str proc      ;ÏÅÐÅÂÎÄ ÈÇ ×ÈÑËÀ Â ÑÒÐÎÊÓ
    push bp                  ;Ñîõðàíåíèå bp
    mov bp, sp               ;Bp - âåðøèíà ñòåêà     
    mov ax, [bp + 6]
    mov si, [bp + 4]         ;Ñ÷èòûâàíèå 4ãî ïàðàìåòðà
    
    xor cx, cx               
    mov bx, 10                
        
Getting_number_digits:
    xor dx, dx
    div bx                    
    push dx                  ;Çàíåñåíèå îñòàòêà  
    inc cx                   ;Ïîëó÷åíèå ÷èñëà ðàçðÿäîâ
    cmp ax, 0                ;Ïîêà íå çàêîí÷èëàñü ñòàðøàÿ ÷àñòü
jne Getting_number_digits
        
Draw_digit_loop:
    pop dx
    add dx, 30h              ;Ïåðåâîä â ñèâîëüíîå çíà÷åíèå ÷èñëà
    mov dh, Green_colour     
    mov word ptr [si], dx    ;Çàïèñü ñ÷åòà â ïåðåìåííóþ
    add si, 2
loop Draw_digit_loop

    pop bp
    ret 4
Convert_num_to_str endp

;/----------------------------------------------------------/
Drawing_count_of_apple proc     ;ÎÒÐÈÑÎÂÊÀ ×ÈÑËÀ ßÁËÎÊ
    xor cx, cx
    mov cl, Count_of_apple
    push cx
    push offset Apple_counting_str   
    call Convert_num_to_str     ;Ïåðåâîä ÷èñëà â ñòðîêó è îòðèñîâêà 

    mov si, offset Apple_counting_str
    mov di, Total_current_score_offset
    mov cx, 4                
    rep movsw                   ;Ïåðåíîñ ñòðîêè èç DS:SI â ES:DI
    ret
Drawing_count_of_apple endp

;/----------------------------------------------------------/
Drawing_apple proc              ;ÎÒÐÈÑÎÂÊÀ ßÁËÎÊÀ
    mov ah, Apple_position_X 
    mov al, Apple_position_Y
    Draw_element Apple          ;Ïîëó÷åíèå ÿáëîêà 
    ret
Drawing_apple endp

;/----------------------------------------------------------/
Apple_appearance proc           ;ÏÎßÂËÅÍÈÅ ßÁËÎÊÀ
    Rewriting_param
         
Setting_apple_position:
    ;Get_random_number_macro Field_length_X ;Ïîëó÷åíèå êîîðäèíàò ÿáëîêà
    Get_random_number_macro Field_length   ;Ïîëó÷åíèå ïîçèöèè ãäå ïîÿâèòñÿ ïðèçðàê
    mov Apple_position_X, al 
    Get_random_number_macro Field_length   ;Ïîëó÷åíèå ïîçèöèè ãäå ïîÿâèòñÿ ïðèçðàê
    ;Get_random_number_macro Field_length_Y
    mov Apple_position_Y, al  
    
    mov ah, Apple_position_X 
    mov al, Apple_position_Y
    Get_element                 ;Ïîëó÷åíèå ýëåìåíòà ïî ïîçèöèè óñòàíîâêàè ÿáëîêà
    cmp ax, em
    je Create_apple
    jmp Setting_apple_position
    
Create_apple:
    call Drawing_apple          ;Îòðèñîâêà ÿáëîêà
    call Drawing_count_of_apple ;Îòðèñîâêà ñ÷åòà
    ret
Apple_appearance endp   

;/----------------------------------------------------------/
Draw_count_of_heart proc           ;ÎÒÐÈÑÎÂÊÀ ÆÈÇÍÅÉ
    push ax
    push bx 
    
    mov ah, Health_position_X      ;Ïîëó÷åíèå êîîðäèíàò 
    mov al, Health_position_Y 
    
    mov bl, Count_of_health        ;Ïîëó÷åíèå ÷èñëà æèçíåé
    cmp bl, 3
    je Draw_tree_health
    cmp bl, 2
    je Draw_two_health
    cmp bl, 1
    je Draw_one_health
    cmp bl, 0 
    je Draw_zero_health
    
Draw_tree_health:                  ;Îòðèñîâêà 3 æèçíåé
    Draw_element Health_tree     
    pop bx
    pop ax
    ret    

Draw_two_health:                   ;Îòðèñîâêà 2 æèçíåé
    Draw_element Health_two     
    pop bx
    pop ax
    ret    

Draw_one_health:                   ;Îòðèñîâêà 1 æèçíè
    Draw_element Health_one     
    pop bx
    pop ax
    ret     
    
Draw_zero_health:                  ;Îòðèñîâêà 0 æèçíè
    Draw_element Health_zero     
    pop bx
    pop ax
    ret    
Draw_count_of_heart endp

;/------------------------------------------------------/ 
Select_difficulty proc             ;ÂÛÁÎÐ ÑËÎÆÍÎÑÒÈ
    Write_macro Hello_str
    Write_macro Easy_str
    Write_macro Medium_str
    Write_macro Hard_str    
    Write_macro Unreal_str
    
Enter_difficulty_selection:     ;Ââîä âûáîðà èãðîêîì ðåæèìà
    mov ah,01h                  ;Ñ÷èòûâàíèå ñèìâîëà èç ñòàíäàðòíîãî â/ââ
    int 21h
    Clear_keyboard_buf          ;Î÷èñòêà áóôåðà êëàâèàòóðû
                                
    cmp al, '1'                 ;Âûáîð ñëîæíîñòè
    je Easy_dif
    cmp al, '2'
    je Medium_dif
    cmp al, '3'
    je Hard_dif
    cmp al, '4'
    je Unreal_dif   
    jmp Enter_difficulty_selection
    
Easy_dif:                       ;Ëåãêàÿ ñëîæíîñòü
    mov ah, Easy_apples  
    mov Max_count_of_apples, ah
    mov ax, Easy_chosts  
    mov Max_count_of_ghosts, ax
    mov ax, Easy_pause
    mov Game_loop_pause, ax        
    xor ax,ax
    ret
    
Medium_dif:                     ;Ñðåäíÿÿ ñëîæíîñòü
    mov ah, Medium_apples  
    mov Max_count_of_apples, ah 
    mov ax, Medium_chosts  
    mov Max_count_of_ghosts, ax
    mov ax, Medium_pause
    mov Game_loop_pause, ax
    xor ax,ax
    ret    
    
Hard_dif:                       ;Òÿæåëàÿ ñëîæíîñòü
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
    
Unreal_dif:                     ;Íåðåàëüíàÿ ñëîæíîñòü
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
