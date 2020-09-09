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

on nv_funcoes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_funcoes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

