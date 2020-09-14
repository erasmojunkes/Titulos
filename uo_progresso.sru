HA$PBExportHeader$uo_progresso.sru
forward
global type uo_progresso from userobject
end type
type st_titulo from statictext within uo_progresso
end type
type hpb_progresso from hprogressbar within uo_progresso
end type
end forward

global type uo_progresso from userobject
integer width = 1851
integer height = 240
long backcolor = 67108864
string text = "none"
borderstyle borderstyle = styleraised!
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_titulo st_titulo
hpb_progresso hpb_progresso
end type
global uo_progresso uo_progresso

forward prototypes
public subroutine of_definir_valores (long al_posicaoinicial, long al_posicaofinal, integer ai_incremento, string as_titulo)
public subroutine of_atualizar (long al_linhaatual, integer al_quantidadelinhas)
public subroutine of_centralizar ()
end prototypes

public subroutine of_definir_valores (long al_posicaoinicial, long al_posicaofinal, integer ai_incremento, string as_titulo);
of_Centralizar( )

hpb_progresso.position		=	al_PosicaoInicial
hpb_progresso.setstep		=	ai_Incremento
hpb_progresso.maxposition	=	al_PosicaoFinal

hpb_progresso.setredraw(True)

If Len(as_titulo) > 0 Then 
	st_titulo.text = as_titulo
Else
	st_titulo.visible = False
End If

Show( )
end subroutine

public subroutine of_atualizar (long al_linhaatual, integer al_quantidadelinhas);
hpb_progresso.stepit()
hpb_progresso.position += hpb_progresso.setstep

hpb_progresso.SetRedraw(True)

SetPosition(TopMost!)
end subroutine

public subroutine of_centralizar ();Window lw_TelaParente

lw_TelaParente = This.GetParent()

//Posiciona o objeto no meio da tela
If IsValid(lw_TelaParente) And (Not IsNull(lw_TelaParente)) Then
	
	This.X = lw_TelaParente.Width  / 2 - This.Width  / 2
	This.Y = lw_TelaParente.Height / 3 - This.Height / 2

End If
end subroutine

on uo_progresso.create
this.st_titulo=create st_titulo
this.hpb_progresso=create hpb_progresso
this.Control[]={this.st_titulo,&
this.hpb_progresso}
end on

on uo_progresso.destroy
destroy(this.st_titulo)
destroy(this.hpb_progresso)
end on

type st_titulo from statictext within uo_progresso
integer x = 23
integer y = 24
integer width = 1797
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217741
long backcolor = 67108864
string text = "T$$HEX1$$ed00$$ENDHEX$$tulo"
alignment alignment = center!
long bordercolor = 16777215
boolean focusrectangle = false
end type

type hpb_progresso from hprogressbar within uo_progresso
integer x = 23
integer y = 132
integer width = 1797
integer height = 72
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

