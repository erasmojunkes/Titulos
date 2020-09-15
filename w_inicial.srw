HA$PBExportHeader$w_inicial.srw
forward
global type w_inicial from window
end type
type em_forma from editmask within w_inicial
end type
type st_forma from statictext within w_inicial
end type
type dw_contabil_movimento from datawindow within w_inicial
end type
type dw_contas_pagar_baixas from datawindow within w_inicial
end type
type cb_imprimir from commandbutton within w_inicial
end type
type cb_baixar from commandbutton within w_inicial
end type
type cb_salvar from commandbutton within w_inicial
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
em_forma em_forma
st_forma st_forma
dw_contabil_movimento dw_contabil_movimento
dw_contas_pagar_baixas dw_contas_pagar_baixas
cb_imprimir cb_imprimir
cb_baixar cb_baixar
cb_salvar cb_salvar
dw_contas_pagar dw_contas_pagar
em_idclifor em_idclifor
cb_importar cb_importar
st_cliente st_cliente
gb_1 gb_1
gb_titulos gb_titulos
end type
global w_inicial w_inicial

type variables
nv_Funcoes inv_Funcoes
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

If inv_Funcoes.of_verifica_cliente(ll_idClifor) < 0 Then
	MessageBox('Dados do Cliente', 'Cliente informado inv$$HEX1$$e100$$ENDHEX$$lido.')
	Return 
End If

If lnv_Titulos.of_Importar(dw_contas_pagar, Long(em_idclifor.Text)) < 0 Then 
	of_Resetar_Tela( )
	Return
End If




end subroutine

public subroutine of_resetar_tela ();inv_Funcoes = Create nv_Funcoes

dw_contas_pagar.SetTransObject(SQLCA)
dw_contas_pagar.Reset()

dw_contabil_movimento.SetTransObject(SQLCA)
dw_contabil_movimento.Reset()

dw_contas_pagar_baixas.SetTransObject(SQLCA)
dw_contas_pagar_baixas.Reset()


end subroutine

event open;of_Resetar_Tela( )
end event

on w_inicial.create
this.em_forma=create em_forma
this.st_forma=create st_forma
this.dw_contabil_movimento=create dw_contabil_movimento
this.dw_contas_pagar_baixas=create dw_contas_pagar_baixas
this.cb_imprimir=create cb_imprimir
this.cb_baixar=create cb_baixar
this.cb_salvar=create cb_salvar
this.dw_contas_pagar=create dw_contas_pagar
this.em_idclifor=create em_idclifor
this.cb_importar=create cb_importar
this.st_cliente=create st_cliente
this.gb_1=create gb_1
this.gb_titulos=create gb_titulos
this.Control[]={this.em_forma,&
this.st_forma,&
this.dw_contabil_movimento,&
this.dw_contas_pagar_baixas,&
this.cb_imprimir,&
this.cb_baixar,&
this.cb_salvar,&
this.dw_contas_pagar,&
this.em_idclifor,&
this.cb_importar,&
this.st_cliente,&
this.gb_1,&
this.gb_titulos}
end on

on w_inicial.destroy
destroy(this.em_forma)
destroy(this.st_forma)
destroy(this.dw_contabil_movimento)
destroy(this.dw_contas_pagar_baixas)
destroy(this.cb_imprimir)
destroy(this.cb_baixar)
destroy(this.cb_salvar)
destroy(this.dw_contas_pagar)
destroy(this.em_idclifor)
destroy(this.cb_importar)
destroy(this.st_cliente)
destroy(this.gb_1)
destroy(this.gb_titulos)
end on

type em_forma from editmask within w_inicial
integer x = 2464
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
string mask = "##################"
end type

type st_forma from statictext within w_inicial
integer x = 1842
integer y = 88
integer width = 576
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Forma de Pagamento"
boolean focusrectangle = false
end type

type dw_contabil_movimento from datawindow within w_inicial
boolean visible = false
integer x = 3099
integer y = 2304
integer width = 1175
integer height = 124
integer taborder = 40
boolean titlebar = true
string title = "dw_contabil_movimento"
string dataobject = "d_contabil_movimento"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_contas_pagar_baixas from datawindow within w_inicial
boolean visible = false
integer x = 1906
integer y = 2304
integer width = 1175
integer height = 124
integer taborder = 40
boolean titlebar = true
string title = "dw_contas_pagar_baixas"
string dataobject = "d_contas_pagar_baixas"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_imprimir from commandbutton within w_inicial
integer x = 512
integer y = 2308
integer width = 457
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Imprimir"
end type

event clicked;inv_Funcoes.of_Imprimir(dw_contas_pagar )
end event

type cb_baixar from commandbutton within w_inicial
integer x = 4297
integer y = 2308
integer width = 457
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Gravar Baixas"
end type

event clicked;long ll_forma, ll_ret
datawindow ldw_save[]

ll_forma = long(em_forma.Text)

nv_Titulos lnv_Titulos
lnv_Titulos = Create nv_Titulos 


If inv_Funcoes.of_verifica_forma_pagamento(ll_forma) < 0 Then
	MessageBox('Dados informados', 'Forma de pagamento inv$$HEX1$$e100$$ENDHEX$$lida.')
End If

ll_ret = inv_Funcoes.of_baixa_titulo( ref dw_contas_pagar,ref dw_contas_pagar_baixas,ref dw_contabil_movimento, ll_forma)

if ll_ret < 0 then
	messagebox('Aviso','Grava$$HEX2$$e700e300$$ENDHEX$$o abortada.', StopSign!)
	return
else
	ldw_save[1]= dw_contas_pagar_baixas
	ldw_save[2]= dw_contabil_movimento
	
	
	If inv_Funcoes.of_update(ldw_save) < 0 Then
		MessageBox('Erro','Problemas durante a grava$$HEX2$$e700e300$$ENDHEX$$o.', StopSign!)
	Else
		inv_Funcoes.of_salvar_importado(dw_contas_pagar)
		of_Resetar_tela( )
	End If
	
	
end if
	
	





end event

type cb_salvar from commandbutton within w_inicial
integer x = 32
integer y = 2308
integer width = 457
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Salvar"
end type

event clicked;inv_Funcoes.of_Salvar_relatorio(dw_contas_pagar)
end event

type dw_contas_pagar from datawindow within w_inicial
integer x = 64
integer y = 276
integer width = 4645
integer height = 1976
integer taborder = 30
string title = "none"
string dataobject = "d_contas_pagar"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type em_idclifor from editmask within w_inicial
integer x = 489
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
string mask = "##################"
end type

type cb_importar from commandbutton within w_inicial
integer x = 4315
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
integer x = 59
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
integer x = 32
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
integer x = 32
integer y = 204
integer width = 4722
integer height = 2080
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

