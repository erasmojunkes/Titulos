HA$PBExportHeader$nv_titulos.sru
forward
global type nv_titulos from nonvisualobject
end type
end forward

global type nv_titulos from nonvisualobject
end type
global nv_titulos nv_titulos

type variables
nv_Funcoes inv_Funcoes
uo_Progresso iuo_BarraProgresso
end variables

forward prototypes
public function integer of_colunas_arquivo (string as_linha, ref string as_colunas[])
public function integer of_importar (datawindow adw_contas_pagar)
public subroutine of_adicionar_divergencia (datastore ads_divergencias, string as_chavenfe, long al_idtitulo, string as_digitotitulo, string as_descricaodivergencia)
public function integer of_processar_titulos (datastore ads_arquivo, datawindow adw_contaspagar)
public function integer of_processa_titulo (datastore ads_arquivo, datawindow adw_contaspagar)
end prototypes

public function integer of_colunas_arquivo (string as_linha, ref string as_colunas[]);String ls_Value
Long ll_Pos, ll_Cont

Do 
	
	ll_Pos = Pos(as_Linha, ";")
	
	// Fim da linha
	if ll_Pos = 0 Then 
		ls_Value = Mid(as_Linha, 1)
	Else 
		ls_Value = Mid(as_Linha, 1, ll_Pos -1)
	End if 
	
	ll_Cont ++
	ls_Value = inv_Funcoes.of_substituir(ls_Value, '"','')
	ls_Value = inv_Funcoes.of_substituir(ls_Value, "'",'')
	as_Colunas[ll_Cont] = ls_Value
	
	as_Linha = Mid(as_Linha, ll_Pos +1)

	Yield( )

Loop While (Len(as_Linha) > 0 and ll_Pos > 0 )

Return 1
end function

public function integer of_importar (datawindow adw_contas_pagar);s_Parametros lst_Envio
String ls_CaminhoArquivo, ls_Linha, ls_Colunas[], ls_ChaveAntiga
Long ll_Bytes, ll_Arquivo, ll_Linha, ll_For
Datastore lds_Arquivo

lds_Arquivo = Create DataStore

lds_Arquivo.DataObject = 'd_arquivotitulos'
lds_Arquivo.SetTransObject(SQLCA)

lst_Envio.String[1]  = 'Selecione arquivo da tabela IBPT para importar'
lst_Envio.string[2] = "Microsoft Excel (*.CSV),*.CSV,"

ls_CaminhoArquivo = inv_Funcoes.of_abrir_arquivo( lst_Envio)


If ls_CaminhoArquivo = '' Then
	MessageBox('Importa$$HEX2$$e700e300$$ENDHEX$$o de Arquivo', 'Problemas ao importar o arquivo, verifique a formata$$HEX2$$e700e300$$ENDHEX$$o ou endere$$HEX1$$e700$$ENDHEX$$o e tente novamente.')
	Return -1 
End If 

ll_Arquivo = FileOpen(ls_CaminhoArquivo, LineMode!, Read!)

if ll_Arquivo < 0 Then
	MessageBox('Abrir Arquivo', "Falha ao abrir arquivo selecionado.")
	Return -1
End if

// Ler linha do arquivo
ll_Bytes = FileReadEx(ll_Arquivo, ls_Linha)
Do While (ll_Bytes > 0)
	
	// Obter valores das colunas
	if of_colunas_arquivo(ls_Linha, ls_Colunas) < 0 Then
		MessageBox('Importa$$HEX2$$e700e300$$ENDHEX$$o de Arquivo', 'Problemas ao ler uma linha do arquivo.')
		Return -1
	End if
	
	//Faz um loop para garantir que n$$HEX1$$e300$$ENDHEX$$o vai sair do while por causa de uma linha em branco
	For ll_For = 1 To 5
		// Ler proxima linha
		ll_Bytes = FileReadEx(ll_Arquivo, ls_Linha)
		
		If ll_Bytes > 0 Then Exit
	Next
	
	If UpperBound(ls_Colunas) > 8 Then
		if Len(ls_Colunas[1]) <> 44 Then
			Continue
		End if
		
		If ls_Colunas[1] <> ls_ChaveAntiga Then
			// Inserir dados na dw de cada linha retornada
			ll_Linha = lds_Arquivo.InsertRow(0)
			lds_Arquivo.SetItem(ll_Linha, "chavenfe", String(ls_Colunas[1]))
			lds_Arquivo.SetItem(ll_Linha, "valoricms", Dec(ls_Colunas[9]))
			
			//Atualiza, pra esta ser a chave antiga
			ls_ChaveAntiga = ls_Colunas[1]
		End If
	End If
