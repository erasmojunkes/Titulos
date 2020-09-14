HA$PBExportHeader$nv_funcoes.sru
forward
global type nv_funcoes from nonvisualobject
end type
end forward

global type nv_funcoes from nonvisualobject
end type
global nv_funcoes nv_funcoes

forward prototypes
public function integer of_verifica_cliente (long al_idclifor)
public function string of_substituir (string as_texto, string as_remover, string as_inserir)
public function any of_null (any any_valor, any any_valor2)
public function DateTime of_get_data_atual ()
public function string of_abrir_arquivo (s_parametros ast_parametros)
public function integer of_salva_pdf (datawindow adw_relatorio)
public function integer of_imprimir (datawindow adw_relatorio)
public function longlong of_getctdplanilha ()
public function integer of_baixa_titulo (ref datawindow adw_contas_pagar, ref datawindow adw_contas_pagar_baixas, ref datawindow adw_contabil_movimento, long al_formapag)
public function integer of_update (datawindow arg[])
end prototypes

public function integer of_verifica_cliente (long al_idclifor);Long ll_Count

SELECT 
	COUNT(*)
INTO 
	:ll_Count
FROM
	CLIENTE_FORNECEDOR 
WHERE
	IDCLIFOR = :al_idClifor
USING 
	SQLCA;

If of_null( ll_Count, 0) > 0 Then
	Return 1
Else
	Return -1
End If

end function

public function string of_substituir (string as_texto, string as_remover, string as_inserir);long ll_start_pos=1


ll_start_pos = Pos(as_Texto, as_Remover, ll_start_pos)


Do While ll_start_pos > 0
	// Troca as_Remover por as_Inserir
	as_Texto = Replace(as_Texto, ll_start_pos, Len(as_Remover), as_Inserir)
	
	ll_start_pos = Pos(as_Texto, as_Remover, ll_start_pos+Len(as_Inserir))
loop

return as_Texto
end function

public function any of_null (any any_valor, any any_valor2);if isnull( any_Valor ) then
	return	any_Valor2
end if

return any_Valor
end function

public function DateTime of_get_data_atual ();DateTime ls_DataAtual

SELECT
	CURRENT_TIMESTAMP
INTO
	:ls_DataAtual
FROM 
	DUMMY
USING	
	SQLCA;

Return ls_DataAtual
end function

public function string of_abrir_arquivo (s_parametros ast_parametros);long ll_valor 
long ll_numext 
long ll_num    

string ls_titulo    
string ls_docname  
string ls_named     
string ls_extensao  
                    
String ls_NamedMultSelecao[]
Boolean lb_Xp

ls_titulo  = ast_Parametros.string[1]

if trim(ls_titulo) = "" or IsNull(ls_titulo) then
   ls_titulo = "Selecione o arquivo"
end if

ll_numext = UPPERBOUND(ast_Parametros.string)

for ll_num=2 to ll_numext
	ls_extensao = ls_extensao + trim(ast_Parametros.string[ll_num])
next

ll_valor = GetFileOpenName(ls_titulo,  ls_docname, ls_named, ls_extensao, ls_extensao,"",2)

IF ll_valor = -1 THEN
	ls_docname = ''
end if

Return string(ls_docname)
end function

public function integer of_salva_pdf (datawindow adw_relatorio);Integer li_NumeroArquivo
String ls_arquivo, ls_Processando

//GetFolder( 'Selecionar Pasta', Ref ls_arquivo )

adw_Relatorio.ModIfy("DataWindow.Export.PDF.Distill.CustomPostScript=No") 
adw_Relatorio.ModIfy("Datawindow.Export.PDF.Method = Distill!")
adw_Relatorio.ModIfy("Datawindow.Export.PDF.XSLFOP.Print=No")

ls_Processando = adw_Relatorio.describe("DataWindow.Processing")

Choose Case ls_Processando
	Case '!'
		messagebox('Problemas de cria$$HEX2$$e700e300$$ENDHEX$$o','Erro ao criar o relat$$HEX1$$f300$$ENDHEX$$rio.',Exclamation!)
		Return -1
	Case ''
		Return -1
	Case Else
		li_NumeroArquivo = adw_Relatorio.SaveAs(ls_arquivo, PDF!, True)
		//li_NumeroArquivo = adw_Relatorio.SaveAs()
		
		If li_NumeroArquivo <= 0 then
			messageBox('Erro ao criar arquivo', "VerIfique se o software GNU GhostScript esta instalado.~r~r"+&
															"Erro: "+string(li_NumeroArquivo), stopSign! )
			Return -1
		end If
End Choose
end function

public function integer of_imprimir (datawindow adw_relatorio);adw_relatorio.Print()

return 1
end function

public function longlong of_getctdplanilha ();longLong	ll_idplanilha
nv_connectdb	lnv_connectdb
Try
	lnv_connectdb = create nv_connectdb
	ll_idplanilha = lnv_connectdb.fnv_getidplanilha( sqlca )
Finally
	Destroy (lnv_connectdb)
End Try

return 	ll_idplanilha
end function

public function integer of_baixa_titulo (ref datawindow adw_contas_pagar, ref datawindow adw_contas_pagar_baixas, ref datawindow adw_contabil_movimento, long al_formapag);long ll_new, ll_idplanilha, ll_for, ll_newcontabil
long ll_idctacredito, ll_idctadebito
String ls_tiponaturezadeb, ls_tiponaturezacred




