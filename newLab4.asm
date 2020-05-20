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

;/-----------------------������� ���������------------------------------------/              
Hello_str                       db   "HELLO! PLEASE, CHOOSE...",                                           0Ah,0Dh,    "$"                        
Easy_str                        db   "1. Easy: play up to 10 points with 4 ghosts!",                       0Ah,0Dh,    "$"
Medium_str                      db   "2. Medium: play up to 15 poits with 5 ghosts!",                      0Ah,0Dh,    "$"   
Hard_str                        db   "3. Hard: play up to 20 points with 6 ghosts!",                       0Ah,0Dh,    "$"
Unreal_str                      db   "4. ", 02h," UNREAL ", 02h ,": play up to 30 points with 7 ghosts!",  0Ah,0Dh,    "$"

;/-----------------------��������� ����������--------------------------------/ 
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

;/-----------------------������ � ����������----------------------------------/    
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
    
;/-----------------------������ � ��������----------------------------------/    
Pacman_position_X               db  ?
Pacman_position_Y               db  ?
Pacman_current_direction        db  ?
Pacman_next_direction           db  ? 
Flag_moving_pacman              db  0   
                             ;������;|�������; 0� - ������ �� ������
Pacman_UP                       dw  0E5Ch, 0E2Fh  ;0000111001011100b, 0000111000101111b ; "\/"  
Pacman_DOWN                     dw  0E2Fh, 0E5Ch  ;0000111000101111b, 0000111001011100b ; "/\"
Pacman_LEFT                     dw  0E3Eh, 0E4Fh  ;0000111000111110b, 0000111000101101b ; ">0" 
Pacman_RIGHT                    dw  0E4Fh, 0E3Ch  ;0000111000101101b, 0000111000111100b ; "0<"   

;/-----------------------������ � �������----------------------------------/
Max_count_of_apples             db  ?     
Count_of_apple                  db  0
Apple_position_X                db  ?
Apple_position_Y                db  ?
Apple                           dw  0C3Ch, 0C3Eh ;0000110000101000b, 0000110000101001b ; red "<>"  on black 
Apple_counting_str              dw  4 dup(?)   

;/------------------------������ � ������ � �������------------------------/
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
        
    mov ax, 0B800h                       ;������� �����������
    mov es, ax                           ;�������� � es ������ �����������

Return_to_start:                             
    mov Count_of_apple, 0                ;��������� ����� 
    Set_screen   
    call Field_display                   ;��������� �������� ����
    call Draw_score_string               ;��������� ��������� �����    
    call Draw_count_of_heart             ;��������� ����� ������
    call Pacman_appearance               ;��������� �������
    call Ghosts_appearance               ;��������� ���������
    call Apple_appearance                ;��������� ������
    
Main_cycle:
    Waiting
    call Moving_pacman                   ;�������� �������
    call Moving_chosts                   ;�������� ��������
jmp Main_cycle       

End_of_game: 
    Set_screen
    mov ax, 4c00h
    int 21h                                                                          
    
    
;/------------------------------------------------------------------------------/                
Field_display  proc                  ;��������� ����              
    push si
    push di
    push ax
    push cx
    
    mov si, offset Screen_matrix     ;�������� ����
    mov di, Offset_position_on_field ;�������� �������� ����� ������              
    ;mov cx, Field_length_Y          ;�������� ������� ����� ����
    mov cx, Field_length             ;�������� ������� ����� ����
     
Loop_render_by_string:              
    push cx
    ;mov cx, Field_length_X          ;���� ��������� �� �������
    mov cx, Field_length             ;���� ��������� �� �������
    
Loop_render_by_columns:
    push cx            
    mov ax, ds:[si]                  ;�������� �������
    mov cx, 2    
        
Loop_render_one_element:             ;��������� ��������
    mov word ptr es:[di], ax         ;�������� ��� ������� ������������ ��� �����
    add di, 2
loop Loop_render_one_element       

    add si, 2            
    pop cx
loop Loop_render_by_columns   
    
    add di, 2 * 2 * (Max_window_size_X - Field_length) ;������� �� ����� ������
    ;add di, 2 * 2 * (Max_window_size_X - Field_length_X) ;������� �� ����� ������
    pop cx
loop Loop_render_by_string
   
    pop cx
    pop ax
    pop di
    pop si
    ret
Field_display  endp
                             
;/-------------------------------------------------------------------/
Draw_score_string proc             ;������ ������ �����
    mov si, offset Score_str       ;�������� ������
    mov di, Total_score_str_offset ;�������� �������� 
    mov cx, Score_str_length       ;��������� ����� ������

Draw_score_loop:
    mov ah, Green_colour           ;00001010b(������� ����)
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_score_loop       
    ret
Draw_score_string endp