Loop

FileClose(ll_Arquivo)

If of_processa_titulo(lds_Arquivo, adw_contas_pagar) < 0 Then 
	Return -1
End If


Return 1
end function

public subroutine of_adicionar_divergencia (datastore ads_divergencias, string as_chavenfe, long al_idtitulo, string as_digitotitulo, string as_descricaodivergencia);Long ll_NovaLinha
Long ll_Null

If al_idTitulo = 0 Then
	SetNull(ll_Null)
	al_idTitulo = ll_Null
End If

ll_NovaLinha = ads_divergencias.InsertRow(0)

ads_divergencias.SetItem(ll_NovaLinha, 'chavenfe', as_ChaveNFE )
ads_divergencias.SetItem(ll_NovaLinha, 'idtitulo', al_idTitulo )
ads_divergencias.SetItem(ll_NovaLinha, 'digitotiulo', as_DigitoTitulo)
ads_divergencias.SetItem(ll_NovaLinha, 'descricaodivergencia', as_DescricaoDivergencia)

end subroutine

public function integer of_processar_titulos (datastore ads_arquivo, datawindow adw_contaspagar);String ls_ChaveNFE, ls_DigitoTitulo
Long ll_For, ll_Retrieve, ll_Titulo
Decimal  lde_ValorArquivo, lde_SaldoTitulo
DataStore lds_ContasPagar, lds_Divergencias
Date ld_DataAtual, ld_DataVencimentoTitulo
s_Parametros lst_Divergencias

lds_Divergencias = Create DataStore
lds_ContasPagar = Create DataStore

lds_ContasPagar.DataObject = 'd_contas_pagar'
lds_ContasPagar.SetTransObject(SQLCA)

lds_Divergencias.DataObject = 'd_divergencias'
lds_Divergencias.SetTransObject(SQLCA)

ld_DataAtual = Date(inv_Funcoes.of_get_data_atual( ))

