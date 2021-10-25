local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local Tunnel = module("vrp","lib/Tunnel")
local funcs = {}
Tunnel.bindInterface("perm", funcs)

function funcs.checkPerm()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id, "desmanche.permissao")
end

function funcs.darMoney()
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.giveMoney(user_id, 10000)
	TriggerClientEvent('Notify', source, 'sucesso', 'Recebeu 10.000 por terminar o desmanche')
end