;/-------------------------------------------------------------------/
Draw_lose_string proc              ;������ ������ ���������
    mov si, offset You_lose_str    ;�������� ������
    mov di, Total_lose_str_offset  ;�������� ��������
    mov cx, Lose_length            ;��������� ����� ������

Draw_lose_loop:
    mov ah, Red_colour             ;000000100b(������� ����)
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_lose_loop    
    ret
Draw_lose_string endp  

;/-------------------------------------------------------------------/
Draw_pause_string proc              ;������ ������ �����
   
Draw_pause:   
    mov si, offset Pause_str        ;�������� ������
    mov di, Total_pause_str_offset  ;�������� ��������
    mov cx, Pause_length            ;��������� ����� ������

Draw_pause_loop:
    mov ah, Brown_colour              
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_pause_loop
        
        
Draw_key_enter:
    mov si, offset Enter_str        ;�������� ������
    mov di, Total_enter_str_offset  ;�������� ��������
    mov cx, Enter_length            ;��������� ����� ������

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
Draw_reset_quit_str proc           ;��������� ������ ��������  � ������ ������� 
    
Draw_key_quit:
    mov si, offset Quit_str        ;�������� ������
    mov di, Total_quit_str_offset  ;�������� ��������
    mov cx, Quit_length            ;��������� ����� ������

Draw_quit_loop:
    mov ah, White_colour              
    mov al, [si]
    mov word ptr es:[di], ax
    inc si
    add di, 2
loop Draw_quit_loop  
       
       
Draw_key_reset:
    mov si, offset Reset_str        ;�������� ������
    mov di, Total_reset_str_offset  ;�������� ��������
    mov cx, Reset_length            ;��������� ����� ������

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
Draw_clean_pause_string proc        ;������� ������ �����

Clean_pause:    
    mov di, Total_pause_str_offset  ;�������� ��������
    mov cx, Pause_length            ;��������� ����� ������

Clean_pause_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_pause_loop 
        
        
Clean_enter:    
    mov di, Total_enter_str_offset  ;�������� ��������
    mov cx, Enter_length            ;��������� ����� ������

Clean_enter_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_enter_loop 
     
     
Clean_quit:    
    mov di, Total_quit_str_offset  ;�������� ��������
    mov cx, Quit_length            ;��������� ����� ������

Clean_quit_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_quit_loop   
        
        
Clean_reset:    
    mov di, Total_reset_str_offset  ;�������� ��������
    mov cx, Reset_length            ;��������� ����� ������

Clean_reset_loop:  
    mov word ptr es:[di], em
    add di, 2
loop Clean_reset_loop 
       
    ret
Draw_clean_pause_string endp 

;/-------------------------------------------------------------------/
Draw_win_string proc               ;������ ������ ��������
    mov si, offset You_win_str     ;�������� ������
    mov di, Total_win_str_offset   ;�������� ��������
    mov cx, Win_length             ;��������� ����� ������

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
Set_screen macro                ;��������� ���� � �����������
    push ax
    mov ax, 0003h               ;��������� ����������� 80/25
    int 10h
    pop ax
endm   

;/-------------------------------------------------------------------/
Waiting macro                   ;�������� ��� �������������
    push ax 
    push cx
    push dx 
      
    mov ah, 86h                 ;���������  �������� CX:DX 
    mov cx, 1 
    mov dx, Game_loop_pause
    int 15h
    
    pop dx
    pop cx
    pop ax
endm 

;/--------------------------------------------------------------------/
Check_key_pressed macro          ;�������� ������� �������
    push ax                      
    mov ah, 01h                  ;�������� ����� ���������� 
    int 16h       
    pop ax
endm       

;/---------------------------------------------------------------------/      
Press_key macro                  ;������� �������
    mov ah, 00h
    int 16h                      ; al - ACSCII ��� � ah - ������� �������
endm                                                                      

;/---------------------------------------------------------------------/
Clear_keyboard_buf macro         ;������� ������ ����������
    push ax
    mov ax,0c00h                 ;�������� ��������������� �������
    int 21h       
    pop ax
endm 
          
;/-----------------------------------------------------------------/
Rewriting_param macro       ;���������� ���������� �������
    push dx
    push cx
    
    mov ah, 2ch             ;��������� �������� ���������� �������
    int 21h
    mov Random_low, dh      ;������ ������
    mov Random_high, dl     ;������ ����� ����� �������
    
    pop cx
    pop dx
endm

;/--------------------------------------------------------------/
Calculate_random_parameters macro number shift1 multiplier summand shift2
    push ax             ;�������� ���������� ��� �������
    
    mov al, number      ;�������� �������� ��� ��� ����������
    ror al, shift1      ;shift1(number) �������� �����(����� ������)
    mov ah, multiplier  ;���������
    mul ah              ;������������ ������� � ������� �����
    add al, summand     ;shift1(number) * multiplier + summand
    ror al, shift2      ;C���� ����� ���������� �����
    mov number, al      ;���������� ������� �����
    
    pop ax      