For ll_For = 1 To ads_Arquivo.RowCount()
	
	If IsValid(iuo_BarraProgresso) Then
		iuo_BarraProgresso.of_Atualizar( ll_For, ads_Arquivo.RowCount())
	End If
	
	ls_ChaveNFE = ads_Arquivo.GetItemString(ll_For, 'chavenfe')

	ll_Retrieve = lds_ContasPagar.Retrieve(ls_ChaveNFE)
	

	If ll_Retrieve =  0 Then
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,0,'', 'N$$HEX1$$e300$$ENDHEX$$o foi poss$$HEX1$$ed00$$ENDHEX$$vel encontrar nenhum t$$HEX1$$ed00$$ENDHEX$$tulo relacionado a nota.')
		Continue
	End If
	
	If ll_Retrieve < 0 Then
		MessageBox('Buscando T$$HEX1$$ed00$$ENDHEX$$tulos', 'Problemas ao carregar os t$$HEX1$$ed00$$ENDHEX$$tulos relacionados.')
		Return -1
	End If
	
	If ll_Retrieve > 1 Then
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,0,'', 'Mais de uma parcela para o t$$HEX1$$ed00$$ENDHEX$$tulo, n$$HEX1$$e300$$ENDHEX$$o foi possivel importar.')
		Continue
	End If
	
	ll_Titulo = lds_ContasPagar.GetItemDecimal(1, 'idtitulo')
	ls_DigitoTitulo = lds_ContasPagar.GetItemString(1, 'digitotitulo')
	
	//Se encontrou um titulo bloquado, ele cancela a baixa do registro
	If inv_Funcoes.of_null(lds_ContasPagar.GetItemDecimal(1,'flagtitulobloquado'),'F') = 'T' Then 
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,ll_Titulo ,ls_DigitoTitulo , 'O t$$HEX1$$ed00$$ENDHEX$$tulo se encontra bloquado e n$$HEX1$$e300$$ENDHEX$$o pode ser baixado.')
		Continue
	End If
	
	
	ld_DataVencimentoTitulo = lds_ContasPagar.GetItemDate(1,'dtvencimento')

	//Se encontrou um titulo vencido, ele cancela a baixa do registro
	If ld_DataVencimentoTitulo < ld_DataAtual Then 
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,ll_Titulo ,ls_DigitoTitulo , 'O t$$HEX1$$ed00$$ENDHEX$$tulo se encontra vencido e n$$HEX1$$e300$$ENDHEX$$o pode ser baixado.')
		Continue
	End If
	
	lde_ValorArquivo = ads_Arquivo.GetItemDecimal(1,'valoricms')
	lde_SaldoTitulo = lds_ContasPagar.GetItemDecimal(1,'valliquidotit')
	
	If lde_ValorArquivo > lde_SaldoTitulo Then
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,ll_Titulo ,ls_DigitoTitulo , &
										"T$$HEX1$$ed00$$ENDHEX$$tulo com saldo("+ String(lde_SaldoTitulo,"###,###,###.00") + ") menor que o valor a ser baixado pelo arquivo("+ String(lde_ValorArquivo,"###,###,###.00") + ").")
		Continue
	End If
	
	If lde_ValorArquivo > lde_SaldoTitulo Then
		of_adicionar_divergencia(lds_Divergencias, ls_ChaveNFE,ll_Titulo ,ls_DigitoTitulo , &
										"T$$HEX1$$ed00$$ENDHEX$$tulo sera baixado parcialmente. Saldo do Titulo: " + String(lde_SaldoTitulo,"###,###,###.00") +"; Valor Arquivo: " + String(lde_ValorArquivo,"###,###,###.00") + "." )
	End If
	
	If lds_ContasPagar.RowsMove( 1, lds_ContasPagar.RowCount(), Primary!, adw_ContasPagar, 1, Primary!) < 0 Then
		MessageBox('Problemas ao manipular o T$$HEX1$$ed00$$ENDHEX$$tulo', 'T$$HEX1$$ed00$$ENDHEX$$tulo n$$HEX1$$e300$$ENDHEX$$o pode ser carregada para o Sistema.')
		Return -1
	End If
	
Next

If lds_Divergencias.RowCount() > 0 Then 
	lst_Divergencias.PowerObj[1] = lds_Divergencias
	OpenWithParm(w_divergencias, lst_Divergencias)

	lst_Divergencias = Message.PowerObjectParm
	
	If lst_Divergencias.Long[1] < 0 Then
		Return -1
	End If
End If

Return 1
end function

public function integer of_processa_titulo (datastore ads_arquivo, datawindow adw_contaspagar);Long ll_Retorno

If ads_Arquivo.RowCount() > 0 Then
	w_Inicial.OpenUserObject(iuo_BarraProgresso)
	iuo_BarraProgresso.of_definir_valores( 1, ads_Arquivo.RowCount() , 1,'Relacionando T$$HEX1$$ed00$$ENDHEX$$tulos com o Arquivo. Aguarde...') 
End If

ll_Retorno = of_processar_titulos( ads_arquivo, adw_contaspagar)

//Assim consegue fechar a barra de progresso, idependente do retorno da tela
w_Inicial.CloseUserObject(iuo_BarraProgresso)

Return ll_Retorno
end function

on nv_titulos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_titulos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;inv_Funcoes = Create nv_Funcoes
end event

