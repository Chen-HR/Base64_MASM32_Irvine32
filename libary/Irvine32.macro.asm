 ; +----------------------------------------------------------+ 
 ; | This MacroLibary dependent on Irvine32.inc, Irvine32.lib | 
 ; +----------------------------------------------------------+ 
 ; | File author: NUU.U0924043                                | 
 ; +----------------------------------------------------------+ 

getDec macro dest:req ; author: NUU.U0924043
  push eax
  call ReadDec
  mov dest, eax
  pop eax
endm
getInt macro dest:req ; author: NUU.U0924043
  push eax
  call ReadInt
  mov dest, eax
  pop eax
endm
getHex macro dest:req ; author: NUU.U0924043
  push eax
  call ReadHex
  mov dest, eax
  pop eax
endm
getString macro dest:req, size_:req, length_ ; author: NUU.U0924043
  push edx
  push ecx
  push eax
  mov edx, offset dest
  mov ecx, size_
  call ReadString
  ifnb <length_>
    mov length_, al
  endif
  pop eax
  pop ecx
  pop edx
endm
getStringLength macro dest:req, surc:req ; author: NUU.U0924043
  push edx
  mov edx, offset surc
  call StrLength
  mov dest, eax
  pop edx
endm

putBin macro surc:req ; author: NUU.U0924043
  push eax
  mov eax, surc
  call WriteBin
  pop eax
endm
putBinPart macro surc:req, size_:req ; author: NUU.U0924043
  push eax
  push ebx
  mov eax, surc
  mov ebx, size_
  call WriteBinB
  pop ebx
  pop eax
endm
putDec macro surc:req ; author: NUU.U0924043
  push eax
  mov eax, surc
  call WriteDec
  pop eax
endm
putInt macro surc:req ; author: NUU.U0924043
  push eax
  mov eax, surc
  call WriteInt
  pop eax
endm
putHex macro surc:req ; author: NUU.U0924043
  push eax
  mov eax, surc
  call WriteHex
  pop eax
endm
putHexPart macro surc:req, size_:req ; author: NUU.U0924043
  push eax
  push ebx
  mov eax, surc
  mov ebx, size_
  call WriteHexB
  pop ebx
  pop eax
endm
putConstChar macro surc:req ; author: NUU.U0924043
  push eax
  mov eax, surc
  call WriteChar
  pop eax
endm
putChar macro surc:req ; author: NUU.U0924043
  push eax
  movzx eax, surc
  call WriteChar
  pop eax
endm
putConstString macro String0:req, String1, String2, String3 ; author: NUU.U0924043
  local string_
  .data
    string_ byte String0,0
  .code
    push edx
    mov edx, offset string_
    call WriteString
    ifnb <String1>
      putConstString String1
    endif
    ifnb <String2>
      putConstString String2
    endif
    ifnb <String3>
      putConstString String3
    endif
    pop edx
endm
putString macro String0:req, String1, String2, String3 ; author: NUU.U0924043
  .code
    push edx
    mov edx, offset String0
    call WriteString
    ifnb <String1>
      putConstString String1
    endif
    ifnb <String2>
      putConstString String2
    endif
    ifnb <String3>
      putConstString String3
    endif
    pop edx
endm
putStringDetail macro String:req ; author: NUU.U0924043
  local putCode_, putChar_
  push eax
  push edx
  push ecx
    mov eax, offset String
    putHex eax
    putConstString ", "
    getStringLength ecx, String
    putDec ecx
    putConstString ":"
    push ecx
      mov edx, 0
      putCode_:
        movzx eax, String[edx]
        putConstString " "
        putHexPart eax, type String
        dec ecx
        inc edx
        cmp ecx, 0
      jnz putCode_
    pop ecx
    putConstString ": "
    push ecx
      mov edx, 0
      putChar_:
        putChar String[edx]
        dec ecx
        inc edx
        cmp ecx, 0
      jnz putChar_
    pop ecx
    call Crlf
  pop ecx
  pop edx
  pop eax
endm