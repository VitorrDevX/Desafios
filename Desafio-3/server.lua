local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local Tunnel = module("vrp","lib/Tunnel")
local funcs = {}
Tunnel.bindInterface("hp:funcs", funcs)

function funcs.pagamento() 
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.request(user_id, "Deseja pagar R$1000 pelo tratamento ?", 30) then
        vRP.tryPayment(user_id, 1000)
        TriggerClientEvent('Notify' , source, 'sucesso', 'O tratamento foi pago com sucesso !')
        return true
    else
        TriggerClientEvent('Notify' , source, 'negado', 'O tratamento foi negado !')
        return false
    end
end

function funcs.checkToogle()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local hp = vRP.getUsersByPermission("paramedico.permissao")
        if parseInt(#hp) >= 1 then
            return true
        else
            return false
        end
    end
end

function funcs.darVida()
	repeat
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+1)
		Citizen.Wait(1500)
	until GetEntityHealth(PlayerPedId()) >= 240 or GetEntityHealth(PlayerPedId()) <= 100
    EnableAllControlActions(0)
    ClearPedTasks(ped)
    TriggerEvent('Notify', 'aviso', "Seu tratamento acabou")
end