endm

;/-----------------------------------------------------------------/
Update_data_for_random macro    ;���������� ����������
    Calculate_random_parameters Random        2   23  11  5
    Calculate_random_parameters Random_low    1   7   4   3 
    Calculate_random_parameters Random_high   7   5   8   4    
    Calculate_random_parameters Random        6   Random_low  Random_high  1
endm 

;/--------------------------------------------------------------------/
Get_random_number_macro macro Max_var   ; ��������� ���������� �������� ������������ �������� ����������
    push bx
    push dx
    
    Update_data_for_random
    xor ax, ax   
    xor bx, bx
    mov al, Random       ;��������� �������� ��� �������
    mov bl, Max_var      ;��������� ����������� ���������� �������
    cwd                  ;�������������� ����� � ������� �����
    div bx               ;������� � ������������ ���������� ��������
    mov ax, dx           ;���������� ������������ ������� � ax
    
    pop dx 
    pop bx  
endm                                                                    

;/----------------------------------------------------------------------/
Write_macro macro str           ;������ ������ ������
       lea dx, str
       mov ah,09h
       int 21h
endm
;/----------------------------------------------------------------------/
Calculate_element_offset macro Size_X ;��������� �������� ������� ������������ ����
    xor bx, bx
    mov bl, ah                        ;�������� ������� �� �
    mov ah, 0h
    mov dx, Size_X
    mul dx                            ;������������ �������� ��������� �������� �� ��� � �� al(��������� �� Y)
    add ax, bx                        ;�������� �������� � ������� ���� � ��������� �� �
    mov dx, 2 * 2        
    mul dx                            ;������������ ��������� � �������(������� �������� ��������� � ax)
endm 

;/----------------------------------------------------------------------/
Draw_element macro Element       ;��������� ��������
    push si                      ;��������� ��������: � ah - ��������� �� �, � al - ��������� �� Y 
    push di
    push cx
    push bx
    push dx
    
    Calculate_element_offset Max_window_size_X
    mov si, offset Element       ;��������� ��������������� ��������
    mov di, Offset_position_on_field   
    add di, ax                   ;��������� ������� ��� �����������
    mov cx, 2                
    rep movsw                    ;�������� ����(2 �����) �� DS:SI � ES:DI 
    
    pop dx
    pop bx
    pop cx
    pop di
    pop si
endm                                                                        

;/-------------------------------------------------------------------------/
Get_element macro                ;��������� ��������
    push si
    push bx
    push dx
    
    ;Calculate_element_offset Field_length_X              ;;;;;;;;;;;;;;;;;;;;
    Calculate_element_offset Field_length
    mov bx, 2
    div bx     
    mov si, offset Screen_matrix;�������� ����
    add si, ax                  ;������� � ������ ������
    mov ax, [si]                ;��������� �������� �� ��������
    
    pop dx
    pop bx
    pop si
endm

;/--------------------------------------------------------------------------/
Check_direction_object proc      ;�������� ������� �� ���� �������� ���������
    cmp bl, 0                    ;��������� ���������� ����������� 
    je Check_object_in_up
    cmp bl, 1
    je Check_object_in_down
    cmp bl, 2
    je Check_object_in_left
    cmp bl, 3
    je Check_object_in_right             
    
Check_object_in_up:              ;����������������� ������� �� Y(�����)
        dec al
        jmp Check_got_object
        
Check_object_in_down:            ;����������������� ������� �� Y(����)      
        inc al
        jmp Check_got_object
        
Check_object_in_left:            ;����������������� ������� �� �(�����)       
        dec ah
        jmp Check_got_object

Check_object_in_right:           ;����������������� ������� �� �(������)       
        inc ah
        jmp Check_got_object
        
Check_got_object: 
        Get_element              ;��������� ������� �� ���������� �������
        ret
Check_direction_object endp                                               

;/-----------------------------------------------------------------------/
Meeting_pacman_with_ghosts_checking proc ;�������� ������� ������� � ���������
    push si
    push cx
    push ax
    mov cx, Max_count_of_ghosts
    mov si, 0
    
Meeting_pacman_with_ghosts_checking_loop: ;��������� ������� ���������
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
        
    cmp ah, Pacman_position_X             ;�������� ��������� �� �
    je Check_meeting_pac_gh_on_Y
    jmp Check_next_meeting_pacman_with_ghost 
    
Check_meeting_pac_gh_on_Y:                ;�������� ��������� �� Y
    cmp al, Pacman_position_Y
    je Decrement_health
    jmp Check_next_meeting_pacman_with_ghost
            
