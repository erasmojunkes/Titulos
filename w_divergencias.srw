HA$PBExportHeader$w_divergencias.srw
forward
global type w_divergencias from window
end type
type dw_divergencias from datawindow within w_divergencias
end type
type cb_cancelar from commandbutton within w_divergencias
end type
type cb_confirmar from commandbutton within w_divergencias
end type
type cb_imprimir from commandbutton within w_divergencias
end type
type gb_criticas from groupbox within w_divergencias
end type
end forward

global type w_divergencias from window
integer width = 4594
integer height = 2620
boolean titlebar = true
string title = "Relat$$HEX1$$f300$$ENDHEX$$rio de cr$$HEX1$$ed00$$ENDHEX$$tica"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_divergencias dw_divergencias
cb_cancelar cb_cancelar
cb_confirmar cb_confirmar
cb_imprimir cb_imprimir
gb_criticas gb_criticas
end type
global w_divergencias w_divergencias

type variables
s_Parametros lst_Retorno
nv_Funcoes inv_Funcoes
end variables
event open;s_Parametros lst_Recebe
DataStore lds_Divergencias

inv_Funcoes = Create nv_Funcoes

lst_Recebe = Message.PowerObjectParm


lds_Divergencias = lst_Recebe.PowerObj[1]

lds_Divergencias.Sharedata(dw_Divergencias)
end event

on w_divergencias.create
this.dw_divergencias=create dw_divergencias
this.cb_cancelar=create cb_cancelar
this.cb_confirmar=create cb_confirmar
this.cb_imprimir=create cb_imprimir
this.gb_criticas=create gb_criticas
this.Control[]={this.dw_divergencias,&
this.cb_cancelar,&
this.cb_confirmar,&
this.cb_imprimir,&
this.gb_criticas}
end on

on w_divergencias.destroy
destroy(this.dw_divergencias)
destroy(this.cb_cancelar)
destroy(this.cb_confirmar)
destroy(this.cb_imprimir)
destroy(this.gb_criticas)
end on

event closequery;If UpperBound(lst_Retorno.Long) = 0  Then
	lst_Retorno.Long[1]  = -1
	CloseWithReturn(This, lst_Retorno)
End If
end event

type dw_divergencias from datawindow within w_divergencias
integer x = 50
integer y = 72
integer width = 4480
integer height = 2304
integer taborder = 20
string dataobject = "d_divergencias"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_divergencias
integer x = 4101
integer y = 2412
integer width = 457
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancelar"
end type

event clicked;lst_Retorno.Long[1] = -1
CloseWithReturn(Parent, lst_Retorno)
end event

type cb_confirmar from commandbutton within w_divergencias
integer x = 3625
integer y = 2412
integer width = 457
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Confirmar"
end type

event clicked;lst_Retorno.Long[1] = 1
CloseWithReturn(Parent, lst_Retorno)
end event

type cb_imprimir from commandbutton within w_divergencias
integer x = 27
integer y = 2412
integer width = 457
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Salvar"
end type

event clicked;inv_Funcoes.of_Salva_pdf( dw_Divergencias )
end event

type gb_criticas from groupbox within w_divergencias
integer x = 27
integer width = 4530
integer height = 2400
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217741
long backcolor = 67108864
string text = "Cr$$HEX1$$ed00$$ENDHEX$$ticas"
end type

