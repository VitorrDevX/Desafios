local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-- local Tunnel = module("vrp","lib/Tunnel")
-- local radar = {}
-- Tunnel.bindInterface("radar:funcs", radar)

-- function radar.aplicarMultas()
--     local source = source
--     local user_id = vRP.getUserId(source)
--     local valor = math.random(cfg.multaMin, cfg.multaMax)
--     local total = vRP.getUData(user_id, "vRP:multas") 
--     vRP.setUData(user_id,"vRP:multas",total+valor)
--     vRP.tryFullPayment(user_id, valor)
-- end

-- PlaySoundFrontend(soundId, audioName, audioRef, p3)
-- vRPclient._playScreenEffect(source, name, duration)

RegisterNetEvent('aplicar:multas', function()
    local source = source
    local user_id = vRP.getUserId(source)
    local valor = math.random(cfg.multaMin, cfg.multaMax)
    local total = vRP.getUData(user_id, "vRP:multas") 
    vRP.setUData(user_id,"vRP:multas",total + valor)
    TriggerClientEvent('Notify', source, 'aviso', '<b>[ RADAR ]</b> Voce foi multado por ultrapassar a velocidade permitida de <b>' .. cfg.velocidade .. '</b>km/h !')
    if vRP.tryFullPayment(user_id, valor) then
        vRP.setUData(user_id,"vRP:multas", 0)
        TriggerClientEvent("Notify",source,"sucesso","<b>[ RADAR ]</b> Você pagou as multas por ter dinheiro na carteira !")
    end 
end)


RegisterCommand('multas',function(source,args)
    local source = source
    local user_id = vRP.getUserId(source)
    local dinheiroDoPlayer = vRP.getMoney(user_id)
    local valor = vRP.getUData(user_id, "vRP:multas")
    local multas = json.decode(valor) or 0
    if args[1] == nil then
        if multas >= 1 then
            TriggerClientEvent("Notify",source,"aviso","<b>[ RADAR ]</b> Você tem R$"..multas.." em multas para pagar.") -- Valor das multas
        else
            TriggerClientEvent("Notify",source,"aviso","<b>[ RADAR ]</b> Você não tem multas para pagar.") -- Sem multas para pagar
        end
    elseif args[1] == "pagar" then
        if multas >= 1 then
            if vRP.request(source ,'<b>[RADAR]</b> Deseja pagar R$' .. valor .. ' em multas ?',30) then -- Fazendo a request
                if dinheiroDoPlayer >= multas then
                    local total = vRP.getUData(user_id, "vRP:multas") 
                    vRP.setMoney(user_id, dinheiroDoPlayer - total)
                    vRP.setUData(user_id, "vRP:multas", '0')
                    TriggerClientEvent("Notify",source,"sucesso","<b>[ RADAR ]</b> Você pagou R$"..multas.." de multas.") -- Pagando as multas
                else
                    TriggerClientEvent("Notify",source,"negado","<b>[ RADAR ]</b> Você não tem dinheiro suficiente para isso.") -- Sem dinheiro
                end
            else
                TriggerClientEvent("Notify",source,"negado","<b>[ RADAR ]</b> O operador da conta bancaria recusou o pagamento !")
            end
        else 
            TriggerClientEvent("Notify",source,"aviso","<b>[ RADAR ]</b> Você não tem multas para pagar.") -- Sem multas
        end
    end
end)
