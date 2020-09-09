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
end variables

forward prototypes
public function integer of_importar ()
public function String of_abrir_arquivo (s_parametros ast_parametros)
public function integer of_colunas_arquivo (string as_linha, ref string as_colunas[])
end prototypes

public function integer of_importar ();s_Parametros lst_Envio
String ls_CaminhoArquivo, ls_Linha, ls_Colunas[]
Long ll_Bytes, ll_Arquivo, ll_Linha, ll_For
Datastore ids_Arquivo

ids_Arquivo = Create DataStore

ids_Arquivo.DataObject = 'd_arquivotitulos'
ids_Arquivo.SetTransObject(SQLCA)

lst_Envio.String[1]  = 'Selecione arquivo da tabela IBPT para importar'
lst_Envio.string[2] = "Microsoft Excel (*.CSV),*.CSV,"

ls_CaminhoArquivo = of_abrir_arquivo( lst_Envio)


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
		

		// Inserir dados na dw de cada linha retornada
		ll_Linha = ids_Arquivo.InsertRow(0)
		ids_Arquivo.SetItem(ll_Linha, "chavenfe", String(ls_Colunas[1]))
		ids_Arquivo.SetItem(ll_Linha, "valoricms", Dec(ls_Colunas[9]))
	End If
Loop

FileClose(ll_Arquivo)

Return 1
end function

public function String of_abrir_arquivo (s_parametros ast_parametros);long ll_valor 
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


//SetCurrentDirectoryA(gs_DirApp)



return string(ls_docname)
end function

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

