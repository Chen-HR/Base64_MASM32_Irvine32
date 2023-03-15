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
  buffer byte 80 dup(0)
  byteCount byte ?
  count byte ?
  groupSize word 3
  groupNumber word ?
  stringLength word ?
  precision word 100
.code
  encode proc ; author: NUU.U0924028
    putConstString "< "
      getString buffer,SIZEOF buffer,byteCount
      finit
      fild groupSize
      movzx ax,byteCount
      mov stringLength, ax
      fild stringLength
      fdiv st(0), st(1)
      ffree st(1)
      fild precision
      fmul st(0), st(1)
      ffree st(1)
      fist groupNumber
      ffree st(0)
      mov ax, groupNumber
      mov bx, precision
      div bl
      cmp ah,0
      jz L1
      inc al
    L1: 
      mov count,al
      putConstString "> "
      ParsePutBase64 base64Dict, buffer, count, byteCount
      putConstString 10,13
    ret
  encode endp
end encode