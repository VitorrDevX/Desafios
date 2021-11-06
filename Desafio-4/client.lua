--[[ 
    ! - O que precisa ser feito
    ? - Informação sobre o detalhe
    * - Tópico
    
    TODO:
    
    * Parte do player
    ! Multa os jogadores que passarem a mais de 50 k/h ou 50 m/h nas áreas colocadas no config (GetEntitySpeed)
        ? A multa é salva na base de dados em qualquer tabela;
        ? As multas são acumulativas (Pegar o valor atual e somar + o valor da multa)
        ? Deixe a multa num valor aleatório entre 1000 e 2000 (math.random(cfg.multaMin, cfg.multaMax))
    ! Para ver as multas basta dar o comando /multas;
    ! Para pagar /multas pagar;
    ! Crie uma tabela para as localizações;  
]]

local ped = PlayerPedId()
local Tunnel = module("vrp","lib/Tunnel")
local vRP = Tunnel.getInterface("vRP")

-- radarFuncs = Tunnel.getInterface(radar:funcs')
-- local veiculo = GetVehiclePedIsIn(ped, true)
-- radarFuncs.aplicarMultas()

CreateThread(function()
    repeat 
        Wait(0)
        for i,v in ipairs (cfg.locs) do 
            local ped_cds = GetEntityCoords(ped)
            local distance = #(ped_cds - v)
            local veiculoPed = IsPedInAnyVehicle(ped, true)
            if distance <= 4.5 then -- Distancia
                if veiculoPed then -- Dentro do carro 
                    local valor = math.random(cfg.multaMin, cfg.multaMax)
                    local vel = GetEntitySpeed(ped)
                    local velocidade = (vel * 3.6);
                    if velocidade >= cfg.velocidade then 
                        TriggerServerEvent('aplicar:multas')
                        Wait(5000)
                    else 
                        TriggerEvent('Notify', 'aviso', '<b>[ RADAR ]</b> Voce ultrapassou o radar abaixo de ' .. cfg.velocidade .. 'km/h e não levou multas !')
                        Wait(10000)
                    end
                end
            end
        end
    until false
end)

CreateThread(function()
    for i, v in pairs(cfg.locs) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, cfg.blipType)
        SetBlipScale(blip, cfg.blipScale)
        SetBlipColour(blip, cfg.blipColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(cfg.blipName)
        EndTextCommandSetBlipName(blip)
    end
end)