Check_next_meeting_pacman_with_ghost:     ;������� � ���������� ��������
    inc si
loop Meeting_pacman_with_ghosts_checking_loop               
    pop ax
    pop cx
    pop si
    ret 

Decrement_health:                         ;���������� �����
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
Real_good_game proc                     ;��������� ���� ���������
    call Draw_win_string                ;��������� ��������� �����
    call Draw_reset_quit_str
Waiting_pressed_F_:    
    Press_key                           ;������� �������  
    Clear_keyboard_buf                  ;������� ������ ����������  
    
    cmp al, 'r'                         ;���������� ����
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    cmp ah, 0Fh                         ;����� �� ����
    je End_of_game
    
    jmp Waiting_pressed_F_  
    ret 
Real_good_game endp

;/----------------------------------------------------------------------/
Good_game_well_played proc              ;��������� ���� ����������
    call Draw_clean_pause_string        ;�������� ��������� ����
    call Draw_lose_string               ;��������� ��������� �����
    call Draw_reset_quit_str
Waiting_pressed_F:    
    Press_key                           ;������� �������  
    Clear_keyboard_buf                  ;������� ������ ����������  
    
    cmp al, 'r'                         ;���������� ����
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    cmp ah, 0Fh                         ;����� �� ����
    je End_of_game
    
    jmp Waiting_pressed_F  
    ret  
Good_game_well_played endp

;/---------------------------------------------------------------------/
Meeting_pacman_with_apple_checking proc  ;�������� ������� ������� � �������
    push ax                     
    
Meeting_pacman_with_apple_on_X:          ;�������� ������� �� ��� �
    mov ah, Apple_position_X
    mov al, Pacman_position_X
    cmp ah, al                           
    je Meeting_pacman_with_apple_on_Y    ;���� ���������� �� � ���������
    jmp End_meeting_pacman_with_apple  
    
Meeting_pacman_with_apple_on_Y:          ;�������� ������� �� ��� Y     
    mov ah, Apple_position_Y
    mov al, Pacman_position_Y
    cmp ah, al
    je Rewriting_score                   ;���� ���������� ���������, �� ���������� �����
    jmp End_meeting_pacman_with_apple
        
Rewriting_score:                         ;����������������� �����
    inc Count_of_apple  
    call Apple_appearance 
    
    push ax                              ;�������� �� ������
    mov al, Count_of_apple 
    mov ah, Max_count_of_apples 
    cmp al, ah 
    je call Real_good_game               ;� ������ ������ 
    pop ax   
                
    jmp End_meeting_pacman_with_apple    
        
End_meeting_pacman_with_apple:
    pop ax    
    ret
Meeting_pacman_with_apple_checking endp
 
;/------------------------------------------------------------------/ 
Meeting_ghosts_with_apple_checking proc  ;�������� ������� �������� � �������
    push ax                     
    
Meeting_ghost_with_apple_on_X:           ;��������� ������� ��������� �� ��� �
    mov ah, Apple_position_X
    mov al, Ghosts_position_X[si]
    cmp ah, al
    je Meeting_ghost_with_apple_on_Y     ;���� �������, �� �������� ������ ���
    jmp End_meeting_ghosts_with_apple  
        
Meeting_ghost_with_apple_on_Y:           ;�������� ��� Y
    mov ah, Apple_position_Y
    mov al, Ghosts_position_Y[si]
    cmp ah, al
    je Rebraw_apple                      ;���� �������, �� ��������������� ������
    jmp End_meeting_ghosts_with_apple
        
Rebraw_apple:                            ;��������������� ������
    call Drawing_apple
        
End_meeting_ghosts_with_apple:
    pop ax    
    ret
Meeting_ghosts_with_apple_checking endp  

;/----------------------------------------------------------------------------/
Pacman_appearance proc                  ;��������� �������
    mov Pacman_position_X, 1            ;��������� ������� �������
    mov Pacman_position_Y, 1
    mov Pacman_current_direction, 2     ;��������� �������� ����������� �������(������)
    mov Pacman_next_direction, 2
    call Drawing_pacman                 ;��������� �������
    ret
Pacman_appearance endp

;/-----------------------------------------------------------------------------/
Keypress_check proc                     ;�������� ������� �������
    Check_key_pressed
    jnz If_pressed                      ;���� ������� ������� ��������
    
    mov Flag_moving_pacman, 0
    ret
        
