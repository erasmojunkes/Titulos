HA$PBExportHeader$w_inicial.srw
forward
global type w_inicial from window
end type
type dw_contas_pagar from datawindow within w_inicial
end type
type em_idclifor from editmask within w_inicial
end type
type cb_importar from commandbutton within w_inicial
end type
type st_cliente from statictext within w_inicial
end type
type gb_1 from groupbox within w_inicial
end type
type gb_titulos from groupbox within w_inicial
end type
end forward

global type w_inicial from window
integer width = 4809
integer height = 2544
boolean titlebar = true
string title = "Baixa de t$$HEX1$$ed00$$ENDHEX$$tulos ICMS"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "Form!"
boolean center = true
dw_contas_pagar dw_contas_pagar
em_idclifor em_idclifor
cb_importar cb_importar
st_cliente st_cliente
gb_1 gb_1
gb_titulos gb_titulos
end type
global w_inicial w_inicial

type variables
nv_Funcoes lnv_Funcoes
end variables

forward prototypes
public subroutine of_importar ()
public subroutine of_resetar_tela ()
end prototypes

public subroutine of_importar ();Long ll_idClifor

nv_Titulos lnv_Titulos

lnv_Titulos = Create nv_Titulos 

of_Resetar_Tela( )

ll_idClifor = Long(em_idClifor.Text)

If lnv_Funcoes.of_verifica_cliente(ll_idClifor) < 0 Then
	MessageBox('Dados do Cliente', 'Cliente informado inv$$HEX1$$e100$$ENDHEX$$lido.')
	Return 
End If

If lnv_Titulos.of_Importar(dw_contas_pagar) < 0 Then 
	of_Resetar_Tela( )
	Return
End If




end subroutine

public subroutine of_resetar_tela ();lnv_Funcoes = Create nv_Funcoes

dw_contas_pagar.SetTransObject(SQLCA)
dw_contas_pagar.Reset()


end subroutine

event open;of_Resetar_Tela( )
end event

on w_inicial.create
this.dw_contas_pagar=create dw_contas_pagar
this.em_idclifor=create em_idclifor
this.cb_importar=create cb_importar
this.st_cliente=create st_cliente
this.gb_1=create gb_1
this.gb_titulos=create gb_titulos
this.Control[]={this.dw_contas_pagar,&
this.em_idclifor,&
this.cb_importar,&
this.st_cliente,&
this.gb_1,&
this.gb_titulos}
end on

on w_inicial.destroy
destroy(this.dw_contas_pagar)
destroy(this.em_idclifor)
destroy(this.cb_importar)
destroy(this.st_cliente)
destroy(this.gb_1)
destroy(this.gb_titulos)
end on

type dw_contas_pagar from datawindow within w_inicial
integer x = 46
integer y = 276
integer width = 4645
integer height = 2112
integer taborder = 30
string title = "none"
string dataobject = "d_contas_pagar"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type em_idclifor from editmask within w_inicial
integer x = 471
integer y = 72
integer width = 402
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type cb_importar from commandbutton within w_inicial
integer x = 4297
integer y = 72
integer width = 402
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Importar"
end type

event clicked;of_Importar( )

end event

type st_cliente from statictext within w_inicial
integer x = 41
integer y = 88
integer width = 407
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "C$$HEX1$$f300$$ENDHEX$$digo Cliente"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_inicial
integer x = 14
integer y = 12
integer width = 4722
integer height = 192
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217741
long backcolor = 67108864
string text = "Importa$$HEX2$$e700e300$$ENDHEX$$o"
end type

type gb_titulos from groupbox within w_inicial
integer x = 14
integer y = 204
integer width = 4722
integer height = 2208
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217741
long backcolor = 67108864
string text = "Titulos a Baixar"
end type

