 ; +----------------------------------------------------------+ 
 ; | This MacroLibary dependent on Irvine32.inc, Irvine32.lib | 
 ; +----------------------------------------------------------+ 
 ; | File author: NUU.U0924043, NUU.U0924051                  | 
 ; +----------------------------------------------------------+ 

 ;   | 0 1 2 3 4 5 6 7 8 9 A B C D E F 
 ;---+---------------------------------
 ; 0 | A B C D E F G H I J K L M N O P 
 ; 1 | Q R S T U V W X Y Z a b c d e f 
 ; 2 | g h i j k l m n o p q r s t u v 
 ; 3 | w x y z 0 1 2 3 4 5 6 7 8 9 + / 

StringDetail_3 macro String:req ; author: NUU.U0924043
  push eax
  push ecx
    mov eax, offset String
    putHex eax
    putConstString ", "
    getStringLength ecx, String
    putDec ecx
    putConstString ": "
    ; putString String
    ; putConstString ": "
    movzx eax, String[0]
    putHexPart eax, type String
    putConstString " "
    movzx eax, String[1]
    putHexPart eax, type String
    putConstString " "
    movzx eax, String[2]
    putHexPart eax, type String
    putConstString ": "
    putChar String[0]
    putChar String[1]
    putChar String[2]
    call Crlf
  pop ecx
  pop eax
endm
StringDetail_4_putBase64Char macro String:req ; author: NUU.U0924043
  push eax
  push ecx
    mov eax, offset String
    putHex eax
    putConstString ", "
    getStringLength ecx, String
    putDec ecx
    putConstString ": "
    ; putString String
    ; putConstString ": "
    movzx eax, String[0]
    putHexPart eax, type String
    putConstString " "
    movzx eax, String[1]
    putHexPart eax, type String
    putConstString " "
    movzx eax, String[2]
    putHexPart eax, type String
    putConstString " "
    movzx eax, String[3]
    putHexPart eax, type String
    putConstString ": "
    putChar String[0]
    putChar String[1]
    putChar String[2]
    putChar String[3]
    putConstString ": "
    putBase64Char base64Dict, String[0]
    putBase64Char base64Dict, String[1]
    putBase64Char base64Dict, String[2]
    putBase64Char base64Dict, String[3]
    call Crlf
  pop ecx
  pop eax
endm
putBase64Char macro dest:req, surc:req ; author: NUU.U0924051
  push eax
  push ebx
    movzx eax, surc
    ; putHexPart ebx, type surc
    ; putConstString " "
    movzx ebx, dest[eax]
    ; putHexPart eax, type dest
    ; putConstString ": "
    putChar bl
    ; call Crlf
  pop ebx
  pop eax
endm
putBase64Char_4bit macro dest:req, surc:req ; author: NUU.U0924051
    putBase64Char dest, surc[0]
    putBase64Char dest, surc[1]
    putBase64Char dest, surc[2]
    putBase64Char dest, surc[3]
endm
putBase64Char_3bit macro dest:req, surc:req ; author: NUU.U0924051
    putBase64Char dest, surc[0]
    putBase64Char dest, surc[1]
    putBase64Char dest, surc[2]
endm
putBase64Char_2bit macro dest:req, surc:req ; author: NUU.U0924051
    putBase64Char dest, surc[0]
    putBase64Char dest, surc[1]
endm
parseBase64Code_3bit macro dest:req, surc:req, index:req ; author: NUU.U0924043
  push eax
    mov al, surc[index+0]
    and al, 11111100b
    shr al, 2
    mov dest[0], al
    mov al, surc[index+0]
    and al, 00000011b
    shl al, 4
    mov dest[1], al
    mov al, surc[index+1]
    and al, 11110000b
    shr al, 4
    or  dest[1], al
    mov al, surc[index+1]
    and al, 00001111b
    shl al, 2
    mov dest[2], al
    mov al, surc[index+2]
    and al, 11000000b
    shr al, 6
    or  dest[2], al
    mov al, surc[index+2]
    and al, 00111111b
    mov dest[3], al
  pop eax
endm