If_pressed:                             ;���� ������     
    mov Flag_moving_pacman, 1
    Press_key                           ;������� ������� 
    Clear_keyboard_buf                  ;������� ������ ����������
    
    cmp al, 'w'                         ;���� ������ �����
    je Pacman_direction_up 
    cmp al, 'W'
    je Pacman_direction_up
    cmp ah, 48h
    je Pacman_direction_up
    
    cmp al, 's'                         ;���� ������ ����
    je Pacman_direction_down  
    cmp al, 'S'
    je Pacman_direction_down
    cmp ah, 50h
    je Pacman_direction_down    
    
    cmp al, 'a'                         ;���� ������ �����
    je Pacman_direction_left 
    cmp al, 'A'
    je Pacman_direction_left
    cmp ah, 4bh
    je Pacman_direction_left
        
    cmp al, 'd'                         ;���� ������ ������
    je Pacman_direction_right 
    cmp al, 'D'
    je Pacman_direction_right    
    cmp ah, 4dh
    je Pacman_direction_right

    cmp ah, 01h
    je call Stop_game
    
    mov Pacman_next_direction, 5             ;;;;;;;;;
    ret
        
Pacman_direction_up:                    ;��������� ����������� �������� ����� 
    mov Pacman_next_direction, 0
    ret   
    
Pacman_direction_down:
    mov Pacman_next_direction, 1        ;��������� �������� ����
    ret    
    
Pacman_direction_left:                  ;��������� �������� �����
    mov Pacman_next_direction, 2
    ret  
    
Pacman_direction_right:                 ;��������� �������� ������
    mov Pacman_next_direction, 3
    ret 
    
Keypress_check endp                                                    

;/----------------------------------------------------------------/
Stop_game proc                          ;����� ����   
    push ax      
    call Draw_pause_string              ;��������� ��������� � ����   
    call Draw_reset_quit_str
If_pause_pressed:    
    Press_key                           ;������� �������  
    Clear_keyboard_buf                  ;������� ������ ����������  
    cmp ah, 1Ch                         ;���������� ����
    je End_pause 
    
    cmp ah, 0Fh                         ;����� ����
    je End_of_game 
    
    cmp al, 'r'                         ;���������� ����
    je call Reset_game
    cmp al, 'R'
    je call Reset_game
    
    jmp If_pause_pressed 
    
End_pause:
    call Draw_clean_pause_string        ;�������� ��������� ����
    pop ax
    ret    
Stop_game endp   

;/----------------------------------------------------------------/
Reset_game proc                         ;������������� ����                 
    Set_screen 
    jmp start
    ret
Reset_game endp  

;/----------------------------------------------------------------/    
Delete_pacman proc                      ;�������� �������
    mov ah, Pacman_position_X 
    mov al, Pacman_position_Y
    Draw_element Empty_element          ;������� �� ����� ������� ������� �����
    ret
Delete_pacman endp

;/----------------------------------------------------------------/ 
Rewriting_pacman_positions proc         ;���������� ������� ������� �������
    cmp Pacman_current_direction, 0     ;��������� �������� ���������� ������� 
    je Rewritting_pacman_on_up
    cmp Pacman_current_direction, 1
    je Rewritting_pacman_on_down
    cmp Pacman_current_direction, 2
    je Rewritting_pacman_on_left
    cmp Pacman_current_direction, 3
    je Rewritting_pacman_on_right             
    
Rewritting_pacman_on_up:                ;���������� ����������� �� �����        
        dec Pacman_position_Y
        ret
  
Rewritting_pacman_on_down:              ;���������� ����������� �� ����
        inc Pacman_position_Y
        ret
   
Rewritting_pacman_on_left:              ;���������� ����������� �� �����
        dec Pacman_position_X
        ret
  
Rewritting_pacman_on_right:             ;���������� ����������� �� ������ 
        inc Pacman_position_X
        ret
Rewriting_pacman_positions endp                                       

;/----------------------------------------------------------------/
Drawing_pacman proc                     ;��������� �������
    mov ah, Pacman_position_X           ;��������� ������� ������� ������� �� ����
    mov al, Pacman_position_Y
    
    cmp Pacman_current_direction, 0     ;��������� ����������� �������� ������� 
    je Drawing_pacman_up   
    
    cmp Pacman_current_direction, 1
    je Drawing_pacman_down
    
    cmp Pacman_current_direction, 2
    je Drawing_pacman_left
    
    cmp Pacman_current_direction, 3
    je Drawing_pacman_right    
    
Drawing_pacman_up:                      ;���� �������� �����                
        Draw_element Pacman_UP
        jmp Drawing_pacman_complete

Drawing_pacman_down:                    ;���� �������� ����
        Draw_element Pacman_DOWN
        jmp Drawing_pacman_complete
    
Drawing_pacman_left:                    ;���� �������� �����
        Draw_element Pacman_LEFT
        jmp Drawing_pacman_complete
    
Drawing_pacman_right:                   ;���� �������� ����
        Draw_element Pacman_RIGHT
        jmp Drawing_pacman_complete
    