select coalesce(idctacredito,0) into : ll_idctacredito 
	from forma_pagrec 
	where idrecebimento =:al_formapag
	using sqlca;

if ll_idctacredito = 0 then
	messagebox('Aviso', 'Conta contabil da forma de pagamento '+string(al_formapag)+' n$$HEX1$$e300$$ENDHEX$$o configurada')
	return -1
end if
	

select  TIPONATUREZA into :ls_tiponaturezacred 
	from CONTABIL_PLANO_CONTAS 
	WHERE  IDCTACONTABIL = :ll_idctacredito USING SQLCA;	

for ll_for = 1 to adw_contas_pagar.Rowcount()
	
	ll_idplanilha = of_getctdplanilha()
	
	ll_new = adw_contas_pagar_baixas.InsertRow(0)
	
	adw_contas_pagar_baixas.SetItem(ll_new, 'IDEMPRESA', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
	adw_contas_pagar_baixas.SetItem(ll_new, 'IDCLIFOR', adw_contas_pagar.GetItemnumber(ll_for, 'IDCLIFOR'))
	adw_contas_pagar_baixas.SetItem(ll_new, 'DIGITOTITULO', adw_contas_pagar.GetItemString(ll_for, 'DIGITOTITULO'))
	adw_contas_pagar_baixas.SetItem(ll_new, 'SERIENOTA', adw_contas_pagar.GetItemString(ll_for, 'SERIENOTA'))
	adw_contas_pagar_baixas.SetItem(ll_new, 'IDPLANILHA', ll_idplanilha)	
	adw_contas_pagar_baixas.SetItem(ll_new, 'ORIGEMMOVIMENTO', adw_contas_pagar.GetItemString(ll_for, 'ORIGEMMOVIMENTO'))
	adw_contas_pagar_baixas.SetItem(ll_new, 'IDEMPRESABAIXA',adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
	adw_contas_pagar_baixas.SetItem(ll_new, 'DTPAGAMENTO',DATE(UF_DATAHORA()))
	adw_contas_pagar_baixas.SetItem(ll_new, 'VALPAGAMENTOTITULO',adw_contas_pagar.GetItemDecimal(ll_for, 'valorpagamento'))
	adw_contas_pagar_baixas.SetItem(ll_new, 'DTALTERACAO',DATE(UF_DATAHORA()))
	


	ll_newcontabil = adw_contabil_movimento.Insertrow(0)

	
	//CONTA CREDITO
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',1)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','C')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', 2)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', adw_contas_pagar.GetItemString(ll_for, 'ORIGEMMOVIMENTO'))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(UF_DATAHORA()))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',adw_contas_pagar.GetItemDecimal(ll_for, 'valorpagamento'))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO','BAIXA DE TITULOS SEFAZ')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA','C') // REVER
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(UF_DATAHORA()))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTULTIMAALTERACAO',UF_DATAHORA())
	adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
	
	
	
	ll_idctadebito = adw_contas_pagar.GetItemnumber(ll_for,'idctacredito')


	select  TIPONATUREZA into :ls_tiponaturezadeb 
		from CONTABIL_PLANO_CONTAS 
		WHERE  IDCTACONTABIL = :ll_idctadebito USING SQLCA;
	
	//CONTA DEBITO
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDCTACONTABIL',ll_idctadebito)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDPLANILHA',ll_idplanilha)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'NUMSEQUENCIA',1)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZALCTO','D')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESA', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDEMPRESADESTINO', adw_contas_pagar.GetItemnumber(ll_for, 'idempresa'))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'IDUSUARIO', 2)
	adw_contabil_movimento.SetItem(ll_newcontabil, 'ORIGEMMOVIMENTO', adw_contas_pagar.GetItemString(ll_for, 'ORIGEMMOVIMENTO'))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTMOVIMENTO',DATE(UF_DATAHORA()))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'VALLANCAMENTO',adw_contas_pagar.GetItemDecimal(ll_for, 'valorpagamento'))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'COMPLEMENTO','BAIXA DE TITULOS SEFAZ')
	adw_contabil_movimento.SetItem(ll_newcontabil, 'TIPONATUREZACTA',ls_tiponaturezadeb) // REVER
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTLANCAMENTO',DATE(UF_DATAHORA()))
	adw_contabil_movimento.SetItem(ll_newcontabil, 'DTULTIMAALTERACAO',UF_DATAHORA())
	adw_contabil_movimento.SetItem(ll_newcontabil, 'FLAGEXPORTADO','F')
	
	
next
return 1
end function

public function integer of_update (datawindow arg[]);int li_n,li_r
datawindow ldw_Datawindows

li_r = upperbound(arg)
for li_n = 1 to li_r
	
	ldw_Datawindows = arg[li_n]

	if not isvalid(arg[li_n]) then
		Continue
	end if	

	arg[li_n].SetTransObject(sqlca)

	if arg[li_n].AcceptText()=-1 then
		rollback using sqlca;
     	return -1 	   	
  	End if
	
	if arg[li_n].update(true,false)=-1 then			
	  	rollback using sqlca;
     	return -1 	   	
  	End if
next

commit using sqlca;


if sqlca.sqlcode=0 then
   for li_n=1 to li_r
		if not isvalid(arg[li_n]) then
			continue
		end if	
	   arg[li_n].resetupdate()  
   next
	
   return 1
Else
	Return -1
End if

return 1
end function

on nv_funcoes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_funcoes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

