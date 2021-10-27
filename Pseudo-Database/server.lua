-- local primeiraVez = true

-- RegisterCommand('add',function(source,args,rawCommand)
-- 	if primeiraVez == true then =
-- 		local primeiraVez = false
-- 		vRP._prepare('addNumero', 'INSERT into curso (numero) values (0);')
-- 		vRP.execute('addNumero')
-- 		TriggerClientEvent('Notify',source, 'sucesso', 'O numero 0 foi adicionado')
-- 		vezes = 1
-- 	elseif vezes == 1 then 
-- 		vRP._prepare('numero1', 'UPDATE curso SET numero = 1 WHERE numero = 0')
-- 		vRP.execute('numero1')
-- 		TriggerClientEvent('Notify',source, 'sucesso', 'O numero 0 foi para 1')
-- 		vezes = 2
-- 	elseif vezes == 2 then 
-- 		vRP._prepare('numero2', 'UPDATE curso SET numero = 2 WHERE numero = 1')
-- 		vRP.execute('numero2')
-- 		TriggerClientEvent('Notify',source, 'sucesso', 'O numero 1 foi para 2')
-- 		vezes = 3
-- 	elseif vezes == 3 then 
-- 		vRP._prepare('numero3', 'UPDATE curso SET numero = 3 WHERE numero = 2')
-- 		vRP.execute('numero3')
-- 		TriggerClientEvent('Notify',source, 'sucesso', 'O numero 2 foi para 3')
-- 		vezes = 4
-- 	elseif vezes == 4 then 
-- 		vRP._prepare('deletarTudo', 'DELETE FROM curso WHERE `numero`= 3')
-- 		vRP.execute('deletarTudo')
-- 		TriggerClientEvent('Notify',source, 'sucesso', 'O ciclo acabou !')
-- 		local primeiraVez = true
-- 	end
-- end)
vRP._prepare('addNumero', 'INSERT into curso (numero) values (0);')
vRP._prepare('select', 'SELECT * FROM curso')
vRP._prepare('deletar', 'DELETE FROM curso')
vRP._prepare('update', 'UPDATE curso SET numero = @numero')

RegisterCommand('add', function()
	local consultar = vRP.query('select')
	if #consultar >= 1 then
		if consultar[1].numero < 3 then
			local numero2 = consultar[1].numero
			vRP.execute('update', {numero = numero2 + 1})
			-- print('O numero '.. numero2 .. ' somou 1 e passou a ser '.. numero2 + 1)
			TriggerClientEvent('Notify',source, 'importante', 'O numero '.. numero2 .. ' somou 1 e passou a ser '.. numero2 + 1)
		else
			vRP.execute('deletar')
			-- print('O numero atingiu 4 e foi resetado')
			TriggerClientEvent('Notify',source, 'aviso', 'O numero atingiu 4 e foi resetado')
		end
	else
		vRP.execute('addNumero')
		print('O numero 0 foi adicionado na tabela')
		TriggerClientEvent('Notify',source, 'aviso', 'O numero 0 foi adicionado na tabela')
	end
end)