Drawing_pacman_complete:
        ret
Drawing_pacman endp     

;/------------------------------------------------------------------/ 
Moving_pacman proc                        ;�������� ��������� ���������
    push ax
    push bx
    call Keypress_check                   ;�������� ������� ������� �������� �������
    
    cmp Pacman_next_direction, 5          ;���� �� ������ ������� �����������
    je Moving_pacman_complete              ;;;;;;;;;;
    cmp Flag_moving_pacman, 0             ;���� �� ���������� ���� ��������
    je Moving_pacman_complete              ;;;;;;;;;;    
                
Check_pacman_next_direction:
    mov ah, Pacman_position_X              ;��������� ������� ������� �������
    mov al, Pacman_position_Y
    mov bl, Pacman_next_direction          ;��������� ���������� �����������
    call Check_direction_object            ;��������� �������� ������� �� ����������� ��������
    cmp ax, em
    je Change_to_new_direction_pacman      ;���� ��������� ������� 
       
Check_current_position_pacman:             ;��������� ������� ������� �������
    mov ah, Pacman_position_X 
    mov al, Pacman_position_Y
    mov bl, Pacman_current_direction        
    call Check_direction_object            ;��������� ������� �� ������� �������
    cmp ax, em                             ;���� ��������� ������
    je Redraw_pacman                       ;��������������� ������� �� ������� �� �������
    cmp ax, wl
    je Moving_pacman_complete    
    
Change_to_new_direction_pacman:            ;���������� ����������� �������� ������� 
    mov ah, Pacman_next_direction     
    mov Pacman_current_direction, ah
                
Redraw_pacman:    
    call Delete_pacman                       ;�������� �������
    call Rewriting_pacman_positions          ;���������� ��������� �������
    call Meeting_pacman_with_ghosts_checking ;�������� ������� ������� � ��������
    call Meeting_pacman_with_apple_checking  ;�������� ������� ������� � �������
    call Drawing_pacman                      ;��������� �������
        
Moving_pacman_complete:     
    pop bx 
    pop ax  
    ret
Moving_pacman endp
 
;/--------------------------------------------------------------------/           
Ghosts_appearance proc              ;��������� ���������
    Rewriting_param                 ;���������� ���������� �������
    
    mov cx, Max_count_of_ghosts     ;�������� ����� ����������
    mov si, 0
    
Appearance_ghost_loop:        
Create_ghost:
    ;Get_random_number_macro Field_length_X   ;��������� ������� ��� �������� �������
    Get_random_number_macro Field_length   ;��������� ������� ��� �������� �������
    mov Ghosts_position_X[si], al  
    Get_random_number_macro Field_length   ;��������� ������� ��� �������� �������    
    ;Get_random_number_macro Field_length_Y
    mov Ghosts_position_Y[si], al   
    
    Get_random_number_macro 4              ;��������� ����������� ��� �������� ������� 
    mov Ghosts_current_direction[si], al
    Get_random_number_macro 4              ;��������� ����� ��������
    mov Ghosts_colors[si], al              
    
    mov ah, Ghosts_position_X[si]
    mov al, Ghosts_position_Y[si]
    Get_element                      ;��������� ��������, ���������� �� ������ �������(��� ������ �������� �������)
    cmp ax, em                       ;���� ������ ������������ (����� ������� ��������)
    je Create_next_chost
    jmp Create_ghost
                 
Create_next_chost:                   ;�������� ���������� ��������
    call Drawing_chost
    inc si
loop Appearance_ghost_loop    
    
    mov Ghosts_delay_counter, 0      ;��������� �������� �������� 
    ret
Ghosts_appearance endp                                              

;/-----------------------------------------------------------------/
Delete_chost proc                    ;�������� ��������
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
    Draw_element Empty_element       ;��������� �� ����� �������� ������� �����
    ret
Delete_chost endp

;/-----------------------------------------------------------------/ 
Rewriting_ghost_position proc        ;���������� ������� ������� ��������
    cmp bl, 0                        ;��������� ������ � ����������� �������� ��������
    je Moving_chost_in_up
    cmp bl, 1
    je Moving_chost_in_down
    cmp bl, 2
    je Moving_chost_in_left
    cmp bl, 3
    je Moving_chost_in_right             
    
Moving_chost_in_up:                  ;����������������� ������� �� Y
    dec Ghosts_position_Y[si]
    ret

Moving_chost_in_down:                ;���������������� ������� �� Y
    inc Ghosts_position_Y[si]
    ret
  
Moving_chost_in_left:                ;����������������� ������� �� � 
    dec Ghosts_position_X[si]
    ret
   
