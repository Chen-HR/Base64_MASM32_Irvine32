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
  ExitProcess proto, dwExitCode: dword
  encode proto
  decode proto
  str1 byte "�п�ܭn���檺�ʧ@ (0.����/1.�s�X/2.�ѽX):",0
  intVal dword ?

.code
  main proc ; author: NUU.U0924028
    Start:
      mov edx,OFFSET str1
      call WriteString
      call ReadInt
      mov intVal,eax
      cmp intVal,0
      je Stop
      cmp intVal,1
      je Compare1
      cmp intVal,2
      je Compare2
      jmp Stop
    Compare1:
      call encode
      jmp Start
    Compare2:
      call decode
      jmp Start
    Stop:
      call WaitMsg
      invoke ExitProcess, 0
  main endp
end main