ParsePutBase64 macro dict:req, surc:req, groupNumber:req, stringLength:req ; author: NUU.U0924043
  local toBase64_Loop, base64Char_2bit, base64Char_3bit, base64Char_4bit, dest
  .data
    dest byte 4 dup(0)
  .code
    push esi    ; record stringOffset
    push ecx    ; record groupNumber
    mov esi, 0  ; 
    mov ecx, 0  ; 
    toBase64_Loop: 
      ;parseBase64----------------------------;
      parseBase64Code_3bit dest, surc, esi    ;
      ;putBase64------------------------------;
      push edx                                ;
        mov edx, esi                          ;
        add edx, 3                            ;
        mov dh, stringLength                  ;
        base64Char_4bit:                      ;
          cmp dh, dl                          ;
          js base64Char_3bit                  ;
          putBase64Char_4bit base64Dict, dest ;
          jmp base64Char_                     ;
        base64Char_3bit:                      ;
          dec edx                             ;
          cmp dh, dl                          ;
          js base64Char_2bit                  ;
          putBase64Char_3bit base64Dict, dest ;
          putConstString "="                  ;
          jmp base64Char_                     ;
        base64Char_2bit:                      ;
          dec edx                             ;
          cmp dh, dl                          ;
          js base64Char_                      ;
          putBase64Char_2bit base64Dict, dest ;
          putConstString "=="                 ;
          jmp base64Char_                     ;
        base64Char_:                          ;
      pop edx                                 ;
      ;gotoNextGroup--------------------------;
      add esi, 3                              ;
      add ecx, 1                              ;
      cmp cl, groupNumber                     ;
      js toBase64_Loop                        ;
      ;---------------------------------------;
      ; call Crlf
    pop ecx
    pop esi
endm

Base64CharToBase64Code macro dest:req, Dict:req ; author: NUU.U0924051
  local dictRead, dictFound, dictOut, dictErr, macroEnd
  push eax
  push ecx
    movzx eax, dest
    mov ecx, 0
    dictRead:
      cmp al, Dict[ecx]
      jz dictFound
      inc ecx
      cmp ecx, lengthof Dict
      js dictRead
      jmp dictOut
    dictFound: 
      mov eax, ecx
      mov dest, al
      jmp macroEnd
    dictOut:
      cmp al, '='
      js dictErr
      mov dest, 0
      jmp macroEnd
    dictErr:
      putConstString 10, 13, "Error: '"
      putChar dest
      putConstString "' can't to Base64Code .", 10, 13
    macroEnd:
  pop ecx
  pop eax
endm
Base64CharToBase64Code_4bit macro Dict:req, dest:req, index:req ; author: NUU.U0924051
  push eax
    Base64CharToBase64Code dest[index+0], base64Dict
    Base64CharToBase64Code dest[index+1], base64Dict
    Base64CharToBase64Code dest[index+2], base64Dict
    Base64CharToBase64Code dest[index+3], base64Dict
  pop eax
endm
parseASCIICode_4bit macro dest:req, surc:req, index:req ; author: NUU.U0924043
  push eax
    mov al, surc[index+0]
    and al, 00111111b
    shl al, 2
    mov ah, al
    mov al, surc[index+1]
    and al, 00110000b
    shr al, 4
    or  al, ah
    mov dest+0, al
    mov al, surc[index+1]
    and al, 00001111b
    shl al, 4
    mov ah, al
    mov al, surc[index+2]
    and al, 00111100b
    shr al, 2
    or  al, ah
    mov dest+1, al
    mov al, surc[index+2]
    and al, 00000011b
    shl al, 6
    mov ah, al
    mov al, surc[index+3]
    and al, 00111111b
    or  al, ah
    mov dest+2, al
  pop eax
endm
ParsePutASCII macro dict:req, surc:req, groupNumber:req, stringLength:req ; author: NUU.U0924043
  local toASCII_Loop, base64Char_2bit, base64Char_3bit, base64Char_4bit, dest
  .data
    dest byte 4 dup(0)
  .code
    push esi    ; record stringOffset
    push ecx    ; record groupNumber
    mov esi, 0  ; 
    mov ecx, 0  ; 
    toASCII_Loop: 
      ;parseASCII---------------------------------------;
      mov dest+0, 0                                     ;
      mov dest+1, 0                                     ;
      mov dest+2, 0                                     ;
      mov dest+3, 0                                     ;
      Base64CharToBase64Code_4bit base64Dict, surc, esi ;
      parseASCIICode_4bit dest, surc, esi               ;
      ;putASCII-----------------------------------------;
      putString dest                                    ;
      ;gotoNextGroup------------------------------------;
      add esi, 4                                        ;
      add ecx, 1                                        ;
      cmp cl, groupNumber                               ;
      js toASCII_Loop                                   ;
      ;-------------------------------------------------;
      ; call Crlf
    pop ecx
    pop esi
endm