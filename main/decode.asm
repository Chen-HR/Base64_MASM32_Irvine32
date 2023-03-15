 ; +----------------------------------------------------------+ 
 ; | File author: NUU.U0924028                                | 
 ; +----------------------------------------------------------+ 
 .386
.model flat, stdcall
.stack 4096 
include    Irvine32.inc 
includelib kernel32.lib 
includelib user32.lib   
includelib Irvine32.lib 
include    Macros.inc   
include    ../libary/Irvine32.macro.asm
include    ../libary/base64.macro.asm
.data
  base64Dict byte "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                  "abcdefghijklmnopqrstuvwxyz",
                  "0123456789",'+','/',0
  buffer byte 105 dup(0)
  byteCount byte ?
  count byte ?
  groupSize word 4
  groupNumber word ?
  stringLength word ?
  precision word 100
.code
  decode proc ; author: NUU.U0924028
    putConstString "< "
      getString buffer,SIZEOF buffer,byteCount
      ; call Crlf
      movzx ax,byteCount
      mov bl,4
      div bl
      mov count,al
      putConstString "> "
      ParsePutASCII base64Dict, buffer, count, byteCount
      putConstString 10,13
    ret
  decode endp
end decode