Moving_chost_in_right:               ;���������������� ������� �� �   
    inc Ghosts_position_X[si]
    ret
Rewriting_ghost_position endp

;/----------------------------------------------------------/    
Drawing_chost proc                   ;��������� ��������
    mov ah, Ghosts_position_X[si]    ;��������� ������� ��������
    mov al, Ghosts_position_Y[si]
    
    mov bl, Ghosts_colors[si]        ;��������� �����
    cmp bl, 0                        ;���� �����
    je Drawing_chost_on_blue
    cmp bl, 1                        ;���� �������
    je Drawing_chost_on_green
    cmp bl, 2                        ;���� ����������
    je Drawing_chost_on_purple
    cmp bl, 3                        ;���� �����
    je Drawing_chost_on_gray 
    
Drawing_chost_on_blue:               ;��������� ������ ��������
    Draw_element Ghost_blue
    jmp Drawing_chost_complete
    
Drawing_chost_on_green:              ;��������� �������� ��������
    Draw_element Ghost_green
    jmp Drawing_chost_complete
  
Drawing_chost_on_purple:             ;��������� ����������� ��������
    Draw_element Ghost_purple
    jmp Drawing_chost_complete
    
Drawing_chost_on_gray:               ;��������� ������ ��������
    Draw_element Ghost_gray
    jmp Drawing_chost_complete
    
Drawing_chost_complete:
        ret
Drawing_chost endp         

;/---------------------------------------------------------------------/
Getting_prev_direction proc          ;��������� ����������� �����������
    cmp bl, 2
    jge If_current_left_right        ;���� ������� ����������� ��������� ������ ��� �������
    jmp If_current_up_down           ;���� ��������� �� ��� ��� ����
    
If_current_left_right:               ;���� �����-����
    cmp bl, 2
    je Left_to_right
    jmp Right_to_left 
    
If_current_up_down:                  ;���� ����-���
    cmp bl, 1
    je Down_to_up
    jmp Up_to_down
    
Up_to_down:                          ;���� ����, �� ������ �� ���
    mov bl, 1
    ret
         
Down_to_up:                          ;���� ���, �� ������ �� ����
    mov bl, 0
    ret
        
Left_to_right:                       ;���� ����, �� ������ �� �����
    mov bl, 3
    ret 
        
Right_to_left:                       ;���� �����, �� ������ 
    mov bl, 2        
    ret
Getting_prev_direction endp

;/-----------------------------------------------------------------------/
Moving_chosts proc                   ;������������ ���������
    push ax
    push bx
    push cx
                  
    inc Ghosts_delay_counter        ;��������� ����� �������� ��������� 
    push ax
    mov ah, Ghosts_max_delay_moving 
    cmp Ghosts_delay_counter, ah
    pop ax
    jne Moving_chosts_complete
        
    mov Ghosts_delay_counter, 0
    Rewriting_param                 ;�������� ��������� ��� �������
            
    mov cx, Max_count_of_ghosts
    mov si, 0
    
Moving_chosts_loop: 
Check_random_chosts_direction:
    Get_random_number_macro 4       ;��������� ���������� �����������
    mov bl, al
    mov ah, Ghosts_position_X[si] 
    mov al, Ghosts_position_Y[si]
    call Check_direction_object     ;�������� �� ������ ����������� �� ������� �����������
    
    cmp ax, em                      ;���� �� ���� �������� ������ ������������
    je Check_prev_direction
    cmp ax, wl                      ;���� �����, �� �������� ���������� �����������
    je Check_random_chosts_direction
        
Check_prev_direction:               ;�������� ����������� �����������
    call Getting_prev_direction
    mov bh, Ghosts_current_direction[si]
    cmp bh, bl
    je Check_random_chosts_direction ;���� ���������� � ������� ����������� ���������
            
Set_ghosts_direction_on_next_:
    call Getting_prev_direction     ;�������� ��������� �����������
    mov Ghosts_current_direction[si], bl
            
Rebraw_chost:    
    call Delete_chost                        ;�������� ��������               
    call Meeting_ghosts_with_apple_checking  ;�������� ������� �������� � �������
    call Rewriting_ghost_position            ;���������� ������� ��������
    call Meeting_pacman_with_ghosts_checking ;�������� ������� ������� � ��������             
    call Drawing_chost                       ;��������������� ��������
            
    inc si
loop Moving_chosts_loop
    
Moving_chosts_complete:     
    pop cx 
    pop bx
    pop ax  
    ret
Moving_chosts endp               
                   
;/---------------------------------------------------------/           
Convert_num_to_str proc      ;������� �� ����� � ������
    push bp                  ;���������� bp
    mov bp, sp               ;Bp - ������� �����     
    mov ax, [bp + 6]
    mov si, [bp + 4]         ;���������� 4�� ���������
    
    xor cx, cx               
    mov bx, 10                
        
