HA$PBExportHeader$titulos.sra
$PBExportComments$Generated Application Object
forward
global type titulos from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
string gs_banco, gs_dirapp
end variables

global type titulos from application
string appname = "titulos"
end type
global titulos titulos

type prototypes
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext)  alias for "GetCurrentDirectoryA;ANSI"   library "KERNEL32.DLL"
end prototypes

on titulos.create
appname="titulos"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on titulos.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string ls_curdir, ls_usuario, ls_senha, ls_sgbd
ls_Curdir = '\arquivos de programas\titulos                                                      '
GetCurrentDirectoryA(100, ls_curdir)


if right(trim(ls_curdir),1) <> '\' then
	gs_DirApp = trim(ls_curdir)+'\'
else
	gs_DirApp = trim(ls_curdir)
end if

of_conectar() 

open(w_inicial)

end event

