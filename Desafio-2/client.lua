--[[ 
    TODO:
        * Colocar um marcador no chão;
        * Verificar o clique da letra (Fazer devidos de distância);
        * Ao clicar letra E:
            ! Ver se o veículo não é uma moto;
            ! Ver se o player está fora do veículo;
            * Abrir as portas do veículo
            * Criado um texto 3d na coordenada da porta
            * Ao se aproximar pode pressionar a tecla E
                * Uma animação é dada
                * 5 segundos depois é pausada
                * A porta do carro sai
                * Aparece um novo texto 3d em uma nova localização
                * Ao se aproxima e pressionar a porta some
                * Uma nova porta aparece, caso não tenha nenhuma mais, o carro é deletado
]]


local Tunnel = module("vrp","lib/Tunnel")
vRP = Tunnel.getInterface("vRP")
perm = Tunnel.getInterface("perm")

local cdsInicioDesmanche = {
    [1] = vec3(-1952.0517578125, 3306.4626464844, 32.960231781006),
}
local cdsEntregaPorta = {
    [1] = vec3(-1954.8822021484, 3301.7270507813, 32.960235595703),
}
local key
local portaAtual = 0
local estaDesmanchando = false
local estaEntregandoPorta = false
local vehicle
local porta
local nomeOssosPeloIndice = {
    [0] = 'door_dside_f',
    [1] = 'door_pside_f',
    [2] = 'door_dside_r',
    [3] = 'door_pside_r'
}
local agacharDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
local agacharAnim = "machinic_loop_mechandplayer"
local segurarPortaDict = "anim@heists@box_carry@"
local segurarPortaAnim = "idle"


CreateThread(function(source)
    local user_id = vRP.getUserId(source)
    while true do
        local idle = 1000
        local ped = PlayerPedId()
        local cds = GetEntityCoords(ped)
        for k,v in ipairs(cdsInicioDesmanche) do
            local distancia = #(v - cds)
            if distancia < 20 and not estaDesmanchando and not estaEntregandoPorta then
                idle = 0 
                DrawMarker(27, v.x,v.y,v.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 4.0, 255, 0, 0, 255, false, false, 2, true)
                drawText3D(v.x,v.y,v.z,'PRESSIONE ~p~[E] ~w~PARA INICIAR O DESMANCHE')
                if distancia < 2 and IsControlJustPressed(0, 38) then
                    if perm.checkPerm() == true then
                        vehicle = GetVehiclePedIsIn(ped, true)
                        if vehicle ~= 0 then
                            local vehicle_cds = GetEntityCoords(vehicle)
                            if #(vehicle_cds - v) < 4 then
                                local class = GetVehicleClass(vehicle)
                                if class ~= 8 and class ~= 13 then
                                    if not IsPedInAnyVehicle(ped, true) then
                                        SetVehicleFixed(vehicle)
                                        for i = 0, 3 do
                                            SetVehicleDoorOpen(vehicle, i, false, false)
                                        end
                                        SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                                        FreezeEntityPosition(vehicle, true)
                                        TriggerEvent('Notify', 'sucesso', 'Desmanche iniciado')
                                        key = k
                                        removerPortas()
                                    else
                                        TriggerEvent('Notify', 'negado', 'Saia do carro para desmanchar')
                                    end
                                else
                                    TriggerEvent('Notify', 'negado', 'Motos e bicicletas não são permitidas.')
                                end
                            else
                                TriggerEvent('Notify', 'negado', 'Aproxime o veículo.')
                            end
                        else
                            TriggerEvent('Notify', 'negado', 'Não existe veiculo')
                        end
                    else
                        TriggerEvent('Notify', 'negado', 'Você não tem permissão')
                    end
                end
            end
        end
        Wait(idle)
    end
end)

function removerPortas()
    estaDesmanchando = true
    CreateThread(function()
        repeat
            if not estaEntregandoPorta then
                local ped = PlayerPedId()
                local cds = GetEntityCoords(ped)
                local bone = GetEntityBoneIndexByName(vehicle, nomeOssosPeloIndice[portaAtual])
                local bone_cds = GetWorldPositionOfEntityBone(vehicle, bone)
                local distancia = #(cds - bone_cds)
                drawText3D(bone_cds.x,bone_cds.y,bone_cds.z,'PRESSIONE ~p~[E] ~w~PARA REMOVER ESSA PORTA')
                if distancia < 0.8 and IsControlJustPressed(0, 38) then
                    TriggerEvent('progess', 5000, 'Produzindo')
                    requestAnimDict(agacharDict)
                    TaskPlayAnim(ped, agacharDict, agacharAnim, 4.0, 4.0, -1, 1, 1.0, true, true, true)
                    Wait(5000)
                    ClearPedTasks(ped)
                    SetVehicleDoorBroken(vehicle, portaAtual, true)
                    porta = CreateObject(`imp_prop_impexp_car_door_01a`, cds, true, true)
                    AttachEntityToEntity(porta, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, false, true, true)
                    requestAnimDict(segurarPortaDict)
                    TaskPlayAnim(ped, segurarPortaDict, segurarPortaAnim, 4.0, 4.0, -1, 49, 1.0)
                    entregarPorta()
                end
            end
            Wait(0)
        until not estaDesmanchando
    end)
end

function entregarPorta()
    estaEntregandoPorta = true
    CreateThread(function()
        repeat
            drawText3D(cdsEntregaPorta[key].x,cdsEntregaPorta[key].y,cdsEntregaPorta[key].z,'PRESSIONE ~p~[E] ~w~PARA ENTREGAR PORTA')
            local ped = PlayerPedId()
            local cds = GetEntityCoords(ped)
            local distancia = #(cds - cdsEntregaPorta[key])
            if distancia < 1 and IsControlJustPressed(0, 38) then
                ClearPedTasks(ped)
                DeleteEntity(porta)
                estaEntregandoPorta = false
                TriggerEvent('Notify', 'aviso', 'Faltam ' .. 3 - portaAtual .. ' portas')
                proximoPasso()
                break
            end
            Wait(0)
        until false
    end)
end

function proximoPasso()
    if portaAtual >= 3 then
        DeleteEntity(vehicle)
        perm.darMoney()
        TriggerEvent('Notify', 'sucesso', 'Desmanche Finalizado')
        portaAtual = 0
        estaDesmanchando = false
        estaEntregandoPorta = false
        vehicle = nil
        porta = nil
    else
        portaAtual = portaAtual + 1
    end
end

function requestAnimDict(dict)
    RequestAnimDict(dict)
    repeat
        Wait(0)
    until HasAnimDictLoaded(dict)
end

function drawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.39, 0.39)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 235)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 270
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.04, 0, 0, 0, 145)
end
