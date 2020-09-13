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

on nv_funcoes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_funcoes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