Getting_number_digits:
    xor dx, dx
    div bx                    
    push dx                  ;��������� �������  
    inc cx                   ;��������� ����� ��������
    cmp ax, 0                ;���� �� ����������� ������� �����
jne Getting_number_digits
        
Draw_digit_loop:
    pop dx
    add dx, 30h              ;������� � ��������� �������� �����
    mov dh, Green_colour     
    mov word ptr [si], dx    ;������ ����� � ����������
    add si, 2
loop Draw_digit_loop

    pop bp
    ret 4
Convert_num_to_str endp

;/----------------------------------------------------------/
Drawing_count_of_apple proc     ;��������� ����� �����
    xor cx, cx
    mov cl, Count_of_apple
    push cx
    push offset Apple_counting_str   
    call Convert_num_to_str     ;������� ����� � ������ � ��������� 

    mov si, offset Apple_counting_str
    mov di, Total_current_score_offset
    mov cx, 4                
    rep movsw                   ;������� ������ �� DS:SI � ES:DI
    ret
Drawing_count_of_apple endp

;/----------------------------------------------------------/
Drawing_apple proc              ;��������� ������
    mov ah, Apple_position_X 
    mov al, Apple_position_Y
    Draw_element Apple          ;��������� ������ 
    ret
Drawing_apple endp

;/----------------------------------------------------------/
Apple_appearance proc           ;��������� ������
    Rewriting_param
         
Setting_apple_position:
    ;Get_random_number_macro Field_length_X ;��������� ��������� ������
    Get_random_number_macro Field_length   ;��������� ������� ��� �������� �������
    mov Apple_position_X, al 
    Get_random_number_macro Field_length   ;��������� ������� ��� �������� �������
    ;Get_random_number_macro Field_length_Y
    mov Apple_position_Y, al  
    
    mov ah, Apple_position_X 
    mov al, Apple_position_Y
    Get_element                 ;��������� �������� �� ������� ���������� ������
    cmp ax, em
    je Create_apple
    jmp Setting_apple_position
    
Create_apple:
    call Drawing_apple          ;��������� ������
    call Drawing_count_of_apple ;��������� �����
    ret
Apple_appearance endp   

;/----------------------------------------------------------/
Draw_count_of_heart proc           ;��������� ������
    push ax
    push bx 
    
    mov ah, Health_position_X      ;��������� ��������� 
    mov al, Health_position_Y 
    
    mov bl, Count_of_health        ;��������� ����� ������
    cmp bl, 3
    je Draw_tree_health
    cmp bl, 2
    je Draw_two_health
    cmp bl, 1
    je Draw_one_health
    cmp bl, 0 
    je Draw_zero_health
    
Draw_tree_health:                  ;��������� 3 ������
    Draw_element Health_tree     
    pop bx
    pop ax
    ret    

Draw_two_health:                   ;��������� 2 ������
    Draw_element Health_two     
    pop bx
    pop ax
    ret    

Draw_one_health:                   ;��������� 1 �����
    Draw_element Health_one     
    pop bx
    pop ax
    ret     
    
Draw_zero_health:                  ;��������� 0 �����
    Draw_element Health_zero     
    pop bx
    pop ax
    ret    
Draw_count_of_heart endp

;/------------------------------------------------------/ 
Select_difficulty proc             ;����� ���������
    Write_macro Hello_str
    Write_macro Easy_str
    Write_macro Medium_str
    Write_macro Hard_str    
    Write_macro Unreal_str
    
Enter_difficulty_selection:     ;���� ������ ������� ������
    mov ah,01h                  ;���������� ������� �� ������������ �/��
    int 21h
    Clear_keyboard_buf          ;������� ������ ����������
                                
    cmp al, '1'                 ;����� ���������
    je Easy_dif
    cmp al, '2'
    je Medium_dif
    cmp al, '3'
    je Hard_dif
    cmp al, '4'
    je Unreal_dif   
    jmp Enter_difficulty_selection
    
Easy_dif:                       ;������ ���������
    mov ah, Easy_apples  
    mov Max_count_of_apples, ah
    mov ax, Easy_chosts  
    mov Max_count_of_ghosts, ax
    mov ax, Easy_pause
    mov Game_loop_pause, ax        
    xor ax,ax
    ret
    
Medium_dif:                     ;������� ���������
    mov ah, Medium_apples  
    mov Max_count_of_apples, ah 
    mov ax, Medium_chosts  
    mov Max_count_of_ghosts, ax
    mov ax, Medium_pause
    mov Game_loop_pause, ax
    xor ax,ax
    ret    
    
Hard_dif:                       ;������� ���������
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
    
Unreal_dif:                     ;���������� ���������
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