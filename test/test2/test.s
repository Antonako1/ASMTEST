.586
.model flat, stdcall
.data
quotient qword 0
buffer byte 80 dup (0)
format byte 'Quotient: %f',0
titler byte 'Divide',0
.code
ExitProcess PROTO :DWORD
MessageBoxA PROTO :DWORD, :DWORD, :DWORD, :DWORD
extern C sprintf: proc

_Start proc public

push 3
fild dword ptr [esp]
mov dword ptr [esp], 2
fild dword ptr [esp]
add esp, 4
fdivp st(1),st(0)
fstp qword ptr [quotient]

push dword ptr [quotient+4]
push dword ptr [quotient]
push offset format
push offset buffer
call sprintf
add esp, 12

invoke MessageBoxA, 0, offset buffer, offset titler, 0
invoke ExitProcess, 0

_Start endp
end _Start